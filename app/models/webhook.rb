class Webhook < ApplicationRecord
  validates :target_url, presence: true
  validates :webhook_type, presence: true
end
