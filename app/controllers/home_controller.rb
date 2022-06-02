class HomeController < ApplicationController
  def index
    unless @current_user
      render :layout => 'users/application'
      return
    end
    redirect_to settings_path
  end
end
