require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class AccountTest < Test::Unit::TestCase

  def test_initialize
    account = GetResponse::Account.new({"login" => "test", "from_name" => "From test",
      "from_email" => "email@test.xx", "created_on" => "2010-02-12"}, connection)

    assert_kind_of GetResponse::Account, account
    assert_equal "test", account.login
    assert_equal "From test", account.name
    assert_equal "email@test.xx", account.email
    assert_equal "2010-02-12", account.created_on
  end


  def test_from_fields
    @connection = connection
    mock(@connection).send_request("get_account_from_fields") { from_fields_resp }
    @account = new_account({}, @connection)
    from_fields = @account.from_fields

    assert_kind_of Array, from_fields
    assert_equal true, from_fields.all? { |field| field.instance_of? GetResponse::FromField }
  end


  protected


  def new_account(options = {}, new_conn = nil)
    GetResponse::Account.new({
      "login" => "test",
      "from_name" => "From test",
      "from_email" => "email@test.xx",
      "created_on" => "2010-02-12"
     }.merge(options), (new_conn || connection))
  end


  def connection
    GetResponse::Connection.new("my_secret_api_key")
  end


  # Fetch from fields for account.
  #
  # returns:: [FromField]
  def from_fields_resp
    {
      "result" => {
          "1024" => {
          "created_on" => "2010-12-14 00:00:00",
          "email" => "email@text.xx",
          "name" => "default"
        }
      },
      "error" => nil
    }
  end
end
