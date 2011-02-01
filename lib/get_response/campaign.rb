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

  end

end
