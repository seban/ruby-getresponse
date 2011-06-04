module GetResponse

  # GetResponse email campaign
  class Campaign
    attr_reader :id, :name, :from_name, :from_email, :reply_to_email, :created_on


    def initialize(params, connection)
      @id = params["id"]
      @name = params["name"]
      @from_name = params["from_name"]
      @from_email = params["from_email"]
      @reply_to_email = params["reply_to_email"]
      @created_on = params["created_on"]
      @connection = connection
    end


    # Get all contacts assigned to this campaign.
    #
    # returns:: [GetResponse::Contact]
    def contacts
      @contact_proxy = ContactProxy.new(@connection)
      @contact_proxy.all(:campaigns => [@id])
    end


    # Get domain assigned to this campaign.
    #
    # returns:: GetResponse::Domain
    def domain
      params = {"campaign" => self.id}
      domain = @connection.send_request("get_campaign_domain", params)["result"].map do |id, attrs|
        Domain.new(attrs.merge("id" => id))
      end
      domain.first
    end


    # Set domain for this campaign.
    #
    # new_domain:: GetResponse::Domain
    # returns:: GetResponse::Domain
    def domain=(new_domain)
      params = { "domain" => new_domain.id, "campaign" => self.id }

      # there will be an exception if bad ids sent
      @connection.send_request("set_campaign_domain", params)
      new_domain
    end


    # Get messages assigned to this campaign.
    #
    # returns:: [GetResponse::Message]
    def messages
      @message_proxy = MessageProxy.new @connection
      @message_proxy.all(:campaigns => [@id])
    end

  end

end
