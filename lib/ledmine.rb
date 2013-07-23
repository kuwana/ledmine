require 'ledmine/version'
require 'ledmine/redmine'
require 'ledmine/issues'
require 'json'
require 'thor'

module Ledmine
  attr_accessor :config
  class CLI < Thor
    include Thor::Actions

    desc "init", "Generate ~/.ledmine.json interactive."
    def init()
      json = {}
      redmine = {}
      say('Redimne Settings')

      redmine['url'] = ask("redmine url:")
      redmine['api_key'] = ask("api key:")
      redmine['default_project_id'] = ask("default project id or key:")

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

    register Ledmine::Issues, :issues, "issues [SOMETHING]", "Issues."
    
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
