# encoding: utf-8

class Webhook < ActiveRecord::Base
  validates :target_url
  validates :type
end
