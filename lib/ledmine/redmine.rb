require 'ledmine'
require 'json'

require 'net/http'

module Ledmine
  attr_accessor :config
  class Redmine
    def self.load_config()
      @config = open(ENV["HOME"]+"/.ledmine.json") do |config|
        JSON.load(config)
      end
    end
    def self.get_issue(id, account = "default")
      self.load_config()
      config = @config[account]
      url = URI.parse( config["url"] + "issues/" + id + ".json" )
      http = Net::HTTP.new(url.host, url.port)
      http.start{|http|
        req = Net::HTTP::Get.new(url.path)
        req.add_field 'Accept', 'application/json'
        req.add_field 'Content-Type', 'application/json'
        req.add_field 'X-Redmine-API-Key', config["api_key"]
        res = http.request(req)
        return res.body
      }
    end
  end
end
