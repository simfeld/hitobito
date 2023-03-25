class Webhook < ApplicationRecord
  validates :target_url
  vallidates :type
end
