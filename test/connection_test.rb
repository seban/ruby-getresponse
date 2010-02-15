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


  def test_get_campaigns_without_conditions
    mock(@mocked_response).body { get_campaigns_resp }

    response = @gr_connection.get_campaigns
    assert_kind_of Array, response
    response.each { |campaign| assert_kind_of GetResponse::Campaign, campaign }
  end


  def test_get_campaigns_with_empty_results
    mock(@mocked_response).body { { "result" => [] }.to_json }

    response = @gr_connection.get_campaigns(:name.is_eq => "my_fake_name")
    assert_equal [], response
  end


  def test_get_campaign
    mock(@mocked_response).body { get_campaigns_resp }

    response = @gr_connection.get_campaign(1000)
    assert_kind_of GetResponse::Campaign, response
  end


  def test_get_campaign_with_bad_id
    mock(@mocked_response).body { { "result" => [] }.to_json }

    response = @gr_connection.get_campaign(98765432)
    assert_nil response
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


  def get_campaigns_resp
    {
      "result" => {
        "1000" => {
          "name"              => "my_campaign_1",
          "from_name"         => "My From Name",
          "from_email"        => "me@emailaddress.com",
          "reply_to_email"    => "replies@emailaddress.com",
          "created_on"        => "2010-01-01 00:00:00"
        },
        "1001" => {
          "name"              => "my_campaign_2",
          "from_name"         => "My From Name",
          "from_email"        => "me@emailaddress.com",
          "reply_to_email"    => "replies@emailaddress.com",
          "created_on"        => "2010-01-01 00:00:00"
        }
      }
    }.to_json
  end

end
