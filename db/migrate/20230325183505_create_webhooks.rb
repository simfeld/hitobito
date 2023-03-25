class CreateWebhooks < ActiveRecord::Migration[6.1]
  def change
    create_table :webhooks do |t|
      t.string :target_url
      t.string :webhook_type

      t.timestamps
    end
  end
end
