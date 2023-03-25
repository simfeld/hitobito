class Webhook < ApplicationRecord
  validates :target_url
  validates :webhooktype
end
