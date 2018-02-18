module Automator

  require 'capybara/poltergeist'
  require 'selenium-webdriver'
  require 'net/http'
  require 'rmagick'

  def self.aggregate_headlines_and_take_snapshot site, thumbnail = false

    options = Selenium::WebDriver::Chrome::Options.new(args: ['headless', "--user-agent='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36'"], binary: ENV['GOOGLE_CHROME_SHIM'])

    # session.driver.headers = { "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36" }

    driver = Selenium::WebDriver.for(:chrome, options: options)
    driver.get(site.url)
    puts driver.title

    width  = driver.execute_script("return Math.max(document.body.scrollWidth, document.body.offsetWidth, document.documentElement.clientWidth, document.documentElement.scrollWidth, document.documentElement.offsetWidth, 924);")
    height = driver.execute_script("return Math.min(Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight, 668),4900);")

    puts "height: " + height.to_s

    sleep rand(17..24)

    # Add some pixels on top of the calculated dimensions for good
    # measure to make the scroll bars disappear
    #
    driver.manage.window.resize_to(width+100, height+100)

    begin
      driver.execute_script(site.script) unless site.script.nil?
    rescue
    end

    # driver.execute_script('function loopWithDelay() { setTimeout(function () { var scroll_depth = Math.max(window.pageYOffset, document.documentElement.scrollTop, document.body.scrollTop); if (scroll_depth > 1024) { window.scrollBy(0,-1024); loopWithDelay(); } else { window.scrollTo(0,0); return; } },1000); }; window.scrollTo(0,document.body.scrollHeight); loopWithDelay();')

    puts "success"

    # These two lines seem to allow the page more time to load (on WaPo, at least), which results in the actual screenshot looking right instead of having a bunch of empty boxes
    image_throwaway = nil
    image_throwaway = driver.screenshot_as(:png) if driver.screenshot_as(:png).nil? == false

    sleep rand(17..24)

    snapshot_name = "#{site.shortcode}-#{ Time.now.strftime("%Y-%m-%d-%H-%M-%z") }.png"
    # driver.save_screenshot(snapshot_name)

    s3 = Aws::S3::Resource.new
    bucket = s3.bucket(ENV['S3_BUCKET'])

    images_arr = []
    images_arr << Base64.decode64(driver.screenshot_as(:base64))
    images_arr << Magick::Image.from_blob(images_arr[0]).first.resize_to_fill(300,600,Magick::NorthWestGravity).to_blob if thumbnail

    images_arr.each_with_index do |image, index|

      if index == 0
        obj = bucket.object(snapshot_name)
      else
        obj = bucket.object(("thumb-" + snapshot_name))
      end
      obj.put(body: image)
      obj.etag

    end

    obj = bucket.object(snapshot_name[0..(snapshot_name.length - 5)] + ".html")
    obj.put(body: driver.page_source)
    obj.etag

    if thumbnail
      new_snapshot = Snapshot.new :filename => snapshot_name, :thumbnail => ("thumb-" + snapshot_name), :site => site
    else
      new_snapshot = Snapshot.new :filename => snapshot_name, :site => site
    end
    new_snapshot.save

    headlines = driver.find_elements(:css, "#{site.selector}")

    headlines.each do |headline|

      begin

        # if Story doesn't exist, create it before creating the Headline
        if Story.where(:url => headline[:href]).count == 0

          new_story = Story.new :url => headline[:href], :site => site
          new_story.save

          new_headline = Headline.new :title => headline.text, :url => headline[:href], :snapshot => new_snapshot, :story => new_story
          new_headline.save

        # if Story does exist, link it to the new Headline when it's created
        else

          new_headline = Headline.new :title => headline.text, :url => headline[:href], :snapshot => new_snapshot, :story => Story.where(:url => headline[:href]).first
          new_headline.save

        end

      rescue
      end

    end

    driver.quit

  end

  def self.create_screenshot sites_list, save_to_s3 = true

    sites_list.each do |title, url|

      Capybara.javascript_driver = :poltergeist
      Capybara.current_driver = :poltergeist

      Capybara.register_driver :poltergeist do |app|
        options = {
          :js_errors => true,
          :timeout => 60,
          :debug => true,
          :window_size => [1024,768]
        }
        Capybara::Poltergeist::Driver.new(app, options)
      end

      session = Capybara::Session.new(:poltergeist)

  		session.driver.headers = { 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36' }
  		session.visit url       # go to a web page (first request will take a bit)

      session.execute_script('function loopWithDelay() { setTimeout(function () { if (document.body.scrollTop > 1024) { window.scrollBy(0,-1024); loopWithDelay(); } else { window.scrollTo(0,0); return; } },1000); }; window.scrollTo(0,document.body.scrollHeight); loopWithDelay();')
      sleep rand(17..24)

      if save_to_s3

        images_arr = []
        images_arr << Base64.decode64(session.driver.render_base64(:png, full: true))
        images_arr << Magick::Image.from_blob(images_arr[0]).first.resize_to_fill(300,600,Magick::NorthWestGravity).to_blob

        images_arr.each_with_index do |image, index|

          s3 = Aws::S3::Resource.new
          bucket = s3.bucket(ENV['S3_BUCKET'])
          obj = bucket.object("#{index}-#{title}-#{ Time.now.strftime("%Y-%m-%d-%H-%M-%z") }.png")
          obj.put(body: image)
          obj.etag

        end

      else

        image_throwaway = nil
        image_throwaway = Base64.decode64(session.driver.render_base64(:png, full: true))
        session.driver.save_screenshot('capture_before.png', :full => true)
        puts "HELLO ARE YOU THERE"
        begin
          # script_text = ''
          # session.execute_script(script_text)
        rescue
        end
        # sleep 10
        session.driver.save_screenshot('capture_after.png', :full => true)

      end

      session.driver.quit

    end


  end

  def self.aggregate_headlines url_addr, selector

    Capybara.javascript_driver = :poltergeist
    Capybara.current_driver = :poltergeist

    Capybara.register_driver :poltergeist do |app|
      options = {
        :js_errors => true,
        :timeout => 30,
        :debug => true,
        :window_size => [1024,768],
        :phantomjs_options => ['--load-images=no', '--ignore-ssl-errors=yes']
      }
      Capybara::Poltergeist::Driver.new(app, options)
    end

    session = Capybara::Session.new(:poltergeist)

    session.driver.headers = { "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36" }
    session.visit url_addr       # go to a web page (first request will take a bit)

    headlines = session.all(:css, selector)

    headlines.each do |headline|
      puts headline.text
    end

    session.driver.quit

  end

  def self.create_thumbnail image, to_file_too = false

    source = Magick::Image.read(image).first
    source = source.resize_to_fill(300,600,Magick::NorthWestGravity)

    source.write("capture_thumb.png") if to_file_too


  end

  def self.save_html site

    Capybara.javascript_driver = :poltergeist
    Capybara.current_driver = :poltergeist

    Capybara.register_driver :poltergeist do |app|
      options = {
        :js_errors => false,
        :timeout => 60,
        :debug => true,
        :window_size => [1024,768]
      }
      Capybara::Poltergeist::Driver.new(app, options)
    end

    session = Capybara::Session.new(:poltergeist)

    session.driver.headers = { "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36" }
    session.visit site      # go to a web page (first request will take a bit)

    # print session.driver.html
    page_content = session.html
    File.open( "output.html", "w+" ) { |f| f.write page_content }

    s3 = Aws::S3::Resource.new
    bucket = s3.bucket(ENV['S3_BUCKET'])
    obj = bucket.object("test_page.html")
    obj.put(body: page_content)
    obj.etag

  end

end
