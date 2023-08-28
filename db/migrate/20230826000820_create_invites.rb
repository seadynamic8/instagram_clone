class CreateInvites < ActiveRecord::Migration[7.0]
  def change
    create_table :invites do |t|
      t.references :sender, references: :users, null: false, foreign_key: { to_table: :users }
      t.references :receiver, references: :users, null: false, foreign_key: { to_table: :users }
      t.boolean :accepted, default: false
      t.text :message, null: false

      t.timestamps
    end
  end
end
