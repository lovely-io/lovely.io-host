module UsersHelper
  def user_avatar(user)
    image_tag user.avatar_url, :class => :avatar
  end

  def user_avatar_link(user)
    link_to user_avatar(user), user
  end
end