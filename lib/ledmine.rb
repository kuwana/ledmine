require 'ledmine/version'
require 'ledmine/redmine'
require 'ledmine/issues'
require 'json'
require 'thor'

require 'uri'

module Ledmine
  attr_accessor :config
  class CLI < Thor
    include Thor::Actions

    LEDMINE_CONFIG_FILENAME = ".ledmine.json"

    desc "init", "Generate ~/#{LEDMINE_CONFIG_FILENAME} interactive."
    def init()
      begin
        json = {}
        redmine = {}
        say "Redimne Settings"

        uri = URI.parse( ask("redmine url:") )

        redmine["url"] = uri.scheme.to_s + "://" + uri.hostname.to_s + uri.path.to_s + "/"
        redmine["api_key"] = ask("api key:")
        redmine["default_project_id"] = ask("default project id or key:")

        json["default"] = redmine

        File.open(ENV["HOME"] + "/#{LEDMINE_CONFIG_FILENAME}", 'w') do |file|
          file.write( JSON.pretty_generate( json ) )
        end

        say "Generated ~/#{LEDMINE_CONFIG_FILENAME}", :green
      rescue URI::InvalidURIError => err
        say "Invalid URL string.", :red
        say url
      end
    end

    desc "dump", "Dump ~/#{LEDMINE_CONFIG_FILENAME}."
    def dump()
      say JSON.pretty_generate(@config)
    end

    desc "list", "List. [default issues]"
    def list()
      Ledmine::Issues.new.list()
    end

    desc "view", "View."
    def view(id)
      Ledmine::Issues.new.view(id, options)
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
