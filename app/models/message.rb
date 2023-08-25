class Message < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  after_create_commit -> {
    broadcast_append_later_to "chat",
      target: "messages"
  }
  
  def mark_seen
    self.update(has_seen: true, seen_time: DateTime.now)
  end

end
