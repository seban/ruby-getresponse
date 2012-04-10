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


    # Get single confirmation subject based on its <tt>id</tt>. Method can raise
    #<tt>GetResposne::GetResponseError</tt> exception if no confirmation subject is found.
    #
    # @param subject_id [String]
    # @return [GetResponse::ConfirmationSubject]
    def find(subject_id)
      params = {"confirmation_subject" => subject_id}
      resp = @connection.send_request("get_confirmation_subject", params)["result"]
      raise GetResponseError.new "Confirmation subject with id '#{subject_id}' not found." if resp.empty?
      subject_attrs = resp[subject_id.to_s].merge("id" => subject_id.to_s)
      ConfirmationSubject.new subject_attrs
    end

  end

end