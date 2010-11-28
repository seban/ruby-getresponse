require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class GetResponse::CampaignProxyTest < Test::Unit::TestCase

  def setup
    @connection = GetResponse::Connection.new("my_test_api_key")
    @proxy = GetResponse::CampaignProxy.new(@connection)
  end


  def test_all
    mock(@connection).send_request.with_any_args { JSON.parse get_campaigns_resp }
    all_campaigns = @proxy.all

    assert_kind_of Array, all_campaigns
    assert all_campaigns.all? { |campaign| campaign.kind_of? GetResponse::Campaign }
  end
end