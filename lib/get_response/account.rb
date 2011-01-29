module GetResponse

  # GetResponse Account.
  class Account
    attr_reader :login, :name, :email, :created_on


    def initialize(params, connection)
      @login = params["login"]
      @name = params["from_name"]
      @email = params["from_email"]
      @created_on = params["created_on"]
      @connection = connection
    end


    def from_fields
      from_fields_attrs = @connection.send_request("get_account_from_fields")["result"]
      from_fields_attrs.map do |id, attrs|
        FromField.new(attrs.merge("id" => id))
      end
    end
  end
end
