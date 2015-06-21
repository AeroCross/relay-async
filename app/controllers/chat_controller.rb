class ChatController < ApplicationController
  # this works as an API — this should not return HTML
  before_action :access_control_headers

  # check if a ticket exists so the chat knows that it
  # shouldn't create new rooms that are not in the system
  def check
  end

  # confirm that the auth code in the ticket system belongs to the
  # ticket, to prevent the need to log into the system or have sessions
  #
  # returns the user
  def auth
    id = params[:id]
    auth = params[:auth].to_i
    email = params[:email]

    # get a ticket with this auth code
    begin
      ticket = Ticket.find(id)

    rescue ActiveRecord::RecordNotFound
      ticket = nil
    end

    # if the email sent matches the one in the ticket, then the person can enter the room
    respond_to do |format|
      if ticket.present? && ticket.auth == auth && ticket.user.email == email
        format.json {render json: ticket.user, except: [:password_digest], status: :ok}
      else
        format.json {render json: {}, status: :forbidden}
      end
    end
  end
end
