# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

Airbrake.configure do |config|
  # if no host is given, ignore all environments
  config.environment = Rails.env
  config.ignore_environments = [:development, :test]
  config.ignore_environments << :production if ENV['RAILS_AIRBRAKE_HOST'].blank?

  config.project_id     = 1 # required, but any positive integer works
  config.project_key    = ENV['RAILS_AIRBRAKE_API_KEY']
  config.host           = ENV['RAILS_AIRBRAKE_HOST']
  config.port           = (ENV['RAILS_AIRBRAKE_PORT'] || 443).to_i

  config.params_filters << 'RAILS_DB_PASSWORD'
  config.params_filters << 'RAILS_MAIL_RETRIEVER_PASSWORD'
  config.params_filters << 'RAILS_AIRBRAKE_API_KEY'
  config.params_filters << 'RAILS_SECRET_TOKEN'
  config.params_filters << 'RAILS_MAIL_RETRIEVER_CONFIG'
  config.params_filters << 'RAILS_MAIL_DELIVERY_CONFIG'

  ignored_exceptions = %w(ActionController::MethodNotAllowed
                        ActionController::RoutingError
                        ActionController::UnknownHttpMethod)

  Airbrake.add_filter do |notice|
    if (notice[:errors].map { |e| e[:type] } & ignored_exceptions).present?
      notice.ignore!
    end
  end
end
