class Message < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  def mark_seen
    self.update(has_seen: true, seen_time: DateTime.now)
  end
end
