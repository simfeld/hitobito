class Webhook < ApplicationRecord
  validates :target_url
  vallidates :webhook_type
end
