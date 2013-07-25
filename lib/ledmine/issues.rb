require 'ledmine'
require 'thor'

module Ledmine
  class Issues < Thor

    method_option :account, :type => :string, :default => "default", :desc => "Set accounts name.", :aliases => "-a"
    method_option :oneline, :type => :boolean, :desc => "Show issue oneline."
    desc 'view ID', 'View issue #ID.'
    def view(id)
      issue = JSON.parse(Redmine.get_issue(id, options))
      if options[:oneline]
        say("#" + issue["issue"]["id"].to_s + " " + issue["issue"]["subject"])
      else
        say "issue id:\t#" + issue["issue"]["id"].to_s
        say "project:\t" + issue["issue"]["project"]["name"].to_s
        say "subject:\t" + issue["issue"]["subject"].to_s
        say "description:\t" + issue["issue"]["description"].to_s unless issue["issue"]["description"].nil?
        say "current status:\t" + issue["issue"]["status"]["name"].to_s unless issue["issue"]["status"].nil?
        say "assigned to:\t" + issue["issue"]["assigned_to"]["name"].to_s unless issue["issue"]["assigned_to"].nil?
        say "start date:\t" + issue["issue"]["start_date"].to_s unless issue["issue"]["start_date"].nil?
        say "due date:\t" + issue["issue"]["due_date"].to_s unless issue["issue"]["due_date"].nil?
      end
    end

    method_option :account, :type => :string, :default => "default", :desc => "Set accounts name.", :aliases => "-a"
    method_option :project, :type => :string, :desc => "Set project ID or KEY.", :banner => "<PROJECTID>"
    desc 'create SUBJECT [DESC]', 'Create issue.'
    def create(subject, desc = nil)
      create_options = {}
      create_options["description"] = desc unless desc.nil?
      create_options["project_id"] = options[:project] unless options[:project].nil?

      Redmine.create_issue(subject, create_options, options[:account])
    end

    method_option :account, :type => :string, :default => "default", :desc => "Set accounts name.", :aliases => "-a"
    desc 'close ID', 'Close issue #ID.'
    def close(id)
      Redmine.close_issue(id, options[:account])
    end

    method_option :account, :type => :string, :default => "default", :desc => "Set accounts name.", :aliases => "-a"
    method_option :number, :type => :numeric, :default => 25, :desc => "Limits the number of issues or others to show.", :aliases => "-n"
    method_option :csv, :type => :boolean
    desc 'list', 'List issues.'
    def list()
      s = options[:csv] ? "," : "\t"
      priority_on_color = {
        "1" => "on_cyan",
        "2" => "on_green",
        "3" => "on_magenta",
        "4" => "on_red",
        "5" => "on_red"
      }
      say("priority" + s + "no" + s + "assinged" + s + "title", :yellow)
      JSON.parse(Redmine.get_issues(options))["issues"].each do |issue|
        assigned_to_name = issue["assigned_to"] ? issue["assigned_to"]["name"] : "(Not assigned)"
        say issue["priority"]["name"].to_s, priority_on_color[ issue["priority"]["id"].to_s ].to_sym, nil
        say "\t#" + issue["id"].to_s + s + assigned_to_name + s + issue["subject"]
      end
    end
  end
end
