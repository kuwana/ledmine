require 'ledmine'
require 'thor'

module Ledmine
  class Issues < Thor
    desc 'view', 'View issue.'
    def view(id)
      issue = JSON.parse(Redmine.get_issue(issue_id))
      say("#" + issue["issue"]["id"].to_s + " " + issue["issue"]["subject"])
    end
  end
end
