require 'ledmine'
require 'thor'

module Ledmine
  class Issues < Thor
    desc 'view', 'View issue.'
    def view(id)
      issue = JSON.parse(Redmine.get_issue(id))
      say("#" + issue["issue"]["id"].to_s + " " + issue["issue"]["subject"])
    end

    desc 'create', 'Create issue.'
    def create(subject)
      Redmine.create_issue(subject)
    end

    desc 'close', 'Close issue.'
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
