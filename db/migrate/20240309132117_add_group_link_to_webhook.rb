class AddGroupLinkToWebhook < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :webhooks, :layer_group, null: false
  end
end
