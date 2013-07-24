require 'ledmine'
require 'thor'

module Ledmine
  class Issues < Thor

    desc 'view ID', 'View issue #ID.'
    def view(id)
      issue = JSON.parse(Redmine.get_issue(id))
      say("#" + issue["issue"]["id"].to_s + " " + issue["issue"]["subject"])
    end

    method_option :project, :type => :string, :desc => "Set project ID or KEY."
    desc 'create SUBJECT [DESC]', 'Create issue.'
    def create(subject, desc = nil)
      create_options = {}
      create_options["description"] = desc unless desc.nil?
      create_options["project_id"] = options[:project] unless options[:project].nil?

      Redmine.create_issue(subject, create_options)
    end

    desc 'close ID', 'Close issue #ID.'
    def close(id)
      Redmine.close_issue(id)
    end

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
      JSON.parse(Redmine.get_issues())["issues"].each do |issue|
        assigned_to_name = "(Not assigned)" if issue["assigned_to"].nil?
        assigned_to_name = issue["assigned_to"]["name"] unless issue["assigned_to"].nil?
        say_status(issue["priority"]["name"].to_s, "#" + issue["id"].to_s + s + assigned_to_name + s + issue["subject"], priority_on_color[ issue["priority"]["id"].to_s ].to_sym)
      end
    end
  end
end
