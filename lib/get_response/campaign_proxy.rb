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
        campaigns << Campaign.new(resp[1].merge("id" => resp[0]))
      end
    end

  end

end