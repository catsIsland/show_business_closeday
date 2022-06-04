class SessionsController < ApplicationController
  def create
    user = User.find_by(name: params[:session][:name])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      session[:user_name] = user.name
      session[:user_mail] = user.mail
      redirect_to settings_path
    else
      render 'home/index'
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path
  end
end
