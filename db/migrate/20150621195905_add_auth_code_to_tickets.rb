class AddAuthCodeToTickets < ActiveRecord::Migration
  def change
    add_column 'tickets', 'auth', :integer, default: 0
  end
end
