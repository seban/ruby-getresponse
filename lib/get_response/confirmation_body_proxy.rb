module GetResponse

  # Proxy class for confirmation body operations.
  class ConfirmationBodyProxy

    def initialize(connection)
      @connection = connection
    end


    # Get list of available bodies for confirmation messages. They can be used in campaign settings.
    # Example:
    #
    #   @proxy.all
    #   @proxy.all(:language_code => {:equals => "pl"})
    #
    # @param conditions [Hash] conditions passed to query, empty by default
    # @return [Array] collection of <tt>ConfirmationBody</tt> objects returned by API query
    def all(conditions = {})
      if conditions[:language_code]
        conditions[:language_code] = parse_conditions(conditions[:language_code])
      end

      response = @connection.send_request("get_confirmation_bodies", conditions)["result"]
      response.inject([]) do |bodies, resp|
        bodies << ConfirmationBody.new(resp[1].merge("id" => resp[0]))
      end
    end


    protected


    def parse_conditions(conditions)
      parsed_conditions = {}
      conditions.each_pair do |key, value|
        parsed_conditions[key.to_s.upcase] = value
      end
      parsed_conditions
    end

  end

end