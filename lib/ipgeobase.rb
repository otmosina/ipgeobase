# frozen_string_literal: true

require_relative "ipgeobase/version"
require "faraday"

require "faraday/net_http"
require_relative "./ipgeobase/ip_meta"
Faraday.default_adapter = :net_http

# module for lookup meta info about ip
module Ipgeobase
  class Error < StandardError; end
  # Your code goes here...
  class << self
    def lookup(ip)
      xml = get_xml(ip)
      return xml if xml.class.inspect.match(/Error/)

      IpMeta.parse(xml)
    end

    def get_xml(ip)
      response = Faraday.get("http://ip-api.com/xml/#{ip}")
      if response.status == 200
        response.body
      else
        Error.new("Can not get data from remote source")
      end
    end
  end
end
