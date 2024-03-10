# encoding: utf-8

#  Copyright (c) 2023, Pfadibewegung Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class WebhookJob < BaseJob

  PERSON_FIELDS = [:id, :pbs_number, :first_name, :last_name, :nickname, :address, :town,
                   :zip_code, :country, :primary_group_id].freeze
  GROUP_FIELDS = [:id, :parent_id, :type, :name].freeze
  EVENT_FIELDS = [:id, :location].freeze
  TRANSLATIONS_FIELDS = [:locale, :name, :description].freeze

  self.parameters = [:webhook, :data]

  def initialize(webhook, data)
    super()
    @webhook = webhook
    @data = data
  end

  def perform
    case webhook.webhook_type.to_sym
    when :add_request_created then perform_add_request_created
    when :add_request_approved then perform_add_request_approved
    when :participation_assigend then perform_participation_assigned
    else raise(ArgumentError, "Unknown webhook type #{webhook.webhook_type}")
    end
  end

  def perform_add_request_created
    group = Group.find(@data[:group_id])
    requester = Person.find(@data[:requester_id])
    subject = Person.find(@data[:subject_id])
    payload = {
      group: serialize(group),
      requester: serialize(requester),
      subject: serialize(subject),
    }
    send(payload)
  end

  def perform_add_request_approved
    group = Group.find(@data[:group_id])
    approver = Person.find(@data[:approver_id])
    subject = Person.find(@data[:subject_id])
    payload = {
      group: serialize(group),
      approver: serialize(approver),
      subject: serialize(subject),
    }
    send(payload)
  end

  def perform_participation_assigned
    event = Event.find_by!(id: @data[:event_id])
    executor = @data[:executor_id].nil? ? nil : Person.find_by!(id: @data[:executor_id])
    subject = Person.find_by!(id: @data[:subject_id])
    payload = {
      event: serialize(event),
      executor: executor.nil? ? serialize(executor) : nil,
      subject: serialize(subject),
    }
    send(payload)
  end

  def serialize(entity)
    case entity
    when Event::Course, Event::Camp then
      entity.as_json(only: EVENT_FIELDS, include: { translations: { only: TRANSLATIONS_FIELDS } })
    when Person then
      entity.as_json(only: PERSON_FIELDS)
    when Group then
      entity.as_json(only: GROUP_FIELDS)
    else raise(ArgumentError, "Unknown entity class #{entity.class}")
    end
  end

  def send(payload)
    uri = URI.parse(@webhook.target_url)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true unless uri.scheme == 'http'
    headers = { 'Content-Type': 'application/json' }
    request = Net::HTTP::Post.new(uri.request_uri, headers)
    request.body = payload.to_json
    http.request(request)
  rescue StandardError
    false
  end

  def set_translations(item, key)
    item.except(key, 'translations')
        .merge(empty_translations_hash(key))
        .merge(translations_to_hash(item['translations'], key))
  end

  def empty_translations_hash(key)
    locales.map { |loc| ["#{key}_#{loc}", nil] }.to_h
  end

  def translations_to_hash(translations, key)
    translations.map { |t| ["#{key}_#{t['locale']}", t['label']] }.to_h
  end

  def locales
    @locales ||= Settings.application.languages.keys
  end

end
