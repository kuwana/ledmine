require 'ledmine'
require 'json'

require 'net/http'

require 'addressable/uri'

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

    def self.get_issues(options)
      self.load_config()
      config = @config[options[:account]]
      url = Addressable::URI.parse( config["url"] + "issues.json" )
      url.query_values = {
        "assigned_to_id" => "me",
        "sort" => "priority:desc,updated_on:desc",
        "key" => config["api_key"],
        "limit" => options[:number]
      }
      url.query_values.merge!(options)

      http = Net::HTTP.new(url.host, url.port)

      http.start{|http|
        req= Net::HTTP::Get.new(url.path+"?"+url.query)
        res = http.request(req)
        return res.body
      }
    end

    def self.create_issue(subject, options = {}, account = "default")
      self.load_config()
      config = @config[account]
      url = URI.parse( config["url"] + "issues.json" )

      issues = {}
      issues["subject"] = subject
      issues["project_id"] = config["default_project_id"]
      issues.merge!( options )

      http = Net::HTTP.new(url.host, url.port)
      http.start{|http|
        req = Net::HTTP::Post.new(url.path)
        req.add_field 'Accept', 'application/json'
        req.add_field 'Content-Type', 'application/json'
        req.add_field 'X-Redmine-API-Key', config["api_key"]
        req.body = { "issue" => issues }.to_json
        res = http.request(req)
        return res.body
      }
    end

    def self.close_issue(id, account = "default")
      self.load_config()
      config = @config[account]
      url = URI.parse( config["url"] + "issues/" + id + ".json" )
      http = Net::HTTP.new(url.host, url.port)
      http.start{|http|
        req = Net::HTTP::Put.new(url.path)
        req.add_field 'Accept', 'application/json'
        req.add_field 'Content-Type', 'application/json'
        req.add_field 'X-Redmine-API-Key', config["api_key"]
        req.body = {
            "issue" => {
                "done_ratio" => 100,
                "status_id" => 5
            }
        }.to_json
        res = http.request(req)
        return res.body
      }
    end
  end
end
