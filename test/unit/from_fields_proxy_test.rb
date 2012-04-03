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


  def test_create_success
    new_from_field_attrs = { "name" => "My new from field", "email" => "new_from@field.ca" }
    mock(@connection).send_request("add_account_from_field", new_from_field_attrs) { add_account_from_field_success }
    from_field = @proxy.create(new_from_field_attrs)

    assert_kind_of GetResponse::FromField, from_field
  end


  def test_create_fail
    new_from_field_attrs = { "name" => "", "email" => "" }
    mock(@connection).send_request("add_account_from_field", new_from_field_attrs) do
      raise GetResponse::GetResponseError.new(add_account_from_field_fail["error"])
    end

    assert_raise(GetResponse::GetResponseError) { @proxy.create(new_from_field_attrs) }
  end


  def test_find_by_id
    mock(@connection).send_request("get_account_from_field", {"account_from_field" => 1024}) { get_account_from_fields_resp }
    from_field = @proxy.find(1024)

    assert_kind_of GetResponse::FromField, from_field
    assert_equal "1024", from_field.id
  end


  def test_find_by_id_with_bad_id
    mock(@connection).send_request("get_account_from_field", {"account_from_field" => "bad_id"}) { {"result"=>{}, "error"=>nil} }

    exception = assert_raise(GetResponse::GetResponseError) { @proxy.find("bad_id") }
    assert_equal "Form field with id 'bad_id' not found.", exception.message
  end

end