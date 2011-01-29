require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class FromFieldTest < Test::Unit::TestCase

  def test_initialize
    @from_field = GetResponse::FromField.new("name" => "text", "email" => "test@email.cc",
      "created_on" => "2010-12-23 00:00:00", "id" => "234")

    assert @from_field.id
    assert @from_field.name
    assert @from_field.email
    assert @from_field.created_on
  end

end