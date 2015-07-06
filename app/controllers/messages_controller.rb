class MessagesController < ApplicationController
  before_action :access_control_headers

  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        # if the response is from the HTML form (/tickets/show) then send an email reply
        format.html do
          # refactor to modal
          user = User.find(params[:message][:user_id])
          ticket = Ticket.find(params[:message][:ticket_id])

          # send the email
          TicketMailer.chat_invite(user, ticket, @message).deliver_now

          # and send back to the previous view
          redirect_to(ticket_url(id: params[:message][:ticket_id]), notice: 'Message posted', flash: {type: 'success'})
        end

        # if json, simply say "yup, all good"
        format.json {render json: {content: 'created', status: :created}}

        # if something fails...
      else
        format.html {redirect_to(ticket_url(id: params[:message][:ticket_id]), notice: 'An error occurred', flash: {type: 'danger'})}
        format.json {render json: {content: 'not created.', status: :unprocessable_entity }}
      end
    end
  end

  # this is supposedly only for the live chat
  # this hasn't been implemented yet
  def show
    @messages = Ticket.includes(:messages).find(params[:id]).messages

    # this should never respond to HTML since everything is shown through /tickets/shows
    respond_to do |format|
      format.json {render json: @messages}
    end
  end

  private
    def message_params
      params.require(:message).permit(:ticket_id, :user_id, :content, :source)
    end
end
