module GetResponse

  # Class representa a message in GetResponse
  class Message
    attr_reader :id, :type, :subject, :day_of_cycle, :flags, :created_on

    def initialize(params)
      @id = params["id"]
      @type = params["type"]
      @subject = params["subject"]
      @day_of_cycle = params["day_of_cycle"]
      @flags = params["flags"] || []
      @created_on = params["created_on"]
    end
  end
end
