class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :user_id
      t.text :subject
      t.text :content

      t.timestamps null: false
    end
  end
end
