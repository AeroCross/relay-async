class TicketsController < ApplicationController
  require "#{Rails.root}/lib/utilities"

  before_action :confirm_login, except: [:history_index, :history_show, :submit_index, :submit_create]
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  layout :resolve_layout

  # prevent regular users from messing with stuff
  before_action only: [:show, :edit, :update, :destroy] do
    restrict_access(@ticket.user.id)
  end

  # GET /tickets
  # GET /tickets.json
  def index
    # @TODO: have a "show all" setting
    @tickets = Ticket.includes(:user).all
  end

  # GET /tickets/search
  def search
    redirect_to action: 'show', id: params[:id]
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
    @messages = Message.includes(:user).where(ticket_id: params[:id]).order(created_at: :desc)
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  # POST /tickets.json
  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.auth_admin = random_string(20).upcase
    @ticket.auth_client = random_string.upcase

    respond_to do |format|
      if @ticket.save

        # temporary
        if Rails.application.config.async.notify_all_emails
          TicketMailer.new_ticket(@ticket, Rails.application.config.async.notify_to).deliver_now
        end

        format.html { redirect_to @ticket, notice: 'Ticket was successfully created.', flash: {type: 'success'} }
        format.json { render :show, status: :created, location: @ticket }
      else
        format.html { render :new }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.', flash: {type: 'info'} }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_url, notice: 'Ticket was successfully destroyed.', flash: {type: 'warning'} }
      format.json { head :no_content }
    end
  end

  # GET /history
  def history_index
    # form asking for creator email and ticket id, which will be sent through an email
  end

  # POST /history
  def history_show
    begin
      # check if the ticket exists first
      @ticket = Ticket.includes(:user, :messages).find(params[:ticket_id])
      @messages = @ticket.messages.order('created_at DESC')

      # then if the email matches the ticket
      if params[:email] != @ticket.user.email
        raise ActiveRecord::RecordNotFound
      end
    rescue
      # @TODO: refactor: render, dog! render!
      redirect_to history_path, flash: {notice: 'We couldn\'t find a ticket with that information. Make sure you check your email for the right information.', type: 'warning text-center'}
    end
  end

  # GET /submit
  def submit_index

  end

  # POST /submit
  def submit_create
    # 1. check if the email doesn't exists so it can create a new blank user
    @user = User.where({email: params[:email]}).first

    if @user.nil?
      @user = User.new
      @user.public = true
      @user.email = params[:email]
      @user.password = random_string(30)
      @user.fullname = nil
      @user.role = 'normal'
      @user.verified = 'no'
      @user.save
    end

    # 2. create the ticket
    @ticket = Ticket.new
    @ticket.subject = params[:subject]
    @ticket.content = params[:content]
    @ticket.user_id = @user.id
    @ticket.auth_client = random_string.upcase
    @ticket.auth_admin = random_string(20).upcase
    @ticket.save

    # 3. mail the user
    # temporary
    if Rails.application.config.async.notify_all_emails
      TicketMailer.new_ticket(@ticket, Rails.application.config.async.notify_to).deliver_now
    end

    TicketMailer.new_ticket(@ticket, @user.email).deliver_now

    # 4. redirect to the same screen with a success message
    if @ticket
      flash.now[:notice] = 'Thanks! We\'ve received your message and you should receive a response shortly.'
      flash.now[:type] = 'success'
      render({file: 'tickets/submit_index', layout: 'history'})
    else
      flash.now[:notice] = 'Whoops! There was an error in your request. We\'ll have it fixed.'
      flash.now[:type] = 'error'
      render({file: 'tickets/submit_index', layout: 'history'})
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.includes(:user, :messages).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      params.require(:ticket).permit(:user_id, :subject, :content, :status)
    end

    # Helper method to determine which layout should be used
    def resolve_layout
      case action_name
        when 'history_index', 'history_show', 'submit_index'
          'history'
        else
          'application'
      end
    end
end
