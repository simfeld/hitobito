# encoding: utf-8

require 'net/http'
require 'uri'

class WebhookController < ApplicationController
  def send
    uri = URI.parse()

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = content
    http.request(request)
  end
end
