class AccessController < ApplicationController
  layout 'login'

  def login
    # login form
    # @TODO: if logged in, redirect to :root
  end

  # POST
  def attempt
    if params[:email].present? && params[:password].present?
      # @TODO: this can possibly be refactored into the model by using .authenticate straight away
      # to prevent RubyMine's dumbass lint
      found_user = User.where(:email => params[:email]).first
      if found_user
        authorised_user = found_user.authenticate(params[:password])

      # no user found
      else
        # this message should be left as is — we don't want to uncover that there's no user
        flash[:notice] = 'Incorrect email or password'
        flash[:type] = 'warning'
        redirect_to '/access/login'
        return
      end

      # if everything went right
      if authorised_user
        # set all information to a session for ease of retrieval
        session[:id] = authorised_user.id
        session[:fullname] = authorised_user.fullname
        session[:email] = authorised_user.email
        session[:role] = authorised_user.role

        # and redirect
        redirect_to :root
        return

      # incorrect information
      else
        flash[:notice] = 'Incorrect email or password'
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
    session[:email] = nil
    session[:role] = nil

    flash[:notice] = 'You have been logged out'
    flash[:type] = 'info'
    redirect_to '/access/login'
  end

end