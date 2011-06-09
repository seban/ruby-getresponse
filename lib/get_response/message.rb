module GetResponse

  # Class representa a message in GetResponse
  class Message
    attr_reader :id, :type, :subject, :flags, :created_on

    def initialize(params, connection)
      @id = params["id"]
      @type = params["type"]
      @subject = params["subject"]
      @day_of_cycle = params["day_of_cycle"]
      @flags = params["flags"] || []
      @created_on = params["created_on"]
      @connection = connection
    end


    # Content of message. Every message has two kinds of content: plain and html. Method returns
    # <tt>Hash</tt> instance with keys <tt>"plain"</tt> and <tt>"html"</tt>.
    #
    # returns:: Hash
    def contents
      resp = @connection.send_request("get_message_contents", :message => @id)
      resp["result"]
    end


    # Stats of message. Method returns <tt>Hash</tt> instance where hey is a date and value is
    # set of data.
    #
    # returns:: Hash
    def stats
      resp = @connection.send_request("get_message_stats", :message => @id)
      resp["result"]
    end
  end
end
