class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :sender, references: :users, null: false, foreign_key: { to_table: :users }
      t.references :receiver, references: :users, null: false, foreign_key: { to_table: :users }
      t.text :content, null: false
      t.boolean :has_seen, default: false
      t.timestamp :seen_time

      t.timestamps
    end
  end
end
