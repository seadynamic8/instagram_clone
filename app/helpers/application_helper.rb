module ApplicationHelper

  def profile_pic(user)
    user.profile_pic.attached? ? user.profile_pic : "user-pp.png"
  end
end
