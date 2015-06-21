class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def confirm_login
    unless session[:id]
      flash[:notice] = 'You need to be logged in'
      flash[:type] = 'danger'
      redirect_to '/access/login'
      false
    end
  end

end
