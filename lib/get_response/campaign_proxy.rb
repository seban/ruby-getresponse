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
      response = @connection.send_request('get_campaigns', {})['result']
      response.inject([]) do |campaigns, (key,value)|
        campaigns << Campaign.new(value.merge('id' => key), @connection)
      end
    end


    # Get campaign by id
    #
    # returns:: instance of Getresponse::Campaign
    #
    def by_id(campaign_id)
      response = @connection.send_request('get_campaign',
                                          { 'campaign' => campaign_id }
                                         ) 

      if response['result'].empty?
        raise GRNotFound.new("Campaign not found: #{campaign_id}")
      else
        attrs = response['result'].values.first.merge('id' => response['result'].keys.pop)
        Campaign.new(attrs, @connection)
      end
    end

    # Get campaign by name
    # getresponse API states:
    # "There can be only one campaign of a given name" 
    #
    # returns:: instance of Getresponse::Campaign
    #
    def by_name(campaign_name)
      response = @connection.send_request('get_campaigns', 
                                          { 'name' =>  { 'EQUALS' => campaign_name } }
                                         )
      if response['result'].empty?
        raise GRNotFound.new("Campaign not found: #{campaign_name}")
      else
        attrs = response['result'].values.first.merge('id' => response['result'].keys.pop)
        Campaign.new(attrs, @connection)
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
