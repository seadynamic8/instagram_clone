class RemoveNullConstraintOnMessageContent < ActiveRecord::Migration[7.0]
  def change
    change_column_null :messages, :content, true
  end
end
