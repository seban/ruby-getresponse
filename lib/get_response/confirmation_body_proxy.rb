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


    # Get single confirmation body based on its <tt>id</tt>. Method can raise
    #<tt>GetResposne::GetResponseError</tt> exception if no confirmation body is found.
    #
    # @param body_id [String]
    # @return [GetResponse::ConfirmationBody]
    def find(body_id)
      params = {"confirmation_body" => body_id}
      resp = @connection.send_request("get_confirmation_body", params)["result"]
      raise GetResponseError.new "Confirmation body with id '#{body_id}' not found." if resp.empty?
      body_attrs = resp.values[0].merge("id" => resp.keys.first)
      ConfirmationBody.new body_attrs
    end

  end

end