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


  def test_domain
    mock(@gr_connection).send_request("get_campaign_domain", {"campaign" => @campaign.id}) { domain_resp }
    domain = @campaign.domain

    assert_kind_of GetResponse::Domain, domain
  end


  def test_set_domain
    @domain = GetResponse::Domain.new("id" => "23", "domain" => "domain.com")
    params = { "domain" => @domain.id, "campaign" => @campaign.id }
    mock(@gr_connection).send_request("set_campaign_domain", params) { set_domain_resp }
    domain = @campaign.domain= @domain

    assert_kind_of GetResponse::Domain, domain
  end


  def test_messages
    params = {:campaigns => [@campaign.id]}
    mock(@gr_connection).send_request("get_messages", params) { JSON.parse get_messages_response_success }
    messages = @campaign.messages

    assert_kind_of Array, messages
    assert_equal true, messages.all? { |msg| msg.kind_of? GetResponse::Message }
  end


  def test_messages_with_conditions
    params = {:campaigns => [@campaign.id], :type => "newsletter"}
    mock(@gr_connection).send_request("get_messages", params) { JSON.parse get_messages_response_success }
    messages = @campaign.messages(:type => "newsletter")

    assert_kind_of Array, messages
    assert_equal true, messages.all? { |msg| msg.kind_of? GetResponse::Message }
    assert_equal true, messages.all? { |msg| msg.type == "newsletter" }
  end


  def test_get_postal_address
    mock(@gr_connection).send_request("get_campaign_postal_address", {"campaign" => @campaign.id}) { JSON.parse get_postal_address }
    postal_address = @campaign.postal_address

    assert_kind_of Hash, postal_address
    assert_not_nil postal_address["name"]
    assert_not_nil postal_address["address"]
    assert_not_nil postal_address["city"]
    assert_not_nil postal_address["state"]
    assert_not_nil postal_address["zip"]
    assert_not_nil postal_address["country"]
    assert_not_nil postal_address["design"]
  end


  def test_set_postal_address
    postal_address = JSON.parse(get_postal_address)
    request_params = {"campaign" => @campaign.id}.merge(postal_address)
    response = {"result" => {"updated" => "1"}, "error" => nil}
    mock(@gr_connection).send_request("set_campaign_postal_address", request_params) { response }
    result = @campaign.postal_address = postal_address

    assert_kind_of Hash, result
  end


  def test_subscriptions_stats_without_conditions
    conditions = {:campaigns => [@campaign.id]}
    mock(@gr_connection).send_request("get_contacts_subscription_stats", conditions) do
      JSON.parse get_contact_subscription_stats_response
    end
    stats = @campaign.subscription_statistics

    assert_kind_of Hash, stats
  end


  def test_subscriptions_stats_with_conditions
    conditions = {:created_on => {:from => "2010-01-09", :to => "2011-10-01"}}
    parsed_conditions = {:created_on => {"FROM" => "2010-01-09", "TO" => "2011-10-01"}}
    mock(@gr_connection).send_request("get_contacts_subscription_stats", parsed_conditions.merge(:campaigns => [@campaign.id])) do
      JSON.parse get_contact_subscription_stats_response
    end
    stats = @campaign.subscription_statistics(conditions)

    assert_kind_of Hash, stats
  end


  def test_get_deleted_contacts
    mock(@gr_connection).send_request('get_contacts_deleted', {:campaigns => [@campaign.id]}) { JSON.parse get_contacts_deleted_resp }
    deleted_contacts = @campaign.deleted_contacts

    assert_kind_of Array, deleted_contacts
    assert deleted_contacts.all? { |contact| contact.kind_of? GetResponse::Contact }
    assert deleted_contacts.all? { |contact| contact.reason == "bounce" }
    assert deleted_contacts.all? { |contact| !contact.deleted_on.nil? }
  end


  def test_set_from_field_with_from_field_object
    @campaign.from_field = GetResponse::FromField.new("name" => "text", "email" => "test@email.cc",
      "created_on" => "2010-12-23 00:00:00", "id" => "234")

    assert_kind_of GetResponse::FromField, @campaign.from_field
  end


  def test_set_from_field_with_string
    mock(@gr_connection).send_request("get_account_from_field", {"account_from_field" => '1024'}) { get_account_from_fields_resp }
    @campaign.from_field = "1024"

    assert_kind_of GetResponse::FromField, @campaign.from_field
    assert_equal "1024", @campaign.from_field.id
  end


  def test_set_reply_to_field_with_from_field_object
    @campaign.reply_to_field = GetResponse::FromField.new("name" => "text", "email" => "test@email.cc",
      "created_on" => "2010-12-23 00:00:00", "id" => "234")

    assert_kind_of GetResponse::FromField, @campaign.reply_to_field
  end


  def test_set_reply_to_field_with_string
    mock(@gr_connection).send_request("get_account_from_field", {"account_from_field" => '1024'}) { get_account_from_fields_resp }
    @campaign.reply_to_field = "1024"

    assert_kind_of GetResponse::FromField, @campaign.reply_to_field
    assert_equal "1024", @campaign.reply_to_field.id
  end


  def test_set_confirmation_body_with_confirmation_body
    confirmation_body = GetResponse::ConfirmationBody.new("plain" => "plain", "html" => "<p>html</p>",
      "language_code" => "en", "id" => "1001")
    @campaign.confirmation_body = confirmation_body

    assert_kind_of GetResponse::ConfirmationBody, @campaign.confirmation_body
    assert_equal confirmation_body.id, @campaign.confirmation_body.id
  end


  def test_set_confirmation_body_with_string
    mock(@gr_connection).send_request("get_confirmation_body", {"confirmation_body" => "1001"}) do
      confirmation_body_response
    end
    @campaign.confirmation_body = "1001"

    assert_kind_of GetResponse::ConfirmationBody, @campaign.confirmation_body
    assert_equal "1001", @campaign.confirmation_body.id
  end


  def test_set_confirmation_subject_with_confirmation_subject
    confirmation_subject = GetResponse::ConfirmationSubject.new("content" => "Confirm",
      "language_code" => "en", "id" => "1001")
    @campaign.confirmation_subject = confirmation_subject

    assert_kind_of GetResponse::ConfirmationSubject, @campaign.confirmation_subject
    assert_equal "1001", @campaign.confirmation_subject.id
  end


  def test_set_confirmation_subject_with_string
    params = {"confirmation_subject" => "1001"}
    mock(@gr_connection).send_request("get_confirmation_subject", params) { get_confirmation_subject_response }
    @campaign.confirmation_subject = "1001"

    assert_kind_of GetResponse::ConfirmationSubject, @campaign.confirmation_subject
    assert_equal "1001", @campaign.confirmation_subject.id
  end


  def test_get_blacklist
    params = {"campaign" => @campaign.id}
    mock(@gr_connection).send_request("get_campaign_blacklist", params) { get_blacklist_response }
    blacklist = @campaign.blacklist

    assert_kind_of GetResponse::Blacklist, blacklist
  end


  def test_create_follow_up
    follow_up_attributes = {
      "subject" => "My test follow up",
      "contents" => { "plain" => "Plain follow-up content" },
      "day_of_cycle" => 1024
    }
    mock(@gr_connection).send_request(:add_follow_up, instance_of(Hash)) { add_follow_up_response }
    result = @campaign.create_follow_up(follow_up_attributes)

    assert_instance_of GetResponse::FollowUp, result
  end


  protected


  def domain_resp
    {
      "result" => {
        "2345" => {
          "domain" => "domain.com",
          "created_on" => "2011-01-20 00:00:00"
        }
      },
      "error" => nil
    }
  end


  def set_domain_resp
    {
      "result" => { "updated" => "1" },
      "error" => nil
    }
  end

end
