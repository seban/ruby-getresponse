require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class GetResponse::MessageTest < Test::Unit::TestCase

  def setup
    @connection = GetResponse::Connection.new("my_api_key")
    @message = GetResponse::Message.new({:id => "msg_id"}, @connection)
  end


  def test_contents
    mock(@connection).send_request("get_message_contents", :message => @message.id) { JSON.parse get_message_contents }
    contents = @message.contents

    assert_kind_of Hash, contents
    assert_kind_of String, contents["html"]
    assert_kind_of String, contents["plain"]
  end

end