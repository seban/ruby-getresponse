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


    # Get messages assigned to this campaign. Optionally conditions <tt>Hash</tt> can be passed, for
    # example to get campaign messages which are newsletters only.
    # Example:
    #   @campaign.messages
    #   @campaign.messages(:type => "newsletter")
    #
    # returns:: [GetResponse::Message]
    def messages(conditions = {})
      conditions[:campaigns]= [@id]
      @message_proxy = MessageProxy.new @connection
      @message_proxy.all(conditions)
    end


    # Get campaign's postal address and and postal design (formatting). Postal address is returned
    # as <tt>Hash</tt> instance.
    #
    # returns:: Hash
    def postal_address
      @connection.send_request("get_campaign_postal_address", "campaign" => @id)["result"]
    end


    # Set postal address and postal design (formatting) in campaign. If something goes wrong
    # exception <tt>GetResponse::GetResponseError</tt>.
    #
    # postal_address_hash:: Hash
    # returns:: Hash
    def postal_address=(postal_address_hash)
      params = {"campaign" => @id}.merge(postal_address_hash)
      result = @connection.send_request("set_campaign_postal_address", params)["result"]
      result if result["updated"].to_i == 1
    end

  end

end
