module GetResponse

  # Proxy class from all from fields operations.
  class FromFieldsProxy

    def initialize(connection)
      @connection = connection
    end


    # Fetch all from fields connected with account
    #
    # returns:: [FromFields]
    def all
      from_fields_attrs = @connection.send_request("get_account_from_fields")["result"]
      from_fields_attrs.map do |id, attrs|
        FromField.new(attrs.merge("id" => id))
      end
    end


    # Create new from field connection with account. Method returns new instance of <tt>FromField</tt>
    # if new from field was saved or raise <tt>GetResponseError</tt> if not.
    #
    # returns:: FromField
    def create(attributes)
      add_result = @connection.send_request("add_account_from_field", attributes)["result"]
      FromField.new(attributes.merge("id" => add_result["FROM_FIELD_ID"]))
    end

  end

end