# encoding: utf-8

#  Copyright (c) 2023, Pfadibewegung Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class WebhookJob < BaseJob

  self.parameters = [:webhook_id, :data]

  def initialize(webhook, data)
    super()
    @webhook_id = webhook.id
    @data = data
  end

  def perform
    case webhook.webhook_type
    when 'group_request_created' then perform_group_request_created
    when 'group_request_approved' then perform_group_request_approved
    when 'participation_assigend' then perform_participation_assigend
    else raise(ArgumentError, "Unknown webhook type #{webhook.webhook_type}")
    end
  end

  def perform_group_request_created
    group = Group.find_by!(id: @data[:group_id])
    executor = Person.find_by!(id: @data[:executor_id])
    subject = Person.find_by!(id: @data[:subject_id])
    send
  end

  def perform_group_request_approved
    group = Group.find_by!(id: @data[:group_id])
    executor = Person.find_by!(id: @data[:executor_id])
    subject = Person.find_by!(id: @data[:subject_id])
    send
  end

  def perform_participation_assigend
    event = Event.find_by!(id: @data[:event_id])
    executor = Person.find_by!(id: @data[:executor_id])
    subject = Person.find_by!(id: @data[:subject_id])
    send
  end

  def webhook
    @webhook ||= Webhook.find_by(id: @webhook_id)
  end

  def send
    uri = URI.parse(webhook.target_url)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = @data.to_json
    http.request(request)
  end

end
