require File.expand_path(File.join(File.dirname(__FILE__), '../test_helper'))

class DomainTest < Test::Unit::TestCase

  def test_instance
    @domain = GetResponse::Domain.new("id" => "234", "domain" => "newsletter.company.com",
      "created_on" => "2011-01-20 00:00:00")

    assert @domain.respond_to?(:id)
    assert @domain.respond_to?(:domain)
    assert @domain.respond_to?(:created_on)
  end

end