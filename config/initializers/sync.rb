# root of sync
Rails.application.config.sync = ActiveSupport::OrderedOptions.new
Rails.application.config.sync.root = 'http://localhost:8080'