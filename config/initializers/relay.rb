# set the configuration handlers of both sync and async
Rails.application.config.sync = ActiveSupport::OrderedOptions.new
Rails.application.config.async = ActiveSupport::OrderedOptions.new

# sync
# root of the application
Rails.application.config.sync.root = ENV['SYNC_ROOT']

# async
# for testing purposes only — something better should be devised down the track
Rails.application.config.async.notify_all_emails = true
Rails.application.config.async.notify_to = ENV['NOTIFY_TO']
Rails.application.config.async.from = 'notifications@relayapp.net'