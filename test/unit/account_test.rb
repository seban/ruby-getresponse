require File.join(File.dirname(__FILE__), '../test_helper')

class AccountTest < Test::Unit::TestCase

  def test_initialize
    account = GetResponse::Account.new("login" => "test", "from_name" => "From test",
      "from_email" => "email@test.xx", "created_on" => "2010-02-12")

    assert_kind_of GetResponse::Account, account
    assert_equal "test", account.login
    assert_equal "From test", account.name
    assert_equal "email@test.xx", account.email
    assert_equal "2010-02-12", account.created_on
  end
end
