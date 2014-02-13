require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))
require 'date'

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


  def test_statistics_witohut_conditions
    mock(@connection).send_request("get_contacts_subscription_stats", {}) { JSON.parse get_contact_subscription_stats_response }
    stats = @proxy.statistics

    assert_kind_of Hash, stats
  end


  def test_statistics_with_condition_on_campaign
    mock(@connection).send_request("get_contacts_subscription_stats", {:campaigns => ["n3i", "pou"]}) do
      JSON.parse get_contact_subscription_stats_response
    end
    stats = @proxy.statistics(:campaigns => ["n3i", "pou"])

    assert_kind_of Hash, stats
  end


  def test_statistics_with_conditions_on_date_passed_as_a_date
    from_date = Date.parse("2010-01-09")
    to_date = Date.parse("2011-10-01")
    conditions = {:created_on => {:from => from_date, :to => to_date}}
    parsed_conditions = {:created_on => {
      "FROM" => from_date.strftime, "TO" => to_date.strftime
    }}
    mock(@connection).send_request("get_contacts_subscription_stats", parsed_conditions) do
      JSON.parse get_contact_subscription_stats_response
    end
    stats = @proxy.statistics(conditions)

    assert_kind_of Hash, stats
  end


  def test_statistics_with_conditions_on_date_passed_as_a_string
    conditions = {:created_on => {:from => "2010-01-09", :to => "2011-10-01"}}
    parsed_conditions = {:created_on => {"FROM" => "2010-01-09", "TO" => "2011-10-01"}}
    mock(@connection).send_request("get_contacts_subscription_stats", parsed_conditions) do
      JSON.parse get_contact_subscription_stats_response
    end
    stats = @proxy.statistics(conditions)

    assert_kind_of Hash, stats
  end


  def test_get_deleted_without_conditions
    mock(@connection).send_request('get_contacts_deleted', {}) { JSON.parse get_contacts_deleted_resp }
    deleted_contacts = @proxy.deleted

    assert_kind_of Array, deleted_contacts
    assert deleted_contacts.all? { |contact| contact.kind_of? GetResponse::Contact }
    assert deleted_contacts.all? { |contact| contact.reason == "bounce" }
    assert deleted_contacts.all? { |contact| !contact.deleted_on.nil? }
  end


  def test_get_deleted_with_conditions
    mock(@connection).send_request('get_contacts_deleted', {:reason => "bounce"}) { JSON.parse get_contacts_deleted_resp }
    deleted_contacts = @proxy.deleted(:reason => "bounce")

    assert_kind_of Array, deleted_contacts
    assert deleted_contacts.all? { |contact| contact.kind_of? GetResponse::Contact }
    assert deleted_contacts.all? { |contact| contact.reason == "bounce" }
    assert deleted_contacts.all? { |contact| !contact.deleted_on.nil? }
  end

  def test_by_email_no_campaign
    request_params = { 'email' => { 'EQUALS' => 'nobody@example.com'} }
    mock(@connection).send_request('get_contacts', request_params ) { contact_found_response }
    result = @proxy.by_email('nobody@example.com')
    assert_kind_of GetResponse::Contact, result
    assert result.email == 'nobody@example.com'
    assert result.name == 'No Body'
  end

  def test_by_email_and_campaign
    request_params = { 'campaigns' => ['CAMPAIGN_ID'], 'email' => { 'EQUALS' => 'nobody@example.com'} }
    mock(@connection).send_request('get_contacts', request_params ) { contact_found_response }
    result = @proxy.by_email('nobody@example.com', 'CAMPAIGN_ID')
    assert_kind_of GetResponse::Contact, result
    assert result.email == 'nobody@example.com'
    assert result.name == 'No Body'
    assert result.campaign == 'CAMPAIGN_ID'
  end

  def test_by_email_raise
    request_params = { 'email' => { 'EQUALS' => 'not_existent@example.com' } }
    mock(@connection).send_request('get_contacts', request_params ) { contact_not_found_response }
    assert_raise GetResponse::GRNotFound do
      result = @proxy.by_email('not_existent@example.com')
    end
  end

  protected
  
  def contact_found_response
    {
      'result' => {
        "CONTACT_ID" => {
          "campaign" => "CAMPAIGN_ID",
          "name" => "No Body",
          "email" => "nobody@example.com",
          "origin" => "www",
          "ip" => "1.1.1.1",
          "cycle_day" => 32,
          "changed_on" => nil, 
          "created_on" => "2010-01-01 00:00:00"
        }
      }
    }
  end

  def contact_not_found_response
    {
      'result' => {}
    }
  end

end
