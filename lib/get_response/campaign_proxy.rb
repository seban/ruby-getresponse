module GetResponse

  # Proxy class for campaign operations.
  class CampaignProxy

    def initialize(connection)
      @connection = connection
    end


    # Get all campaigns from account.
    #
    # returns:: Array of GetResponse::Campaign
    def all
      response = @connection.send_request("get_campaigns", {})["result"]
      response.inject([]) do |campaigns, resp|
        campaigns << Campaign.new(resp[1].merge("id" => resp[0]), @connection)
      end
    end


    # Create new campaign from passed attributes
    #
    # @param attrs [Hash]
    # @return [GetResponse::Campaign]
    def create(attrs)
      new_campaign = Campaign.new(attrs, @connection)
      new_campaign.description = attrs["description"]
      new_campaign.language_code = attrs["language_code"]
      new_campaign.reply_to_field = attrs["reply_to_field"]
      new_campaign.from_field = attrs["from_field"]
      new_campaign.confirmation_body = attrs["confirmation_body"]
      new_campaign.confirmation_subject = attrs["confirmation_subject"]
      new_campaign.save
      new_campaign
    end

  end

end