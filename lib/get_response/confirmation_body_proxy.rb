module GetResponse

  # Proxy class for confirmation body operations.
  class ConfirmationBodyProxy

    include Conditions


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
      conditions = parse_conditions(conditions)

      response = @connection.send_request("get_confirmation_bodies", conditions)["result"]
      response.inject([]) do |bodies, resp|
        bodies << ConfirmationBody.new(resp[1].merge("id" => resp[0]))
      end
    end

  end

end