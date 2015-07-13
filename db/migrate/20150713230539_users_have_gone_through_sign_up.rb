class UsersHaveGoneThroughSignUp < ActiveRecord::Migration
  def change
    add_column 'users', 'verified', :string, default: 'yes', null: false
  end
end
