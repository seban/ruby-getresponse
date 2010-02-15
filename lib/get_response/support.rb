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
