# set the configuration handlers of both sync and async
Rails.application.config.sync = ActiveSupport::OrderedOptions.new
Rails.application.config.async = ActiveSupport::OrderedOptions.new

# sync
# root of the application
# @TODO: per environment would be nice
Rails.application.config.sync.root = 'http://localhost:8080'

# async
# for testing purposes only: send all new tickets and responses to me
# @TODO: also use environments
Rails.application.config.async.notify_all_emails = true
Rails.application.config.async.notify_to = 'mario@mariocuba.net'
Rails.application.config.async.from = 'notifications@example.com'