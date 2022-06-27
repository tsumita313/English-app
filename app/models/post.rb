class Post < ApplicationRecord
    require 'selenium-webdriver'
    require 'nokogiri'
    require 'open-uri'

    def user
        return User.find_by(id: self.user_id)
    end
end
