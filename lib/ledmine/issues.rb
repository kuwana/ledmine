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
      issue = JSON.parse(Redmine.create_issue(subject))
      puts issue
    end
  end
end
