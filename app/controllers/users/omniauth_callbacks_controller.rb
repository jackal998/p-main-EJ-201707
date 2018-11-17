class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
#find user by cookies
    @user = User.from_omniauth(request.env["omniauth.auth"], cookies[:show_me_who_u_r])

    sign_in_and_redirect @user
  end

  def failure
    redirect_to root_path
  end

end