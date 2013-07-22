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
  end
end
