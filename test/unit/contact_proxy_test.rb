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
    mock(@connection).send_request("get_contacts_subscription_stats", conditions) do
      JSON.parse get_contact_subscription_stats_response
    end
    stats = @proxy.statistics(conditions)

    assert_kind_of Hash, stats
  end


  protected


  def get_contact_subscription_stats_response
    {
      "result" => {
        "2010-01-01" => {
          "n3i" => {
            "iphone" => 0,
            "www" => 32,
            "sale" => 64,
            "leads" => 2,
            "forward" => 0,
            "panel" => 4,
            "api" => 128,
            "import" => 0,
            "email" => 16,
            "survey" => 1
          },
          "pou" => {
            "iphone" => 8,
            "www" => 0,
            "sale" => 0,
            "leads" => 64,
            "forward" => 0,
            "panel" => 0,
            "api" => 512,
            "import" => 16,
            "email" => 0,
            "survey" => 0
          }
        },
        "2010-01-02" => {
          "n3i" => {
            "iphone" => 0,
            "www" => 64,
            "sale" => 128,
            "leads" => 8,
            "forward" => 1,
            "panel" => 8,
            "api" => 1024,
            "import" => 0,
            "email" => 2,
            "survey" => 8
          },
          "pou" => {
            "iphone" => 0,
            "www" => 0,
            "sale" => 0,
            "leads" => 128,
            "forward" => 0,
            "panel" => 0,
            "api" => 2048,
            "import" => 0,
            "email" => 0,
            "survey" => 0
          }
        }
      },
    "error" => nil
    }.to_json
  end

end