require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class GetResponse::CampaignTest < Test::Unit::TestCase

  def setup
    @gr_connection = GetResponse::Connection.new("my_secret_api_key")
    @campaign = GetResponse::Campaign.new({"id" => 1005, "name" => "test_campaign",
      "from_name" => "Joe Doe", "from_email" => "test@test.xx", "reply_to_email" => "bounce@test.xx",
      "created_on" => "2010-02-15 15:40"}, @gr_connection)
  end


  def test_contacts
    mock(@gr_connection).send_request('get_contacts', {:campaigns => [@campaign.id]}) { JSON.parse get_contacts_resp }
    contacts = @campaign.contacts

    assert_kind_of Array, contacts
    assert contacts.all? { |contact| contact.kind_of? GetResponse::Contact }
  end

end
