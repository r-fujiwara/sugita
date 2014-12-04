module ApplicationHelper

  def avatar_from(user_id:)
    user = user_attrs user_id: user_id
    "https://avatars6.githubusercontent.com/#{user.name}"
  end

  def user_attrs(user_id:)
    user = User.find(user_id)
  end
end
