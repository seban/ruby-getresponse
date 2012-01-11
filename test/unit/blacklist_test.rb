require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class GetResponse::BlacklistTest < Test::Unit::TestCase

  def setup
    @ancestor = Object.new
    @connection = GetResponse::Connection.new "fake_api_key"
    @blacklist = GetResponse::Blacklist.new(["for@foobar.com", "foo@", "@bar.com"], @connection, @ancestor)
  end


  def test_truth
    assert true
  end

end