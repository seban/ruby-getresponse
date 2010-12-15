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

end