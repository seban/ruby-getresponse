require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class GetResponse::NewsletterTest < Test::Unit::TestCase

  def setup
    @connection = GetResponse::Connection.new("API_KEY")
    @newsletter = new_newsletter
  end


  def test_destroy
    response = {"result" => {"deleted" => 1}, "error" => nil}
    mock(@connection).send_request("delete_newsletter", {:message => @newsletter.id}) { response }
    result = @newsletter.destroy

    assert_equal true, result
  end


  protected


  def new_newsletter(options = {})
    GetResponse::Newsletter.new({
      "id" => "N3i",
      "flags" => ["clicktrack"],
      "campaign" => "N3i",
      "subject" => "My offer newsletter",
      "created_on" => "2010-10-24 03:22:08",
      "type" => "newsletter",
      "send_on" => "2010-10-24 03:22:08"
     }.merge(options), @connection)
  end

end