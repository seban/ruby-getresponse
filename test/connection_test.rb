require "rubygems"
require "test/unit"
require "rr"
require "json"
require File.dirname(__FILE__) + "/../lib/get_response.rb"

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


  def test_get_account_info
    mock(@mocked_response).body { get_account_info_resp }
    result = @gr_connection.get_account_info

    assert_kind_of GetResponse::Account, result
  end


  protected


  def get_account_info_resp
    {
      "result" => {
        "login" => "test",
        "from_name" => "Test name",
        "from_email" => "test@test.xx",
        "created_on" => "2010-02-12"
      },
      "errors" => nil
    }.to_json
  end

end
