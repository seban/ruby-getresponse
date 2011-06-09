require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class GetResponse::FollowUpTest < Test::Unit::TestCase

  def setup
    @connection = GetResponse::Connection.new("API_KEY")
    @follow_up = new_follow_up
  end


  def test_destroy
    response = {"result" => {"deleted" => "1"}, "error" => nil}
    mock(@connection).send_request("delete_follow_up", {:message => @follow_up.id}) { response }
    result = @follow_up.destroy

    assert_equal true, result
  end


  protected


  def new_follow_up(options = {})
    GetResponse::FollowUp.new({
      "id" => "N3i",
      "flags" => ["clicktrack"],
      "campaign" => "N3i",
      "subject" => "My offer newsletter",
      "created_on" => "2010-10-24 03:22:08",
      "type" => "newsletter",
      "send_on" => "2010-10-24 03:22:08",
      "day_of_cycle" => "8"
    }.merge(options), @connection)
  end

end