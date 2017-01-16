module ApplicationHelper
  def user_name(user)
    if user.nickname
      if user.nickname.length > 14 
        return user.nickname[0..14] + "..."
      else
        return user.nickname
      end
    else
      return user.email.split("@").first
    end
  end
end
