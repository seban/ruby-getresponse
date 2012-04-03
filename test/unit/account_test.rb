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
    @account = new_account({}, @connection)

    assert_kind_of GetResponse::FromFieldsProxy, @account.from_fields
  end


  def test_domains
    @connection = connection
    @account = new_account({}, @connection)

    assert_kind_of GetResponse::DomainProxy, @account.domains
  end


  def test_blacklist
    @connection = connection
    @account = new_account({}, @connection)
    mock(@connection).send_request("get_account_blacklist") { get_blacklist_response }
    blacklist = @account.blacklist

    assert_kind_of GetResponse::Blacklist, blacklist
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

end
