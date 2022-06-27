class DictionaryController < ApplicationController
  def top
    @dictionary = Dictionary.last
  end

  def create
    @dictionary = Dictionary.new(content: params[:content])
    @dictionary.save
    translation = @dictionary.content
pp translation
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    @driver = Selenium::WebDriver.for :chrome, options: options
    @driver.manage.window.resize_to(1200, 1000)
    @driver.get("https://translate.weblio.jp/")
    @driver.find_element(:xpath, '//*[@id="originalTextArea"]').click
    sleep 0.5
    @driver.find_element(:xpath, '//*[@id="originalTextArea"]').send_keys(translation) 
    @driver.find_element(:xpath, '//*[@id="JEB"]').click

    document = Nokogiri::HTML(@driver.page_source)
    english_grammar1 = document.xpath('//*[@id="transResultMainLn"]/ul/li').text
    english_grammar2 = document.xpath('//*[@id="transResultMainLn"]/ol/li[1]').text
    english_grammar3 = document.xpath('//*[@id="transResultMainLn"]/ul/li/span').text

    unless english_grammar1.empty?
      translation = english_grammar1
    end
    unless english_grammar2.empty?
      translation = english_grammar2
    end
    unless english_grammar3.empty?
      translation = english_grammar3
    end
    @dictionary.translation = translation
    @dictionary.save
    @driver.quit
    redirect_to("/dictionary/top")
  end
end
