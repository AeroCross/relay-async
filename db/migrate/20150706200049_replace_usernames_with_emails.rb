class ReplaceUsernamesWithEmails < ActiveRecord::Migration
  def change
    remove_column :users, :username
  end
end
