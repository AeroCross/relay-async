class AccessController < ApplicationController
  layout 'login'

  def index
    # route to default?
  end

  def login
    # login form
  end

  # POST
  def attempt
    if params[:username].present? && params[:password].present?
      # check if there's someone in the database with that username
      found_user = User.where(:username => params[:username]).first

      # if so, try to authenticate
      if found_user
        authorised_user = found_user.authenticate(params[:password])
      end

      # if auth is successful, then we can go ahead and set up stuff like sessions
      # and redirect them to the root of the application
      if authorised_user
        # do stuff with authenticated user
      else
        # do stuff with the wrong login
      end
    end
  end

  def logout
  end
end