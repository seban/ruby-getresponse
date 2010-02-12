require "rubygems"
require "test/unit"
require "rr"
require File.dirname(__FILE__) + "/../lib/connection.rb"

class ConnectionTest < Test::Unit::TestCase
  include RR::Adapters::TestUnit

  def setup
    @gr_connection = GetResponse::Connection.new("my_secret_api_key")
    @mocked_response = mock
    mock(Net::HTTP).start("api2.getresponse.com", 80) { @mocked_response }
  end


  def test_ping
    mock(@mocked_response).body { "{\"error\":null,\"result\":{\"ping\":\"pong\"}}" }

    response = @gr_connection.ping
    assert_equal true, response
  end

end
