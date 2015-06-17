class MessagesController < ApplicationController
  def create
    # first create the message_params private method that will whitelist
    # all the parameters then create it with mass-assignment
    @message = Message.new(message_params)

    # respond in json (and others using the methods in the format block object)
    respond_to do |format|
      if @message.save
        format.json {render json: {content: 'created', status: :created}}
      else
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
      params.require(:ticket).permit(:ticket_id, :user_id, :content, :source)
    end
end
