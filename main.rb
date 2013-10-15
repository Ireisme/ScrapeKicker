require 'open-uri'
require 'nokogiri'
require 'kickscraper'

require_relative 'scraper.rb'
require_relative 'user_parser.rb'
require_relative 'user.rb'
require_relative 'project.rb'

scraper = Scraper.new('your@email.com', 'password')
scraper.by_category('games') do |project|
  puts project.id
  puts project.name
  puts project.location
  puts project.goal
  puts project.pledged
  puts project.created
  puts project.deadline
  puts project.backers.count
  puts "\n"
end
