class ChatController < ApplicationController
  # this works as an API — this should not return HTML
  before_action :access_control_headers

  # check if a ticket exists so the chat knows that it
  # shouldn't create new rooms that are not in the system
  def check
  end

  # confirm that the auth code in the ticket system belongs to the
  # ticket, to prevent the need to log into the system or have sessions
  def auth
  end
end
