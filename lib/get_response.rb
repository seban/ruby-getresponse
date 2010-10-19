require "rubygems"
require "bundler"
Bundler.setup
Bundler.require(:default)

module GetResponse

  # Operators that may be used in queries to GetResponse API service
  OPERATORS = {
    "is_eq"       => "EQUALS",
    "is_not_eq"   => "NOT_EQUALS",
    "contain"     => "CONTAINS",
    "not_contain" => "NOT_CONTAINS",
    "match"       => "MATCHES"
  }

end


class SymbolOperator
  attr_reader :field, :operator

  def initialize(field, operator)
    @field, @operator = field, operator
  end unless method_defined?(:initialize)


  def evaluate(value)
    { field.to_s => { gr_operator => value } }
  end


  def gr_operator
    GetResponse::OPERATORS[@operator]
  end
end


class Symbol
  GetResponse::OPERATORS.keys.each do |operator|
    define_method(operator) do
      SymbolOperator.new(self, operator)
    end unless method_defined?(operator)
  end
end



Dir.glob(File.join('**/*.rb')).each do |fname|
  GetResponse.autoload File.basename(fname, '.rb').gsub(/(?:^|_)(.)/) { $1.upcase }, fname
end