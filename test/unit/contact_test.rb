require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class ContactTest < Test::Unit::TestCase

  include RR::Adapters::TestUnit


  def setup
    @gr_connection = GetResponse::Connection.new("my_secret_api_key")
    @mocked_response = mock
    mock(@mocked_response).code.any_times { 200 }
    mock(Net::HTTP).start("api2.getresponse.com", 80) { @mocked_response }
  end


  def test_attributes_without_customs
    satisfy_mocks

    contact = new_contact
    attrs = contact.attributes

    assert_kind_of Hash, attrs
    assert_equal 3, attrs.keys.size
    assert_equal "sebastian@somehost.pl", attrs["email"]
    assert_equal "Sebastian", attrs["name"]
    assert_equal "myCampaignId", attrs["campaign"]
  end


  def test_attributes_without_customs_with_customs
    satisfy_mocks

    contact = new_contact("customs" => { "one" => "two" })
    attrs = contact.attributes

    assert_kind_of Hash, attrs
    assert_equal 4, attrs.keys.size
    assert_equal "sebastian@somehost.pl", attrs["email"]
    assert_equal "Sebastian", attrs["name"]
    assert_equal "myCampaignId", attrs["campaign"]
    assert_kind_of Array, attrs["customs"]
    assert_equal [{ "name" => "one", "content" => "two" }], attrs["customs"]
  end


  def test_destroy_contact
    mock(@mocked_response).body { destroy_contact_mock }
    contact = new_contact("id" => "45bgT")

    resp = contact.destroy
    assert_equal true, resp
  end


  def test_destroy_contact_without_id
    satisfy_mocks
    contact = new_contact

    exception = assert_raise(GetResponse::GetResponseError) { contact.destroy }
    assert_equal "Can't delete contact without id", exception.message
  end


  def test_destroy_missing_contact
    mock(@mocked_response).body { destroy_missing_contact_mock }
    contact =  new_contact("id" => "45bgT")

    exception = assert_raise(GetResponse::GetResponseError) { contact.destroy }
    assert_equal "Missing contact", exception.message
  end


  def test_update_good_data
    mock(@mocked_response).body { add_contact_queued_response }
    contact = new_contact("id" => "45bgT")

    resp = contact.update("name" => "My new name")
    assert_equal true, resp
  end


  def test_update_exception
    mock(@mocked_response).body { add_contact_invalid_email_syntax }
    contact = new_contact("id" => "45bgT")

    exception = assert_raise(GetResponse::GetResponseError) { contact.update("email" => "sebastian//host.xyz") }
    assert_equal "Invalid email syntax", exception.message
  end


  def test_move_contact_success
    mock(@mocked_response).body { move_contact_success }
    contact = new_contact("id" => "45bgT")
    resp = contact.move("myNewCampaignId")

    assert_equal true, resp
  end


  def test_move_contact_fail
    mock(@mocked_response).body { move_contact_fail }
    contact = new_contact("id" => "45bgT")

    exception = assert_raise(GetResponse::GetResponseError) { contact.move("blah") }
    assert_equal "Missing campaign", exception.message
  end


  def test_geoip
    mock(@mocked_response).body { geo_ip }
    contact = new_contact("id" => "45bgT")
    localization = contact.geoip

    assert_kind_of Hash, localization
    assert localization.keys.include? "latitude"
    assert localization.keys.include? "longitude"
    assert localization.keys.include? "country"
    assert localization.keys.include? "region"
    assert localization.keys.include? "city"
    assert localization.keys.include? "country_code"
    assert localization.keys.include? "postal_code"
    assert localization.keys.include? "dma_code"
  end


  def test_set_cycle_success
    mock(@mocked_response).body { set_cycle_success_mock }
    contact = new_contact("id" => "45bgT")
    resp = contact.set_cycle("5")

    assert_equal true, resp
  end


  def test_set_cycle_missing_contact
    mock(@mocked_response).body { set_cycle_fail_mock }
    contact = new_contact("id" => "45bgT")

    exception = assert_raise(GetResponse::GetResponseError) { contact.set_cycle("6") }
    assert_equal "Missing contact", exception.message
  end


  def test_get_customs
    mock(@mocked_response).body { customs_response }
    contract = new_contact("id" => "45bgT")
    resp = contract.customs

    assert_kind_of Hash, resp
  end


  def test_opens
    mock(@mocked_response).body { contact_opens_response }
    contact = new_contact
    resp = contact.opens

    assert_kind_of Hash, resp
    assert_equal 2, resp.keys.size
  end


  protected


  def new_contact(options = {})
    GetResponse::Contact.new({
      "email" => "sebastian@somehost.pl",
      "name" => "Sebastian",
      "campaign" => "myCampaignId",
    }.merge(options), @gr_connection)
  end


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


  def destroy_contact_mock
    { "result" => { "deleted" => 1 }, "error" => nil }.to_json
  end


  def destroy_missing_contact_mock
    { "result" => nil, "error" => "Missing contact" }.to_json
  end


  def move_contact_success
    { "result" => { "updated" => 1 }, "error" => nil }.to_json
  end


  def move_contact_fail
    { "result" => nil, "error" => "Missing campaign" }.to_json
  end


  def geo_ip
    { "result" => {
      "latitude" => "54.35",
      "longitude"    => "18.6667",
      "country"      => "Poland",
      "region"       => "82",
      "city"         => "Gdansk",
      "country_code" => "PL",
      "postal_code"  => nil,
      "dma_code"     => 0

      },
      "error" => nil
    }.to_json
  end


  def set_cycle_success_mock
    { "result" => { "updated" => 1 }, "error" => nil }.to_json
  end


  def set_cycle_fail_mock
    { "result" => nil, "error" => "Missing contact" }.to_json
  end


  def satisfy_mocks
    Net::HTTP.start("api2.getresponse.com", 80)
  end


  def customs_response
    {
      "result" => {
        "car"  => "big",
        "bike" => ["white", "blue"]
      },
      "error"  => nil
    }.to_json
  end


  def contact_opens_response
    {
      "result" => {
        "message_id_1" => (Time.now - (1 * 24 * 60 * 60)).to_s,
        "message_id_2" => (Time.now - (2 * 24 * 60 * 60)).to_s
      },
      "error" => nil
    }.to_json
  end

end
