class UsersController < ApplicationController
  def update
    current_user.attributes = params.permit(:panel_top, :panel_left)
    current_user.save(:validate => false)

    head 200, content_type: "text/html"
  end
end