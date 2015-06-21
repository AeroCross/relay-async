class AccessController < ApplicationController
  layout 'login'

  def index
    # access#attempt
  end

  def login
    # login form
  end

  # POST
  def attempt
    if params[:username].present? && params[:password].present?
      found_user = User.where(:username => params[:username]).first
      if found_user
        authorised_user = found_user.authenticate(params[:password])
      else
        # one redirect should be used, not two
        redirect_to '/access/login', notice: 'Incorrect username or password', flash: {type: 'warning'}
        return
      end

      if authorised_user
        # log in and redirect
        redirect_to '/access/login', notice: 'Logged in! To be implemented', flash: {type: 'success'}
        return
      else
        redirect_to '/access/login', notice: 'Incorrect username or password', flash: {type: 'warning'}
        return
      end
    else
      # looks like this needs to be solved by some sort of form validation
      redirect_to '/access/login', notice: 'All fields are required', flash: {type: 'warning'}
      return
    end

    # if anything fails
    redirect_to '/access/login', notice: 'Incorrect username or password', flash: {type: 'warning'}
  end

  def logout
  end
end