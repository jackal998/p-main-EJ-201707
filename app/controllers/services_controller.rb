class ServicesController < ApplicationController
  skip_before_action :authenticate_user!, :only=>[:marketing]
  def index
    
  end

  def marketing
    
  end
end
