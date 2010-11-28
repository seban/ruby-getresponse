require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class GetResponse::CampaignTest < Test::Unit::TestCase

  def test_initialize
    campaign = GetResponse::Campaign.new("id" => 1005, "name" => "test_campaign",
      "from_name" => "Joe Doe", "from_email" => "test@test.xx", "reply_to_email" => "bounce@test.xx",
      "created_on" => "2010-02-15 15:40")

    assert_equal 1005, campaign.id
    assert_equal "test_campaign", campaign.name
    assert_equal "Joe Doe", campaign.from_name
    assert_equal "test@test.xx", campaign.from_email
    assert_equal "bounce@test.xx", campaign.reply_to_email
    assert_equal "2010-02-15 15:40", campaign.created_on
  end

end
