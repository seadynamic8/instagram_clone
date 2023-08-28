class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_one_attached :profile_pic
  has_many :likes
  has_many :comments

  has_many :accepted_received_requests, -> { where(accepted: true) }, class_name: "Follow", foreign_key: "followed_id"
  has_many :follow_requests, -> { where(accepted: false) }, class_name: "Follow", foreign_key: "followed_id"

  has_many :accepted_sent_requests, -> { where(accepted: true) }, class_name: "Follow", foreign_key: "follower_id"
  has_many :waiting_sent_requests, -> { where(accepted: false) }, class_name: "Follow", foreign_key: "follower_id"

  has_many :followers, through: :accepted_received_requests, source: :follower
  has_many :followings, through: :accepted_sent_requests, source: :followed
  has_many :waiting_followings, through: :waiting_sent_requests, source: :followed

  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id"
  has_many :received_messages, class_name: "Message", foreign_key: "receiver_id"

  has_many :users_sent_messages_to, -> { distinct }, through: :sent_messages, source: :receiver
  has_many :users_received_messages_from, -> { distinct }, through: :received_messages, source: :sender

  has_many :waiting_sent_invites, -> { where(accepted: false) }, 
              class_name: "Invite", foreign_key: "sender_id"
  has_many :accepted_sent_invites, -> { where(accepted: true) }, 
              class_name: "Invite", foreign_key: "sender_id"

  has_many :waiting_received_invites, -> { where(accepted: false) }, 
              class_name: "Invite", foreign_key: "receiver_id"
  has_many :accepted_received_invites, -> { where(accepted: true) }, 
              class_name: "Invite", foreign_key: "receiver_id"

  has_many :users_sent_invites_to, -> { distinct }, 
              through: :accepted_sent_invites, source: :receiver
  has_many :users_received_invites_from, -> { distinct }, 
              through: :accepted_received_invites, source: :sender


  # Follow

  def follow(user)
    Follow.create!(follower: self, followed: user)
  end

  def unfollow(user)
    self.accepted_sent_requests.find_by(followed: user)&.destroy
  end

  def cancel_request(user)
    self.waiting_sent_requests.find_by(followed: user)&.destroy
  end

  # Messages

  def send_message(user, message_content)
    Message.create!(sender: self, receiver: user, content: message_content)
  end

  def sent_messages_to(user) 
    sent_messages.where(receiver: user)
  end

  def received_messages_from(user)
    received_messages.where(sender: user)
  end

  def users_chatting_with
    (users_sent_messages_to + users_received_messages_from).uniq
  end

  def all_messages_with(user)
    Message.where(sender: self, receiver: user)
      .or( Message.where(sender: user, receiver: self) )
      .order(:created_at)
  end

  # Message Invites (Requests)

  def send_invite_request(user, initial_message)
    Invite.create!(sender: self, receiver: user, message: initial_message)
  end

  # Unique Pairing with other User

  # Add ascii code of each letter of email of each user and add them together
  # Good enough unique for now, until we get to hundreds of users 
  def pair_id(other_user, add_string="")
    self_code = self.email.chars.reduce(0) { |acc, char| acc + char.ord }
    other_code = other_user.email.chars.reduce(0) { |acc, char| acc + char.ord }
    id = "#{self_code + other_code}"
    add_string.present? ? "#{id}_#{add_string}" : id
  end

end
