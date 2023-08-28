class Invite < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  def accept
    self.update(accepted: true)
  end
end
