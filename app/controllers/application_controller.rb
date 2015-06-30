class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  # this prevents unauthorised users to get into the system
  def confirm_login
    unless session[:id]
      flash[:notice] = 'You need to be logged in'
      flash[:type] = 'danger'
      redirect_to '/access/login'
      false
    end
  end

  # this allows cross-domain API calls
  def access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  # the id here is the user id related to the resource being shown
  # this is probably a bad idea
  # e.g ticket.user.id = id then compare to session[:id]
  #
  # refactor: maybe use two methods: restricted_access (which checks user id's)
  # and admins_only (which checks only for the admin role)
  def restrict_access(id = nil)
    # whitelisting approach
    authorised = false

    # not checking for ownership, just role
    if session[:role] == 'admin'
      authorised = true

      # checking for ownership
    elsif id == session[:id]
      authorised = true
    end

    unless authorised
      redirect_to tickets_path, flash: {notice: 'You don\'t have enough permissions to do that', type: 'warning'}
    end
  end
end
