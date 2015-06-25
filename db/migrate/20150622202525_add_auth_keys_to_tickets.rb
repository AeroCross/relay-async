class AddAuthKeysToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :auth_client, :string, default: 'abc'
    add_column :tickets, :auth_admin, :string, default: 'xyz'
  end
end
