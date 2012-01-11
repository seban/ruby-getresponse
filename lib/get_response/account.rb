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
      FromFieldsProxy.new(@connection)
    end


    def domains
      DomainProxy.new(@connection)
    end


    # Get the entire blacklisted emails list for this account.
    #
    # @return [Blacklist]
    def blacklist
      entries = @connection.send_request("get_account_blacklist")["result"].values
      GetResponse::Blacklist.new(entries, @connection, self)
    end

  end
end
