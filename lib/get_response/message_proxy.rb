module GetResponse

  # Proxy class for message related operations.
  class MessageProxy

    def initialize(connection)
      @connection = connection
    end


    # Get all messages from account. <tt>Hash</tt> with conditions can be optionally passed as
    # parameter.
    # Example:
    #   @message_proxy.all
    #   => [<GetResponse::Message ...>, <GetResponse::Message ...>]
    #   @message_proxy.all(:campaigns => ["my_campaign_id"]
    #   => [<GetResponse::Message ...>, <GetResponse::Message ...>]
    #
    # conditions::  Hash, empty by default
    # returns:: Array of GetResponse::Message
    def all(conditions = {})
      response = @connection.send_request("get_messages", conditions)

      response["result"].inject([]) do |messages, resp|
        messages << Message.new(resp[1].merge("id" => resp[0]), @connection)
      end
    end

  end

end
