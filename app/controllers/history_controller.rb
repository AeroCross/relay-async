class HistoryController < ApplicationController
  # @TODO: separate reusable code from layouts into smaller files (such as the head)
  # @TODO: notices should also be separate so they can be rendered separately
  def index
    # form asking for creator email and ticket id, which will be sent through an email
  end

  def show
    begin
      @ticket = Ticket.included(:users).find(params[:ticket_id])
    rescue
      redirect_to history_path, flash: {notice: 'We couldn\'t find a ticket with that information. Make sure you check your email for the right information.', type: 'warning text-center'}
    end
    # also check if the ticket belongs to the person (i.e email matches)
  end

  private

  def ticket_params
    params.require(:ticket).permit(:email, :ticket_id)
  end
end
