module Automator

  require 'capybara/poltergeist'
  require 'net/http'
  require 'rmagick'

  def self.create_screenshot sites_list, save_to_s3 = true

    sites_list.each do |title, url|

      Capybara.javascript_driver = :poltergeist
      Capybara.current_driver = :poltergeist

      Capybara.register_driver :poltergeist do |app|
        options = {
          :js_errors => false,
          :timeout => 60,
          :debug => false,
          :window_size => [1024,768]
        }
        Capybara::Poltergeist::Driver.new(app, options)
      end

      session = Capybara::Session.new(:poltergeist)

  		session.driver.headers = { 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36' }
  		session.visit url       # go to a web page (first request will take a bit)

      if save_to_s3

        session.execute_script('function loopWithDelay() { setTimeout(function () { if (document.body.scrollTop > 1024) { window.scrollBy(0,-1024); loopWithDelay(); } else { window.scrollTo(0,0); return; } },1000); }; window.scrollTo(0,document.body.scrollHeight); loopWithDelay();')

        sleep 20

        images_arr = []
        images_arr << Base64.decode64(session.driver.render_base64(:png, full: true))
        images_arr << Magick::Image.from_blob(images_arr[0]).first.resize_to_fill(300,300,Magick::NorthWestGravity).to_blob

        images_arr.each_with_index do |image, index|

          s3 = Aws::S3::Resource.new
          bucket = s3.bucket(ENV['S3_BUCKET'])
          obj = bucket.object("#{index}-#{title}-#{ Time.now.strftime("%Y-%m-%d-%H-%M-%z") }.png")
          obj.put(body: image)
          obj.etag

        end

      else

        session.execute_script('function loopWithDelay() { setTimeout(function () { if (document.body.scrollTop > 1024) { window.scrollBy(0,-1024); loopWithDelay(); } else { window.scrollTo(0,0); return; } },1000); }; window.scrollTo(0,document.body.scrollHeight); loopWithDelay();')

        sleep 20

        # sleep 10
        session.driver.save_screenshot('capture.png', :full => true)
        begin
          session.find('.close-btn', :visible => false).trigger('click')
        rescue
        end
        sleep 10
        session.driver.save_screenshot('capture2.png', :full => true)
        # File.open( "output.html", "w+" ) { |f| f.write session.html }

      end

      session.driver.quit

    end


  end

  def self.check_for_tag_fires term, url_addr

    Capybara.javascript_driver = :poltergeist
    Capybara.current_driver = :poltergeist

    Capybara.register_driver :poltergeist do |app|
      options = {
        :js_errors => false,
        :timeout => 30,
        :debug => false,
        :window_size => [1024,768]
      }
      Capybara::Poltergeist::Driver.new(app, options)
    end

    session = Capybara::Session.new(:poltergeist)

    session.driver.headers = { "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36" }
    session.visit url_addr       # go to a web page (first request will take a bit)

    session.driver.network_traffic.each do |request|
      request.response_parts.uniq(&:url).each do |response|
        if response.url.downcase.include?(term.downcase)
          session.driver.quit
          return true
        end
      end
    end

    session.driver.quit
    return false

  end

  # This method gets the final redirect of a given URL, up to a maximum of 5 successive redirects (which can be changed to any other number)
	def self.get_final_redirect(page_url, limit = 5)

		raise ArgumentError, 'Too many HTTP redirects' if limit == 0

		begin

			res = Net::HTTP.get_response(URI(page_url))

			case res
			when Net::HTTPRedirection
				# Recursively calls the same method until we hit a non-redirected URL or reach 5 redirects
				get_final_redirect(res['location'], limit - 1)
			else
				page_url
			end

			# sleep 1

		rescue

			page_url

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

  def self.aggregate_headlines_and_take_snapshot site, thumbnail = false

    Capybara.javascript_driver = :poltergeist
    Capybara.current_driver = :poltergeist

    Capybara.register_driver :poltergeist do |app|
      options = {
        :js_errors => false,
        :timeout => 60,
        :debug => false,
        :window_size => [1024,768]
      }
      Capybara::Poltergeist::Driver.new(app, options)
    end

    session = Capybara::Session.new(:poltergeist)

    session.driver.headers = { "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36" }
    session.visit site.url       # go to a web page (first request will take a bit)

    snapshot_name = "#{site.shortcode}-#{ Time.now.strftime("%Y-%m-%d-%H-%M-%z") }.png"
    if thumbnail
      new_snapshot = Snapshot.new :filename => snapshot_name, :thumbnail => ("thumb-" + snapshot_name), :site => site
    else
      new_snapshot = Snapshot.new :filename => snapshot_name, :site => site
    end
    new_snapshot.save

    headlines = session.all(:css, "#{site.selector}")

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

    begin
      sleep 5
      session.find('.close-btn', :visible => false).trigger('click')
      sleep 5
    rescue
    end

    session.execute_script('function loopWithDelay() { setTimeout(function () { if (document.body.scrollTop > 1024) { window.scrollBy(0,-1024); loopWithDelay(); } else { window.scrollTo(0,0); return; } },1000); }; window.scrollTo(0,document.body.scrollHeight); loopWithDelay();')

    sleep 20

    images_arr = []
    images_arr << Base64.decode64(session.driver.render_base64(:png, full: true))
    images_arr << Magick::Image.from_blob(images_arr[0]).first.resize_to_fill(300,300,Magick::NorthWestGravity).to_blob if thumbnail

    images_arr.each_with_index do |image, index|

      s3 = Aws::S3::Resource.new
      bucket = s3.bucket(ENV['S3_BUCKET'])
      if index == 0
        obj = bucket.object(snapshot_name)
      else
        obj = bucket.object(("thumb-" + snapshot_name))
      end
      obj.put(body: image)
      obj.etag

    end

    session.driver.quit

  end

  def self.create_thumbnail image, to_file_too = false

    source = Magick::Image.read(image).first
    source = source.resize_to_fill(300,300,Magick::NorthWestGravity)

    source.write("capture_thumb.png") if to_file_too


  end

end
