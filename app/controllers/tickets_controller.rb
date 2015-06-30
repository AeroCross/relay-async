class TicketsController < ApplicationController
  require "#{Rails.root}/lib/utilities"

  before_action :confirm_login
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.includes(:user, :messages).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      params.require(:ticket).permit(:user_id, :subject, :content, :status)
    end

end
