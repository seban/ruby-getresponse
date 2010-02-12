class SymbolOperator
  attr_reader :field, :operator

  def initialize(field, operator, options={})
    @field, @operator = field, operator
  end unless method_defined?(:initialize)


  def evaluate(value)
    { field.to_s => { gr_operator => value } }
  end


  def gr_operator
    operators = {
      "eq" => "EQUALS"
    }
    operators[@operator]
  end
end


class Symbol
  %w(eq neq).each do |operator|
    define_method(operator) do
      SymbolOperator.new(self, operator)
    end unless method_defined?(operator)
  end
end
