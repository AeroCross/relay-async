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
      # @TODO: this can possibly be refactored into the model by using .authenticate straight away
      found_user = User.where(:username => params[:username]).first
      if found_user
        authorised_user = found_user.authenticate(params[:password])

      # no user found
      else
        # this message should be left as is — we don't want to uncover that there's no user
        flash[:notice] = 'Incorrect username or password'
        flash[:type] = 'warning'
        redirect_to '/access/login'
        return
      end

      # if everything went right
      if authorised_user
        # set all information to a session for ease of retrieval
        session[:id] = authorised_user.id
        session[:fullname] = authorised_user.fullname
        session[:username] = authorised_user.username
        session[:email] = authorised_user.email
        session[:role] = authorised_user.role

        # and redirect
        flash[:notice] = 'Logged in! To be implemented'
        flash[:type] = 'success'
        redirect_to '/access/login'
        return

      # incorrect information
      else
        flash[:notice] = 'Incorrect username or password'
        flash[:type] = 'warning'
        redirect_to '/access/login'
        return
      end

    # empty fields
    else
      flash[:notice] = 'All fields are required'
      flash[:type] = 'warning'
      redirect_to '/access/login'
    end
  end

  def logout
    session[:id] = nil
    session[:fullname] = nil
    session[:username] = nil
    session[:email] = nil
    session[:role] = nil

    flash[:notice] = 'You have been logged out'
    flash[:type] = 'info'
    redirect_to '/access/login'
  end

end