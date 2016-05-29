namespace :redmine do
  task :create_issue_update_history => :environment do
    IssueUpdateHistories.create_issue_update_history()
  end
end
