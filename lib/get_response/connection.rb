require 'net/http'

module GetResponse

  # Simple class that simulates connection to service
  class Connection
    API_URI = "http://api2.getresponse.com"

    attr_reader :api_key

    def initialize(api_key)
      @api_key = api_key
    end


    # Test connection with API.
    #
    # returns:: Boolean
    def ping
      result = self.send_request("ping")
      return result["errors"].nil?
    end


    # Get basic info about your account.
    #
    # returns:: GetResponse::Account
    def account
      resp = self.send_request("get_account_info")
      GetResponse::Account.new(resp["result"], self)
    end


    # Method returns proxy to execute all campaign related operations.
    #
    # returns:: GetResponse::CampaignProxy
    def campaigns
      @campaign_proxy ||= GetResponse::CampaignProxy.new(self)
    end


    # Method returns proxy to execute all contact related operations.
    #
    # returns:: GetResponse::ContactProxy
    def contacts
      @contact_proxy ||= GetResponse::ContactProxy.new(self)
    end

    # Method returns proxy to execute all segment related operations.
    #
    # returns:: GetResponse::SegmentProxy
    def segments
      @segment_proxy ||= GetResponse::SegmentProxy.new(self)
    end

    # Method returns proxy to execute all message related operations.
    #
    # returns:: GetResponse::MessageProxy
    def messages
      @message_proxy ||= GetResponse::MessageProxy.new(self)
    end


    # Method returnx proxy to execute all confirmation body related operations.
    #
    # @return [ConfirmationBodyProxy]
    def confirmation_bodies
      @confirmation_body_proxy ||= GetResponse::ConfirmationBodyProxy.new(self)
    end


    # Method returnx proxy to execute all confirmation subject related operations.
    #
    # @return [ConfirmationSubjectProxy]
    def confirmation_subjects
      @confirmation_subject_proxy ||= GetResponse::ConfirmationSubjectProxy.new(self)
    end


    # Send request to JSON-RPC service.
    #
    # method::  String
    #
    # params::  Hash
    def send_request(method, params = { })
      request_params = {
          :method => method,
          :params => [@api_key, params]
      }.to_json

      uri = URI.parse(API_URI)
      resp = Net::HTTP.start(uri.host, uri.port) do |conn|
        conn.post("/", request_params)
      end
      raise GetResponseError.new("API key verification failed") if resp.code.to_i == 403
      response = JSON.parse(resp.body)
      if response["error"]
        raise GetResponse::GetResponseError.new(response["error"])
      end
      response
    end


    # Method return proxy to execute all links related operations.
    #
    # @return [LinksProxy]
    def links
      @links_proxy ||= LinksProxy.new(self)
    end


    protected


    def build_conditions(conditions)
      conditions.inject({ }) do |hash, cond|
        if cond[0].respond_to?(:evaluate)
          hash.merge!(cond[0].evaluate(cond[1]))
        else
          if cond[1].instance_of?(Hash)
            hash.merge!(cond[0] => build_conditions(cond[1]))
          else
            hash.merge!(cond[0] => cond[1])
          end
        end
        hash
      end
    end

  end

end
