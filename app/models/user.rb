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

  has_many :users_sent_messages_to, through: :sent_messages, source: :receiver
  has_many :users_received_messages_from, through: :received_messages, source: :sender

  def follow(user)
    Follow.create(follower: self, followed: user)
  end

  def unfollow(user)
    self.accepted_sent_requests.find_by(followed: user)&.destroy
  end

  def cancel_request(user)
    self.waiting_sent_requests.find_by(followed: user)&.destroy
  end

  def send_message(user, message_content)
    Message.create(sender: self, receiver: user, content: message_content)
  end

  def sent_messages_to(user) 
    sent_messages.where(receiver: user)
  end

  def received_messages_from(user)
    received_messages.where(sender: user)
  end
end
