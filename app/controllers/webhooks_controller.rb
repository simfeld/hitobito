# encoding: utf-8

class WebhooksController < CrudController
  self.nesting = Group
  self.permitted_attrs = [
    :target_url,
    :webhook_type,
    :group
  ]

  private

  def list_entries
    Webhook.where(layer: group).includes(:layer)
  end

  def return_path
    group_webhooks_path(group)
  end

  alias group parent

  def authorize_class
    authorize!(:index_webhooks, group)
  end
end
