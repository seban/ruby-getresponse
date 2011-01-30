require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class FromFieldsProxyTest < Test::Unit::TestCase

  def setup
    @connection = GetResponse::Connection.new("API_KEY")
    @proxy = GetResponse::FromFieldsProxy.new(@connection)
  end


  def test_all
    mock(@connection).send_request("get_account_from_fields") { get_account_from_fields_resp }
    from_fields = @proxy.all

    assert_kind_of Array, from_fields
    assert_equal true, from_fields.all? { |field| field.instance_of? GetResponse::FromField }
  end

end