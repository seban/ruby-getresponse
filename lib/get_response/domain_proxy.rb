module GetResponse

  # Proxy class for domain operations.
  class DomainProxy

    def initialize(connection)
      @connection = connection
    end


    # Get all domains connected with account.
    #
    # returns:: [GetResponse::Domain]
    def all
      domains_attrs = @connection.send_request("get_account_domains")["result"]
      domains_attrs.map do |id, attrs|
        GetResponse::Domain.new(attrs.merge("id" => id))
      end
    end

  end

end
