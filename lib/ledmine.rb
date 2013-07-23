require 'ledmine/version'
require 'ledmine/redmine'
require 'ledmine/issues'
require 'json'
require 'thor'

module Ledmine
  attr_accessor :config
  class CLI < Thor
    include Thor::Actions

    LEDMINE_CONFIG_FILENAME = ".ledmine.json"

    desc "init", "Generate ~/#{LEDMINE_CONFIG_FILENAME} interactive."
    def init()
      json = {}
      redmine = {}
      say('Redimne Settings')

      redmine['url'] = ask("redmine url:")
      redmine['api_key'] = ask("api key:")
      redmine['default_project_id'] = ask("default project id or key:")

      json["default"] = redmine

      File.open(ENV["HOME"] + "/#{LEDMINE_CONFIG_FILENAME}", 'w') do |file|
        file.write( JSON.pretty_generate( json ) )
      end

      say("Generated ~/#{LEDMINE_CONFIG_FILENAME}")
    end

    desc "dump", "Dump ~/#{LEDMINE_CONFIG_FILENAME}."
    def dump()
      say(JSON.pretty_generate(@config))
    end

    register Ledmine::Issues, :issues, "issues [SOMETHING]", "Issues."

    def initialize(*args)
      super
      if ( check() )
        @config = open(ENV["HOME"]+"/#{LEDMINE_CONFIG_FILENAME}") do |config|
          JSON.load(config)
          end
      end
    end

    private
    def check()
        return File.exist?(ENV["HOME"]+"/#{LEDMINE_CONFIG_FILENAME}")
    end
  end
end
