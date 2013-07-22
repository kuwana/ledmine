require 'ledmine/version'
require 'ledmine/redmine'
require 'json'
require 'thor'

module Ledmine
  attr_accessor :config
  class CLI < Thor
    desc "init", "Generate ~/.ledmine.json interactive."
    def init()
      json = {}
      redmine = {}
      say('Redimne Settings')

      say('redmine url: ')
      url = STDIN.gets
      redmine['url'] = url.chomp

      say('api key: ')
      api_key = STDIN.gets
      redmine['api_key'] = api_key.chomp

      say('default project id or key: ')
      default_project_id = STDIN.gets
      redmine['default_project_id'] = default_project_id.chomp

      json["default"] = redmine

      File.open(ENV["HOME"] + '/.ledmine.json', 'w') do |file|
        file.write( JSON.pretty_generate( json ) )
      end

      say('Generated ~/.ledmine.json')
    end

    desc "dump", "Dump ~/.ledmine.json."
    def dump()
      puts JSON.pretty_generate(@config)
    end

    desc "view", "View issue."
    method_options project_id: :string
    def view(issue_id)
      issue = JSON.parse(Redmine.get_issue(issue_id))
      say("#" + issue["issue"]["id"].to_s + " " + issue["issue"]["subject"])
    end
    

    def initialize(*args)
      super
      if ( check() )
        @config = open(ENV["HOME"]+"/.ledmine.json") do |config|
          JSON.load(config)
          end
      end
    end

    private
    def check()
        return File.exist?(ENV["HOME"]+"/.ledmine.json")
    end
  end
end
