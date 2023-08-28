class Message < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  after_create_commit -> {
    broadcast_append_later_to sender.pair_id(receiver, :chat_box),
      target: "messages"
  }
  
  def mark_seen
    self.update(has_seen: true, seen_time: DateTime.now)
  end

end
