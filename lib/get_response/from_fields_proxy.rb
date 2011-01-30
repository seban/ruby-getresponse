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

  end

end