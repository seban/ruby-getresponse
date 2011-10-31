module GetResponse

  # Proxy class for confirmation subjects operations.
  class ConfirmationSubjectProxy

    include Conditions


    def initialize(connection)
      @connection = connection
    end


    # Get list of available subjects for confirmation messages. They can be used in campaign settings.
    # Example:
    #
    #   @proxy.all
    #   @proxy.all(:language_code => {:equals => "pl"})
    #
    # @param conditions [Hash] conditions passed to query, empty by default
    # @return [Array] collection of <tt>ConfirmationSubject</tt> objects returned by API query
    def all(conditions = {})
      conditions = parse_conditions(conditions)
      response = @connection.send_request("get_confirmation_subjects", conditions)["result"]
      response.inject([]) do |bodies, resp|
        bodies << ConfirmationSubject.new(resp[1].merge("id" => resp[0]))
      end
    end

  end

end