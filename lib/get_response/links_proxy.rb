module GetResponse

  # Proxy class for all links related actions.
  class LinksProxy
    include Conditions

    def initialize(connection)
      @connection = connection
    end


    # Fetch all links, optionally you can pass a hash with conditions.
    #
    # Example:
    #
    #   @proxy.all("messages" => ["my_message_id", "my_second_message_id"])
    #
    # @return [Array] collection of links
    def all(conditions = {})
      conditions = parse_conditions(conditions)

      @connection.send_request("get_links", conditions)["result"].map do |link_id, link_attrs|
        Link.new(link_attrs.merge("id" => link_id), @connection)
      end
    end

  end

end