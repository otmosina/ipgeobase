# frozen_string_literal: true

require "test_helper"

class IpgeobaseTest < Minitest::Test
  def setup
    @ip = "83.169.216.199"
    @xml_response = File.read("test/fixtures/response.xml")
  end

  def test_that_it_has_a_version_number
    refute_nil ::Ipgeobase::VERSION
  end

  def test_lookup404
    stub_request(:get, "http://ip-api.com/xml/#{@ip}")
      .to_return(status: 404)

    ip_meta = Ipgeobase.lookup(@ip)
    refute ip_meta.instance_of?(Ipgeobase::IpMeta)
    assert ip_meta.instance_of?(Ipgeobase::Error)
    assert ip_meta.message == "Can not get data from remote source"
  end

  def test_lookup500
    stub_request(:get, "http://ip-api.com/xml/#{@ip}")
      .to_return(status: 500)

    ip_meta = Ipgeobase.lookup(@ip)
    refute ip_meta.instance_of?(Ipgeobase::IpMeta)
    assert ip_meta.instance_of?(Ipgeobase::Error)
    assert ip_meta.message == "Can not get data from remote source"
  end

  def test_lookup_success
    stub_request(:get, "http://ip-api.com/xml/#{@ip}")
      .to_return(body: @xml_response)

    ip_meta = Ipgeobase.lookup(@ip)
    assert ip_meta.instance_of?(Ipgeobase::IpMeta)
    assert ip_meta.city == "Baranchinskiy"
    assert ip_meta.country == "Russia"
    assert ip_meta.countryCode == "RU"
    assert ip_meta.lat.rounc(2) == 58.1617.rounc(2)
    assert ip_meta.lon.rounc(2) == 59.6991.rounc(2)
  end
end
