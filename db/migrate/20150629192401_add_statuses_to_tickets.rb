class AddStatusesToTickets < ActiveRecord::Migration
  def change
    add_column 'tickets', 'status', :string, default: 'open'
  end
end
