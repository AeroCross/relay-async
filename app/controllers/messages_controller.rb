class MessagesController < ApplicationController
  # @TODO: careful with the before_action :confirm method — a session must be enabled for the livechat
  before_action :access_control_headers

  def create
    # first create the message_params private method that will whitelist
    # all the parameters then create it with mass-assignment
    @message = Message.new(message_params)
    
    # respond in json (and others using the methods in the format block object)
    respond_to do |format|
      if @message.save
        format.html do
          user = User.find(params[:message][:user_id])
          ticket = Ticket.find(params[:message][:ticket_id])

          TicketMailer.chat_invite(user, ticket, @message).deliver_now
          redirect_to(ticket_url(id: params[:message][:ticket_id]), notice: 'Message posted', flash: {type: 'success'})
        end
        format.json {render json: {content: 'created', status: :created}}
      else
        format.html {redirect_to(ticket_url(id: params[:message][:ticket_id]), notice: 'An error occurred', flash: {type: 'danger'})}
        format.json {render json: {content: 'not created.', status: :unprocessable_entity }}
      end
    end
  end

  def show
    @messages = Ticket.includes(:messages).find(params[:id]).messages
    respond_to do |format|
      format.json {render json: @messages}
    end
  end

  private
    def message_params
      params.require(:message).permit(:ticket_id, :user_id, :content, :source)
    end
end
