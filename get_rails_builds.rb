require 'httparty'
require 'pry'

headers = {
  "Travis-API-Version" => "3",
  "User-Agent" => "API Explorer",
  "Authorization"=> "token #{ENV['TRAVIS_TOKEN']}"
}

response = HTTParty.get('https://api.travis-ci.org/repo/891/builds?limit=100', headers: headers)

builds = {builds: response["builds"]}

puts response["builds"].count
10.times do
  puts response["@pagination"]["next"]["@href"]
  next_page = "https://api.travis-ci.org#{response["@pagination"]["next"]["@href"]}"
  response = HTTParty.get(next_page, headers: headers)
  puts response["builds"].count
  builds[:builds] += response["builds"]
end

puts builds[:builds].count

open('rails_builds.json', 'w') do |f|
  f << builds.to_json
end

builds_from_file = JSON.parse(open('rails_builds.json').read)
# binding.pry
puts builds_from_file["builds"].count
