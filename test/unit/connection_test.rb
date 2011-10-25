require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class GetResponse::ConnectionTest < Test::Unit::TestCase

  include RR::Adapters::TestUnit

  def setup
    @gr_connection = GetResponse::Connection.new("my_secret_api_key")
    @mocked_response = mock
    mock(@mocked_response).code.any_times { 200 }
    mock(Net::HTTP).start("api2.getresponse.com", 80).any_times { @mocked_response }
  end


  def test_ping
    mock(@mocked_response).body { "{\"error\":null,\"result\":{\"ping\":\"pong\"}}" }

    response = @gr_connection.ping
    assert_equal true, response
  end


  def test_ping_with_bad_api_key
    mock(@mocked_response).code { "403" }

    exception = assert_raise(GetResponse::GetResponseError) { @gr_connection.ping }
    assert_equal 'API key verification failed', exception.message
  end


  def test_account
    mock(@mocked_response).body { get_account_info_resp }
    result = @gr_connection.account

    assert_kind_of GetResponse::Account, result
  end


  def test_campaigns
    assert_kind_of GetResponse::CampaignProxy, @gr_connection.campaigns
  end


  def test_contacts
    assert_kind_of GetResponse::ContactProxy, @gr_connection.contacts
  end


  def test_messages
    assert_kind_of GetResponse::MessageProxy, @gr_connection.messages
  end


  def test_confirmation_bodies
    assert_kind_of GetResponse::ConfirmationBodyProxy, @gr_connection.confirmation_bodies
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


  def message_struct(options = {})
    {
      'campaign'      => 'CAMPAIGN_ID',
      'type'          => 'follow-up',
      'subject'       => 'My follow-up',
      'day_of_cycle'  => '8',
      'flags'         => ['clicktrack', 'openrate'],
      'created_on'    => '2010-01-01 00:00:00'
    }.merge(options)
  end


  def get_messages_resp
    { "result" => {
      "123" => message_struct,
      "456" => message_struct,
      "789" => message_struct
      }
    }.to_json
  end


  def get_message_resp
    { "result" => {
        "123" => message_struct
      }
    }.to_json
  end

end
