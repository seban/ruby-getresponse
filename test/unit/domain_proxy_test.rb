require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class DomainProxyTest < Test::Unit::TestCase

  def setup
    @connection = GetResponse::Connection.new("API_KEY")
    @domain_proxy = GetResponse::DomainProxy.new(@connection)
  end


  def test_all
    mock(@connection).send_request("get_account_domains") { all_domains_resp }
    all_domains = @domain_proxy.all

    assert_kind_of Array, all_domains
    assert_equal true, all_domains.all? { |obj| obj.instance_of?(GetResponse::Domain) }
  end


  protected


  def all_domains_resp
    {
      "result" => {
        "123" => {
          "domain" => "domain.com",
          "created_on" => "2011-01-20 00:00:00"
        }
      },
      "error" => nil
    }
  end

end