class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.integer :ticket_id
      t.text :content
      t.string :source

      t.timestamps null: false
    end
  end
end
