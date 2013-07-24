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
        say("issue no" + s + "assinged to" + s + "title")
        JSON.parse(Redmine.get_issues())["issues"].each do |issue|
          assigned_to_name = "(Not assigned)" if issue["assigned_to"].nil?
          assigned_to_name = issue["assigned_to"]["name"] unless issue["assigned_to"].nil?
          say("#" + issue["id"].to_s + s + assigned_to_name + s + issue["subject"])
        end
    end
  end
end
