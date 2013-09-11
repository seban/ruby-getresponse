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


  def test_create_good_attributes
    new_campaign_params = {
      "name" => "Campaign name",
      "description" => "Campaign description",
      "language_code" => "pl",
      "from_field" => GetResponse::FromField.new("id" => "1001"),
      "reply_to_field" => GetResponse::FromField.new("id" => "1002"),
      "confirmation_body" => GetResponse::ConfirmationBody.new("id" => "1003"),
      "confirmation_subject" => GetResponse::ConfirmationSubject.new("id" => "1004")
    }
    request_params = {
      "name" => "Campaign name",
      "description" => "Campaign description",
      "language_code" => "pl",
      "from_field" => "1001",
      "reply_to_field" => "1002",
      "confirmation_body" => "1003",
      "confirmation_subject" => "1004"
    }
    mock(@connection).send_request("add_campaign", request_params) { add_campaign_success_response }
    result = @proxy.create(new_campaign_params)

    assert_kind_of GetResponse::Campaign, result
    assert_not_nil result.id
  end

  def test_by_name
    request_params = { 'name' => { 'EQUALS' => 'my_campaign_1' } }
    mock(@connection).send_request('get_campaigns', request_params) { campaign_found_response }
    result = @proxy.by_name('my_campaign_1')
    assert_kind_of GetResponse::Campaign, result
    assert result.name == 'my_campaign_1'
  end


  def test_by_id
    request_params = { 'campaign' => 'CAMPAIGN_ID'}
    mock(@connection).send_request('get_campaign', request_params) { campaign_found_response }
    result = @proxy.by_id('CAMPAIGN_ID')
    assert_kind_of GetResponse::Campaign, result
    assert result.id == 'CAMPAIGN_ID'
    assert result.name == 'my_campaign_1'
  end

  def test_by_id_raise
    request_params = { 'campaign' => 'NIL_CAMPAIGN_ID'}
    mock(@connection).send_request('get_campaign', request_params) { campaign_not_found_response }
    assert_raise GetResponse::GRNotFound do
      result = @proxy.by_id('NIL_CAMPAIGN_ID')
    end 
  end

  def test_by_name_raise
    request_params = { 'name' => { 'EQUALS' => 'NIL_CAMPAIGN_NAME' } }
    mock(@connection).send_request('get_campaigns', request_params) { campaign_not_found_response }
    assert_raise GetResponse::GRNotFound do
      result = @proxy.by_name('NIL_CAMPAIGN_NAME')
    end
  end

  protected


  def add_campaign_success_response
    {
      "result" => {
        "CAMPAIGN_ID" => "abc1",
        "added" => 1
      },
      "errors" => nil
    }
  end

  def campaign_found_response
    {
      'result' => {
        "CAMPAIGN_ID" => {
          "name" => "my_campaign_1",
          "description" => "My campaign",
          "optin" => "single",
          "from_name" => "My From Name",
          "from_email" => "me@emailaddress.com",
          "reply_to_email" => "replies@emailaddress.com",
          "created_on" => "2010-01-01 00:00:00"
          }
        }
      }

  end

  def campaign_not_found_response
    {
    'result' => {} 
    }
  end
end
