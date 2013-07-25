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
      generate_json("default")
    end

    desc "dump", "Dump ~/#{LEDMINE_CONFIG_FILENAME}."
    def dump()
      say JSON.pretty_generate(@config)
    end

    method_option :account, :type => :string, :default => "default"
    method_option :number, :type => :numeric, :default => 25, :desc => "Limits the number of issues or others to show.", :aliases => "-n"
    desc "list", "List. [default is SUBCOMMAND: issues list]"
    def list()
      invoke Ledmine::Issues, :list, [], options
    end

    method_option :account, :type => :string, :default => "default"
    desc "view ID", "View. [default is SUBCOMMAND: issues view ID]"
    def view(id)
      invoke Ledmine::Issues, :view, [id], options
    end

    desc "add [NAME]", "Add another redmine account."
    def add(name)
      generate_json(name)
    end

    register Ledmine::Issues, :issues, "issues [SOMETHING]", "Issues."

    def initialize(*args)
      super
      self.init() unless check?()
      @config = open(ENV["HOME"]+"/#{LEDMINE_CONFIG_FILENAME}") do |config|
        JSON.load(config)
      end
    end

    private
    def check?()
        return File.exist?(ENV["HOME"]+"/#{LEDMINE_CONFIG_FILENAME}")
    end

    def generate_json(name)
      begin
        json = @config ? @config : {}
        redmine = {}
        say "Redimne Settings"

        uri = URI.parse( ask("redmine url:") )

        redmine["url"] = uri.scheme.to_s + "://" + uri.hostname.to_s + uri.path.to_s + "/"
        redmine["api_key"] = ask("api key:")
        redmine["default_project_id"] = ask("default project id or key:")

        json[name] = redmine

        File.open(ENV["HOME"] + "/#{LEDMINE_CONFIG_FILENAME}", 'w') do |file|
          file.write( JSON.pretty_generate( json ) )
        end

        say "Generated ~/#{LEDMINE_CONFIG_FILENAME}", :green
      rescue URI::InvalidURIError => err
        say "Invalid URL string.", :red
        say url
      end
    end
  end
end
