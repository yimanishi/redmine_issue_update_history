class CreateIssueUpdateHistories < ActiveRecord::Migration
  def change
    create_table :issue_update_histories do |t|
      t.integer :issue_id
      t.integer :tracker_id
      t.integer :project_id
      t.date :due_date
      t.integer :category_id
      t.integer :status_id
      t.integer :assigned_to_id
      t.integer :priority_id
      t.integer :fixed_version_id
      t.integer :author_id
      t.integer :lock_version
      t.date :start_date
      t.integer :done_ratio
      t.float :estimated_hours
      t.float :spent_time
      t.integer :parent_id
      t.integer :root_id
      t.datetime :created_on
      t.datetime :updated_on
      t.datetime :closed_on
      t.float :bac
      t.float :pv
      t.float :ev
      t.float :ac
    end
  end
end
