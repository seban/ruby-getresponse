require 'net/http'

module GetResponse

  # Simple class that simulates connection to service
  class Connection
    API_URI = "http://api2.getresponse.com"

    attr_reader :api_key

    def initialize(api_key)
      @api_key = api_key
    end


    # *DEPRECATED* method, please use <tt>new</tt> instead. This method will be removed in vesion 2.0
    def self.instance(api_key = "")
      warn "[DEPRECATION] 'GetResponse::Connection.instance' method is deprecated. Please use 'new' instead."
      @@instance ||= new(api_key)
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
      GetResponse::Account.new(resp["result"])
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


    # TODO: untested!
    # Get messages in account.
    # Conditions:
    #   * campaigns / get_campaigns (optional) – Search only in given campaigns. Uses OR logic.
    #     If those params are not given search, is performed in all campaigns in the account.
    #     Check IDs in conditions for detailed explanation.
    #   * type (optional) – Use newsletter or follow-up to narrow down search results to specific
    #     message types.
    #   * subject (optional) – Use text operators to narrow down search results to specific message subjects.
    #
    # conditions::  Hash
    #
    # returns:: [Message]
    def get_messages(conditions = {})
      req_cond = build_conditions(conditions)

      response = send_request("get_messages", req_cond)["result"]
      response.inject([]) do |messages, resp|
        messages << Message.new(resp[1].merge("id" => resp[0]))
      end
    end


    # Get single message using <tt>message_id</tt>.
    #
    # message_id::  Integer || String
    #
    # returns:: Message
    def get_message(message_id)
      response = self.send_request("get_message", { "message" => message_id })["result"]
      return nil if response.empty?
      Message.new(response[message_id].merge("id" => message_id))
    end


    # Send request to JSON-RPC service.
    #
    # method::  String
    #
    # params::  Hash
    def send_request(method, params = {})
      request_params = {
        :method => method,
        :params => [@api_key, params]
      }.to_json

      uri = URI.parse(API_URI)
      resp = Net::HTTP.start(uri.host, uri.port) do |conn|
        conn.post("/", request_params)
      end
      response = JSON.parse(resp.body)
      if response["error"]
        raise GetResponse::GetResponseError.new(response["error"])
      end
      response
    end


    protected


    def build_conditions(conditions)
      conditions.inject({}) do |hash, cond|
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
