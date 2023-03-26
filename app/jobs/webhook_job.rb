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
    when 'add_request_created' then perform_add_request_created
    when 'add_request_approved' then perform_add_request_approved
    when 'participation_assigend' then perform_participation_assigned
    else raise(ArgumentError, "Unknown webhook type #{webhook.webhook_type}")
    end
  end

  def perform_add_request_created
    group = Group.find_by!(id: @data[:group_id])
    requester = Person.find_by!(id: @data[:requester_id])
    subject = Person.find_by!(id: @data[:subject_id])
    payload = { group: group.attributes, requester: requester.attributes, subject: subject.attributes }
    send(payload)
  end

  def perform_add_request_approved
    group = Group.find_by!(id: @data[:group_id])
    approver = Person.find_by!(id: @data[:approver_id])
    subject = Person.find_by!(id: @data[:subject_id])
    payload = { group: group.attributes, approver: approver.attributes, subject: subject.attributes }
    send(payload)
  end

  def perform_participation_assigned
    event = Event.find_by!(id: @data[:event_id])
    executor = Person.find_by!(id: @data[:executor_id])
    subject = Person.find_by!(id: @data[:subject_id])
    payload = { event: event.attributes, executor: executor.attributes, subject: subject.attributes }
    send(payload)
  end

  def webhook
    @webhook ||= Webhook.find_by(id: @webhook_id)
  end

  def send(payload)
    uri = URI.parse(webhook.target_url)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true unless uri.scheme == 'http'
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = payload.to_json
    http.request(request)
  end

end
