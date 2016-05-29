class IssueHook < Redmine::Hook::Listener
  def controller_issues_new_after_save(context = {})
    issue = context[:issue]
    unless issue.blank?
      create_update_history( issue )
    end
  end

  def controller_issues_edit_after_save(context = {})
    issue = context[:issue]
    unless issue.blank?
      create_update_history( issue )
    end
  end

  def controller_issues_bulk_edit_before_save(context = {})
    issue = context[:issue]
    unless issue.blank?
      create_update_history( issue )
    end
  end

  private
  def create_update_history( issue )
    last_update_history = IssueUpdateHistories.find(:first,:conditions => [ "issue_id = ?", issue.id], :order => "updated_on DESC")
    unless last_update_history.blank?
      if issue.tracker_id == last_update_history.tracker_id && 
         issue.project_id == last_update_history.project_id &&
         issue.due_date == last_update_history.due_date &&
         issue.category_id == last_update_history.category_id &&
         issue.status_id == last_update_history.status_id &&
         issue.assigned_to_id == last_update_history.assigned_to_id &&
         issue.priority_id == last_update_history.priority_id &&
         issue.fixed_version_id == last_update_history.fixed_version_id &&
         issue.author_id == last_update_history.author_id &&
         issue.start_date == last_update_history.start_date &&
         issue.done_ratio == last_update_history.done_ratio &&
         issue.estimated_hours == last_update_history.estimated_hours &&
         issue.parent_id == last_update_history.parent_id &&
         issue.root_id == last_update_history.root_id
        return
      end
    end

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
    update_history.spent_time = get_time_entry( issue.id )
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
  end

  def get_time_entry( issue_id )
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
