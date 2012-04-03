# encoding: utf-8
require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class GetResponse::ConfirmationBodyProxyTest < Test::Unit::TestCase

  def setup
    @connection = GetResponse::Connection.new("my_test_api_key")
    @proxy = GetResponse::ConfirmationBodyProxy.new(@connection)
  end


  def test_all_without_conditions
    mock(@connection).send_request("get_confirmation_bodies", {}) { confirmation_bodies_response }
    confirmation_bodies = @proxy.all

    assert_kind_of Array, confirmation_bodies
    assert confirmation_bodies.all? { |body| body.instance_of?(GetResponse::ConfirmationBody) }
  end


  def test_all_with_conditions
    parsed_conditions = {:language_code => {"EQUALS" => "en"}}
    mock(@connection).send_request("get_confirmation_bodies", parsed_conditions) { confirmation_bodies_response }
    confirmation_bodies = @proxy.all(:language_code => {:equals => "en"})

    assert_kind_of Array, confirmation_bodies
    assert confirmation_bodies.all? { |body| body.instance_of?(GetResponse::ConfirmationBody) }
  end


  def test_find_confirmation_body_with_good_id
    mock(@connection).send_request("get_confirmation_body", {"confirmation_body" => "1001"}) do
      confirmation_body_response
    end
    body = @proxy.find("1001")

    assert_kind_of GetResponse::ConfirmationBody, body
    assert_equal "1001", body.id
  end


  def test_find_confirmation_body_with_bad_id
    mock(@connection).send_request("get_confirmation_body", {"confirmation_body" => "bad_id"}) do
      {"result"=>{}, "error"=>nil}
    end

    exception = assert_raise(GetResponse::GetResponseError) { @proxy.find("bad_id") }
    assert_equal "Confirmation body with id 'bad_id' not found.", exception.message
  end


  protected


  def confirmation_bodies_response
    {
      "result" => {
        "1001" => {
          "plain" => "Please click to confirm ...",
          "html" => "<p>Please click to confirm ...",
          "language_code" => "en"
        },
        "1002" => {
          "plain" => "Prosze kliknij aby potwierdzić ...",
          "html" => "<p>Proszę kliknij aby potwierdzić ...",
          "language_code" => "pl"
        }
      },
      "error" => nil
    }
  end
end