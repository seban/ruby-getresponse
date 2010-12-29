require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class GetResponse::ContactProxyTest < Test::Unit::TestCase


  def setup
    @connection = GetResponse::Connection.new("my_test_api_key")
    @proxy = GetResponse::ContactProxy.new(@connection)
  end


  def test_all
    mock(@connection).send_request('get_contacts', {}) { JSON.parse get_contacts_resp }
    all_contacts = @proxy.all

    assert_kind_of Array, all_contacts
    assert all_contacts.all? { |contact| contact.kind_of? GetResponse::Contact }
  end


  def test_all_with_passed_conditions
    mock(@connection).send_request('get_contacts', { :campaigns => ["vY2"] }) { JSON.parse get_contacts_resp }
    contacts = @proxy.all(:campaigns => ["vY2"])

    assert_kind_of Array, contacts
    assert contacts.all? { |contact| contact.kind_of? GetResponse::Contact }
  end


  def test_create_success
    new_contact_attrs = {"name"     => "John Doe", "email" => "john.d@somewhere.com",
                         "campaign" => "campaignId", "customs" => {"source" => "mainpage"}}
    attrs_sent_to_service = new_contact_attrs.merge("customs" => [{"name" => "source", "content" => "mainpage"}])

    mock(@connection).send_request(:add_contact, attrs_sent_to_service) { {'result' => {'queued' => 1}} }
    contact = @proxy.create(new_contact_attrs)

    assert_kind_of GetResponse::Contact, contact
  end


  def test_create_fail
    new_contact_attrs = {"name"     => "John Doe", "email" => "john.d@somewhere.com",
                         "campaign" => "campaignId", "customs" => {"source" => "mainpage"}}
    attrs_sent_to_service = new_contact_attrs.merge("customs" => [{"name" => "source", "content" => "mainpage"}])

    fail_exception = GetResponse::GetResponseError.new("Contact already queued for target campaign")
    mock(@connection).send_request(:add_contact, attrs_sent_to_service) { raise fail_exception }

    assert_raise(GetResponse::GetResponseError) { @proxy.create(new_contact_attrs) }
  end

end