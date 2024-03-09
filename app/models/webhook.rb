class Webhook < ActiveRecord::Base
  belongs_to :layer, class_name: 'Group', foreign_key: :layer_group_id

  validates :target_url, presence: true
  validates :webhook_type, presence: true
end
