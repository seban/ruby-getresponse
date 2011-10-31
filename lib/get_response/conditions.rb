module GetResponse

  # GetResponse API Operators (http://dev.getresponse.com/api-doc/#operators) parsing module.
  module Conditions

    protected


    # Parse whole set of conditions. Method can raise <tt>GetResponseError</tt> exception if any of
    # passed condition opertors is not on supported operator list.
    # Example:
    #
    #   parse_conditions(:created_on => {:from => "2011-01-01", :to => Time.now}, :count => {'less' => 45, :equals => nil})
    #   => {:created_on=>{"FROM"=>"2011-01-01", "TO"=>"2011-10-31"}, :count=>{"LESS"=>45}}
    #
    # conditions::  Hash, empty by default
    # returns:: Hash
    def parse_conditions(conditions = {})
      parsed_conditions = {}
      conditions.each_pair do |field, conds|
        # if conds doesn't look like conditions hash
        unless conds.respond_to?(:each_pair)
          parsed_conditions[field] = conds
          next
        end
        conds.each_pair do |operator, value|
          parsed_conditions[field] ||= {}
          operator = operator.to_s.upcase
          parsed_conditions[field].merge! parse_condition(operator, value)
        end
      end

      parsed_conditions
    end


    # Parse condition with operator and its value. Method return <tt>Hash</tt> instance with
    # condition for operator. If value is <tt>nil</tt> empty <tt>Hash</tt> will be returned.
    # If  operator is not on supported operator list <tt>GetResponseError</tt> will be raised.
    # Example:
    #
    #   parse_condition(:from, 2.days.ago)
    #   => {"FROM" => "2011-10-28"}
    #   parse_condition("TO", nil)
    #   => {}
    #
    # operator:: Symbol, String
    # value:: String, Fixnum, Date, Time
    # returns:: Hash
    def parse_condition(operator, value)
      parsed = case operator
        when "EQUALS", "NOT_EQUALS", "CONTAINS", "NOT_CONTAINS", "MATCHES"
          parse_text_conditions(operator, value)
        when "LESS", "LESS_OR_EQUALS", "EQUALS", "GREATER_OR_EQUALS", "GREATER"
          parse_text_conditions(operator, value)
        when "FROM", "TO", "AT"
          parse_date_conditions(operator, value)
        else
          raise GetResponse::GetResponseError.new("Bad operator: #{operator}")
      end

      parsed.delete_if { |k, v| v.nil? }
    end


    # Parse datetime operators.
    # Example:
    #
    #   parse_date_conditions(:from => "2011-10-01")
    #   => {"FROM" => "2011-10-01"}
    #   parse_date_conditions(:to => 2.days.ago)
    #   => {"TO" => "2011-10-28"}
    #
    # operator::  String
    # value:: String, Date, Time
    # returns:: Hash
    def parse_date_conditions(operator, value)
      if value.respond_to?(:strftime)
        {operator => value.strftime("%Y-%m-%d")}
      else
        {operator => value}
      end
    end


    # Parse text operators.
    #
    # operator::  String
    # value:: String
    # returns:: Hash
    def parse_text_conditions(operator, value)
      {operator => value}
    end

  end

end