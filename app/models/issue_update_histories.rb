class IssueUpdateHistories < ActiveRecord::Base
  unloadable
  belongs_to :project
  belongs_to :tracker
  belongs_to :status, :class_name => 'IssueStatus', :foreign_key => 'status_id'
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  belongs_to :assigned_to, :class_name => 'User', :foreign_key => 'assigned_to_id'
  belongs_to :fixed_version, :class_name => 'Version', :foreign_key => 'fixed_version_id'
  belongs_to :priority, :class_name => 'IssuePriority', :foreign_key => 'priority_id'
  belongs_to :category, :class_name => 'IssueCategory', :foreign_key => 'category_id'

  def self.create_issue_update_history()
    IssueUpdateHistories.connection.execute("truncate table issue_update_histories;")
    issues = Issue.find(:all)
    issues.each { | issue |
      update_history = IssueUpdateHistories.new()
      update_history.issue_id = issue.id
      update_history.tracker_id = issue.tracker_id
      update_history.project_id = issue.project_id
      update_history.due_date = issue.due_date
      update_history.category_id = issue.category_id
      update_history.status_id = issue.status_id
      update_history.assigned_to_id = issue.assigned_to_id
      update_history.priority_id = issue.priority_id
      update_history.fixed_version_id = issue.fixed_version_id
      update_history.author_id = issue.author_id
      update_history.lock_version = issue.lock_version
      update_history.start_date = issue.start_date
      update_history.done_ratio = issue.done_ratio
      update_history.estimated_hours = issue.estimated_hours
      update_history.spent_time = self.get_time_entry( issue.id )
      update_history.parent_id = issue.parent_id
      update_history.root_id = issue.root_id
      update_history.created_on = issue.created_on
      update_history.updated_on = Time.now
      update_history.closed_on = issue.closed_on
      update_history.bac = issue.estimated_hours
      update_history.pv = issue.estimated_hours
      update_history.ev = issue.estimated_hours.to_f * ( issue.done_ratio.to_f / 100 )
      update_history.ac = update_history.spent_time
      update_history.save()
    }
  end

  def self.get_time_entry( issue_id )
    sqlStr ="select sum(hours) from time_entries where issue_id in " +
            "( select id from issues where root_id = '" + issue_id.to_s +
            "' or parent_id = '" + issue_id.to_s + "' ) or issue_id = '" + issue_id.to_s + "'"
    results =ActiveRecord::Base.connection.select(sqlStr)
    results.each do | result |
      return result["sum(hours)"]
    end
    return nil
  end
end
