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
    def all(conditions = { })
      response = @connection.send_request("get_messages", conditions)

      response["result"].inject([]) do |messages, resp|
        messages << message_ancestor_object(resp)
        # messages << Message.new(resp[1].merge("id" => resp[0]), @connection)
      end
    end

    def send_newsletter(options)
      response = @connection.send_request('send_newsletter', options)
      Message.new({ 'id' => response['result']['MESSAGE_ID'] }, @connection)
    end


    protected


    def message_ancestor_object(response)
      case response[1]["type"]
        when "newsletter"
          Newsletter.new(response[1].merge("id" => response[0]), @connection)
        when "follow-up"
          FollowUp.new(response[1].merge("id" => response[0]), @connection)
      end
    end

  end

end
