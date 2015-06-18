class AddUniqueConstraintToMeetupUsers < ActiveRecord::Migration
  def change
    add_index :meetup_users, [:user_id, :meetup_id], unique: true
  end
end
