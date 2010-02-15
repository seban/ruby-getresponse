module GetResponse

  # GetResponse email campaign
  class Campaign
    attr_reader :id, :name, :from_name, :from_email, :reply_to_email, :created_on


    def initialize(params)
      @id = params["id"]
      @name = params["name"]
      @from_name = params["from_name"]
      @from_email = params["from_email"]
      @reply_to_email = params["reply_to_email"]
      @created_on = params["created_on"]
    end
  end

end
