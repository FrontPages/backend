# I created this file, which is not used anywhere in production, to help me test during the transition from Capybara/PhantomJS to Selenium/ChromeDriver.

require 'selenium-webdriver'

options = Selenium::WebDriver::Chrome::Options.new(args: ['headless'])
driver = Selenium::WebDriver.for(:chrome, options: options)
driver.get('http://washingtonpost.com/')
puts driver.title

driver.execute_script('function loopWithDelay() { setTimeout(function () { var scroll_depth = Math.max(window.pageYOffset, document.documentElement.scrollTop, document.body.scrollTop); if (scroll_depth > 1024) { window.scrollBy(0,-1024); loopWithDelay(); } else { window.scrollTo(0,0); return; } },1000); }; window.scrollTo(0,document.body.scrollHeight); loopWithDelay();')

width  = driver.execute_script("return Math.max(document.body.scrollWidth, document.body.offsetWidth, document.documentElement.clientWidth, document.documentElement.scrollWidth, document.documentElement.offsetWidth, 924);")
height = driver.execute_script("return Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight, 668);")

# sleep rand(17..24)

# Add some pixels on top of the calculated dimensions for good
# measure to make the scroll bars disappear
#
driver.manage.window.resize_to(width+100, height+100)

image_throwaway = nil
image_throwaway = driver.screenshot_as(:png)

driver.save_screenshot('test.png')

puts driver.find_elements(:css, "a").map{|x| x[:href]}

driver.quit
