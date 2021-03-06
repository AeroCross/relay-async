class TicketMailer < ApplicationMailer
  # @TODO: change when in production - maybe a config variable or something
  default from: Rails.application.config.async.from

  # send email to the requester when a new response has been sent
  def chat_invite(user, ticket, message)
    # set up all variables to be used within the message
    @user         = user
    @ticket       = ticket
    @message      = message
    @auth         = Ticket.find(ticket).auth_client
    @sign_up_url  = access_sign_up_url
    @ticket_url   = ticket_url id: @ticket.id
    @chat_url     = Rails.configuration.sync.root + '/chat/' + @ticket.id.to_s + '?email=' + @user.email + '&auth=' + @auth

    # send the email
    mail to: @user.email, subject: "Response about ##{@ticket.id}: #{@ticket.subject}"
  end

  def new_ticket(ticket, to)
    @ticket       = ticket
    @user         = ticket.user
    @auth         = ticket.auth_client
    @ticket_url   = ticket_url id: @ticket.id
    @chat_url     = Rails.configuration.sync.root + '/chat/' + @ticket.id.to_s + '?email=' + @user.email + '&auth=' + @auth

    mail to: to, subject: 'A new ticket has been opened.'
  end
end
