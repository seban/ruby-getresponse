require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class GetResponse::ConfirmationSubjectProxyTest < Test::Unit::TestCase

  include GetResponse::Conditions


  def test_parse_test_conditions
    conditions = parse_text_conditions("CONTAINS", "%text%")

    assert_kind_of Hash, conditions
    assert_equal 1, conditions.size
    assert_equal "%text%", conditions["CONTAINS"]
  end


  def test_parse_date_conditions_with_string_value
    conditions = parse_date_conditions("FROM", "2011-10-01")

    assert_kind_of Hash, conditions
    assert_equal 1, conditions.size
    assert_equal "2011-10-01", conditions["FROM"]
  end


  def test_parse_date_conditions_with_date_value
    conditions = parse_date_conditions("TO", Time.now)

    assert_kind_of Hash, conditions
    assert_equal 1, conditions.size
    assert_equal Time.now.strftime("%Y-%m-%d"), conditions["TO"]
  end


  def test_parse_condition
    condition = parse_condition("FROM", Time.now)

    assert_kind_of Hash, condition
    assert_equal 1, condition.size
    assert_equal Time.now.strftime("%Y-%m-%d"), condition["FROM"]
  end


  def test_parse_condition_with_some_nil_value
    condition = parse_condition("EQUALS", nil)

    assert_kind_of Hash, condition
    assert_equal true, condition.empty?
  end


  def test_parse_condition_with_some_bad_operator
    exception = assert_raise(GetResponse::GetResponseError) { parse_condition("BAD_OPERATOR", "value") }
    assert_equal "Bad operator: BAD_OPERATOR", exception.message
  end


  def test_parse_conditions
    conditions = parse_conditions(:created_on => {:from => "2011-01-01", :to => Time.now},
      :count => {'less' => 45, :equals => nil})

    assert_kind_of Hash, conditions
    assert_equal true, conditions[:created_on].keys.all? { |val| val =~ /[A-Z]+/ }
    assert_nil conditions[:count]["EQUALS"]
    assert_equal 1, conditions[:count].size
  end

end