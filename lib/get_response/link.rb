module GetResponse

  # Class represents link embedded in GetResponse message.
  class Link
    attr_reader :message, :name, :url, :clicks

    def initialize(attrs, connection)
      @message = attrs["message"]
      @name = attrs["name"]
      @url = attrs["url"]
      @clicks = attrs["clicks"]
      @connection = connection
    end

  end

end

