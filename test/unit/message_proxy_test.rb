require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class GetResponse::MessageProxyTest < Test::Unit::TestCase

  def setup
    @connection = GetResponse::Connection.new("my_api_key")
    @message_proxy = GetResponse::MessageProxy.new(@connection)
  end


  def test_all
    mock(@connection).send_request("get_messages", {}) { JSON.parse get_messages_response_success }
    messages = @message_proxy.all

    assert_kind_of Array, messages
    assert_equal true, messages.all? { |msg| msg.kind_of? GetResponse::Message }
  end


  def test_all_with_conditions_on_campaign
    mock(@connection).send_request("get_messages", {:campaigns => ["campaign_id"]}) { JSON.parse get_messages_response_success }
    messages = @message_proxy.all(:campaigns => ["campaign_id"])

    assert_kind_of Array, messages
    assert_equal true, messages.all? { |msg| msg.kind_of? GetResponse::Message }
  end


  def test_all_with_conditions_on_message_type
    mock(@connection).send_request("get_messages", {:type => "newsletter"}) { JSON.parse get_messages_response_success }
    messages = @message_proxy.all(:type => "newsletter")

    assert_kind_of Array, messages
    assert_equal true, messages.all? { |msg| msg.instance_of? GetResponse::Newsletter }
    assert_equal true, messages.all? { |msg| msg.type == "newsletter" }
  end

end