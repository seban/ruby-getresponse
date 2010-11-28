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


  def test_account
    mock(@mocked_response).body { get_account_info_resp }
    result = @gr_connection.account

    assert_kind_of GetResponse::Account, result
  end


  def test_campaigns
    assert_kind_of GetResponse::CampaignProxy, @gr_connection.campaigns
  end


  def test_get_messages
    mock(@mocked_response).body { get_messages_resp }

    response = @gr_connection.get_messages

    assert_kind_of Array, response
    response.each { |resp| assert_kind_of GetResponse::Message, resp }
  end


  def test_get_messages_with_conditions
    mock(@mocked_response).body { get_messages_resp }

    response = @gr_connection.get_messages(:type => 'follow-up')
    assert_kind_of Array, response
    response.each { |resp| assert_kind_of GetResponse::Message, resp }
  end


  def test_get_messages_empty_results
    mock(@mocked_response).body { { "result" => {} }.to_json }

    response = @gr_connection.get_messages(:type => 'follow-up')
    assert_kind_of Array, response
    assert response.empty?
  end


  def test_get_messages_with_conditions_empty_results
    mock(@mocked_response).body { { "result" => {} }.to_json }

    response = @gr_connection.get_messages(:type => 'follow-up')
    assert_kind_of Array, response
    assert response.empty?
  end


  def test_get_message
    mock(@mocked_response).body { get_message_resp }
    
    message = @gr_connection.get_message("123")
    assert_kind_of GetResponse::Message, message
    assert_equal "123", message.id
  end


  def test_get_message_with_bad_identifier
    mock(@mocked_response).body { { "result" => {} }.to_json }

    response = @gr_connection.get_message("bad_param")
    assert_nil(response)
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
