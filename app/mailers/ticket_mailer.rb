class TicketMailer < ApplicationMailer
  default from: 'notifications@example.com'
  def chat_invite(user, ticket, message)
    @user = user
    @ticket = ticket
    @message = message
    @url = ticket_url id: @ticket.id
    mail to: @user.email, subject: "Response about #{@ticket.id}: #{@ticket.subject}"
  end
end
