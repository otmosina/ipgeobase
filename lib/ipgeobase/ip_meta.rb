# frozen_string_literal: true

require "happymapper"

module Ipgeobase
  class IpMeta
    include HappyMapper

    tag "query"

    element :city, String, tag: "city"
    element :country, String, tag: "country"
    element :countryCode, String, tag: "countryCode"
    element :lat, Float, tag: "lat"
    element :lon, Float, tag: "lon"
  end
end
