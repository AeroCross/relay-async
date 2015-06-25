class TicketMailer < ApplicationMailer
  default from: 'notifications@example.com'
  def chat_invite(user, ticket, message)
    @user = user
    @ticket = ticket
    @message = message
    @ticket_url = ticket_url id: @ticket.id

    # to model
    @auth = Ticket.find(ticket).auth_client

    # @TODO: this should be a global default or something
    @chat_url = 'http://localhost:8080/chat/' + @ticket.id.to_s
    mail to: @user.email, subject: "Response about #{@ticket.id}: #{@ticket.subject}"
  end
end
