require 'httparty'
require 'pry'

headers = {
  "Travis-API-Version" => "3",
  "User-Agent" => "API Explorer",
  "Authorization"=> "token #{ENV['TRAVIS_TOKEN']}"
}

response = HTTParty.get('https://api.travis-ci.org/repo/891/builds?limit=100', {
  headers: headers
})
#binding.pry
puts response["builds"].count
puts response["@pagination"]["next"]["@href"]

builds = {builds: response["builds"]}.to_json

open('rails_builds.json', 'a') do |f|
  f << builds
end
