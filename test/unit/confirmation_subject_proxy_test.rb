require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class GetResponse::ConfirmationSubjectProxyTest < Test::Unit::TestCase

  def setup
    @connection = GetResponse::Connection.new("my_test_api_key")
    @proxy = GetResponse::ConfirmationSubjectProxy.new(@connection)
  end


  def test_all_without_conditions
    mock(@connection).send_request("get_confirmation_subjects", {}) { get_confirmation_subjects_response }
    subjects = @proxy.all

    assert_kind_of Array, subjects
    assert subjects.all? { |subject| subject.instance_of?(GetResponse::ConfirmationSubject) }
  end


  def test_all_with_conditions
    parsed_conditions = {:language_code => {"EQUALS" => "en"}}
    mock(@connection).send_request("get_confirmation_subjects", parsed_conditions) { get_confirmation_subjects_response }
    subjects = @proxy.all(:language_code => {:equals => "en"})

    assert_kind_of Array, subjects
    assert subjects.all? { |subject| subject.instance_of?(GetResponse::ConfirmationSubject) }
  end


  protected


  def get_confirmation_subjects_response
    {
      "result" => {
        "1001" => {
          "content" => "Please confirm subscription",
          "language_code" => "en"
        },
        "1002" => {
          "content" => "Proszę potwierdź subskrypcję",
          "language_code" => "pl"
        }
      },
      "error" => nil
    }
  end

end