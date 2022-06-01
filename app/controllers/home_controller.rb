class HomeController < ApplicationController
  def index
    render :layout => 'users/application'
  end
end
