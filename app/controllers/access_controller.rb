class AccessController < ApplicationController
  layout 'login'

  # GET /access
  def login
    # login form
    # @TODO: if logged in, redirect to :root
  end

  # POST /access/attempt
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

  # GET /access/sign_up
  def sign_up
    # show sign up form
  end

  # POST /access/sign_up
  def create
    # check if the user exists using the email address so we can update the record instead of
    # making a new new one

    if params[:user][:password] != params[:user][:password_confirm]
      flash.now[:notice] = 'Passwords must match.'
      flash.now[:type] = 'warning'
      render file: 'access/sign_up'
      return
    end

    @user = User.where(email: params[:email]).first

    # user doesn't exist - create one from scratch
    if @user.blank?
      @user = User.new
      @user.fullname

      # user does exist - update the record so it includes the new information
    else
      if @user.update(user_params)
        # all goodC
        flash.now[:notice] = 'Account created!'
        flash.now[:type] = 'success'
        render file: 'access/sign_up'
        return
      end
    end

    flash.now[:notice] = 'Something happened when creating your account.'
    flash.now[:type] = 'warning'
    render file: 'access/sign_up'
  end

  private

  def user_params
    params.require(:user).permit(:email, :fullname, :password)
  end

end