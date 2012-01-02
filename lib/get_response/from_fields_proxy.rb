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


    # Get single from field. Method can raise <tt>GetResponse::GetResponseError</tt> exception when
    # form field with passed <tt>from_field_id</tt> is not found.
    #
    # @param from_field_id [String]
    # @return [FormField]
    def find(from_field_id)
      params = {"account_from_field" => from_field_id}
      resp = @connection.send_request("get_account_from_field", params)["result"]
      raise GetResponseError.new "Form field with id '#{from_field_id}' not found." if resp.empty?
      from_field_attrs = resp.values[0].merge("id" => resp.keys.first)
      FromField.new(from_field_attrs)
    end

  end

end