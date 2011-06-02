module GetResponse

  # Proxy class for message related operations.
  class MessageProxy

    def initialize(connection)
      @connection = connection
    end


    # Get all messages from account.
    # Example:
    #   @message_proxy.all
    #   => [<GetResponse::Message ...>, <GetResponse::Message ...>]
    #
    # returns:: Array of GetResponse::Message
    def all
      response = @connection.send_request("get_messages")

      response["result"].inject([]) do |messages, resp|
        messages << Message.new(resp[1].merge("id" => resp[0]), @connection)
      end
    end

  end

end
