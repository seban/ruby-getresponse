require "rubygems"
require "test/unit"
require "rr"
require "json"

require File.dirname(__FILE__) + "/../lib/get_response.rb"

class ContactTest < Test::Unit::TestCase

  include RR::Adapters::TestUnit

  def setup
    @gr_connection = GetResponse::Connection.instance("my_secret_api_key")
    @mocked_response = mock
    mock(Net::HTTP).start("api2.getresponse.com", 80) { @mocked_response }
  end


  def test_create_good_data
    mock(@mocked_response).body { add_contact_queued_response }

    res = GetResponse::Contact.create("email" => "sebastian@somehost.pl", "name" => "Sebastian", "campaign" => "myCampaignId")
    assert_equal true, res
  end


  def test_create_good_data_duplicated
    mock(@mocked_response).body { add_contact_duplicated_response }

    res = GetResponse::Contact.create("email" => "sebastian@somehost.pl", "name" => "Sebastian", "campaign" => "myCampaignId")
    assert_equal true, res
  end


  def test_create_good_data_with_customs
    mock(@mocked_response).body { add_contact_queued_response }

    res = GetResponse::Contact.create("email" => "sebastian@somehost.pl", "name" => "Sebastian",
      "campaign" => "myCampaignId", "customs" => { "one" => "two" })
    assert_equal true, res
  end


  def test_create_bad_email
    mock(@mocked_response).body { add_contact_invalid_email_syntax }

    exception = assert_raise(GetResponse::GetResponseError) do
      GetResponse::Contact.create("email" => "sebastian@.pl", "name" => "Sebastian", "campaign" => "myCampaignId")
    end
    assert_equal "Invalid email syntax", exception.message
  end


  def test_attributes_without_customs
    satisfy_mocks

    contact = GetResponse::Contact.new("email" => "sebastian@somehost.pl", "name" => "Sebastian",
      "campaign" => "myCampaignId")
    attrs = contact.attributes

    assert_kind_of Hash, attrs
    assert_equal 3, attrs.keys.size
    assert_equal "sebastian@somehost.pl", attrs["email"]
    assert_equal "Sebastian", attrs["name"]
    assert_equal "myCampaignId", attrs["campaign"]
  end


  def test_attributes_without_customs_with_customs
    satisfy_mocks

    contact = GetResponse::Contact.new("email" => "sebastian@somehost.pl", "name" => "Sebastian",
      "campaign" => "myCampaignId", "customs" => { "one" => "two" })
    attrs = contact.attributes

    assert_kind_of Hash, attrs
    assert_equal 4, attrs.keys.size
    assert_equal "sebastian@somehost.pl", attrs["email"]
    assert_equal "Sebastian", attrs["name"]
    assert_equal "myCampaignId", attrs["campaign"]
    assert_kind_of Array, attrs["customs"]
    assert_equal [{ "name" => "one", "content" => "two" }], attrs["customs"]
  end


  protected


  # Odpowiedż na "add_contact": zakolejkowany
  def add_contact_queued_response
     { "result" => { "queued" => 1 }, "error" => nil }.to_json
  end


  # Odpowiedż na "add_contact": zakolejkowany
  def add_contact_duplicated_response
     { "result" => { "duplicated" => 1 }, "error" => nil }.to_json
  end


  def add_contact_invalid_email_syntax
    { "result" => nil, "error" => "Invalid email syntax" }.to_json
  end


  def satisfy_mocks
    Net::HTTP.start("api2.getresponse.com", 80)
  end

end
