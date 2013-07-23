require 'ledmine'
require 'thor'

module Ledmine
  class Issues < Thor

    desc 'view ID', 'View issue #ID.'
    def view(id)
      issue = JSON.parse(Redmine.get_issue(id))
      say("#" + issue["issue"]["id"].to_s + " " + issue["issue"]["subject"])
    end

    desc 'create SUBJECT [DESC]', 'Create issue.'
    def create(subject, desc = "")
      Redmine.create_issue(subject, desc)
    end

    desc 'close ID', 'Close issue #ID.'
    def close(id)
      Redmine.close_issue(id)
    end

    desc 'list', 'List issues.'
    def list()
        JSON.parse(Redmine.get_issues())["issues"].each do |issue|
          assigned_to_name = "(Not assigned)" if issue["assigned_to"].nil?
          assigned_to_name = issue["assigned_to"]["name"] unless issue["assigned_to"].nil?
          say("#" + issue["id"].to_s + "\t" + assigned_to_name + "\t" + issue["subject"])
        end
    end
  end
end
