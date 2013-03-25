module GetResponse

  # GetResponse email campaign
  class Campaign
    attr_reader :id, :name, :from_name, :from_email, :reply_to_email, :created_on
    attr_reader :from_field, :reply_to_field, :confirmation_body, :confirmation_subject
    attr_accessor :description, :language_code


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


    # Get contacts deleted from this campaign
    #
    # @return [Array]
    def deleted_contacts
      @contact_proxy = ContactProxy.new(@connection)
      @contact_proxy.deleted(:campaigns => [@id])
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


    # Get contacts subscription stats for this campaign aggregated by date, campaign and contact’s origin.
    # Example:
    #
    #   # get stats for camapaign, any time period
    #   @campaign.subscription_statistics
    #
    #   # get stats for specified date
    #   @campaign.subscription_statistics(:created_on => {:at => Date.today})
    #   @campaign.subscription_statistics(:created_on => {:from => "2011-01-01", :to => "2011-12-30"})
    #
    # @param conditions [Hash] conditions for statistics query, empty by default
    # @return [Hash] collection of aggregated statistics
    def subscription_statistics(conditions = {})
      @contact_proxy = ContactProxy.new(@connection)
      @contact_proxy.statistics(conditions.merge(:campaigns => [@id]))
    end


    # Set object (without sending API 'set' request) level from field. If value is not
    # <tt>GetResponse::FromField</tt> method will try to fetch from field attributes through API.
    #
    # @param value [FromField]
    # @return [GetResponse::FromField]
    def from_field=(value)
      if value.instance_of? GetResponse::FromField
        @from_field = value
      else
        @from_field = FromFieldsProxy.new(@connection).find(value)
      end
    end


    # Set object (without sending API 'set' request) level reply to field. If value is not
    # <tt>GetResponse::FromField</tt> method will try to fetch from field attributes through API.
    #
    # @param value [FromField]
    # @return [GetResponse::FromField]
    def reply_to_field=(value)
      if value.instance_of? GetResponse::FromField
        @reply_to_field = value
      else
        @reply_to_field = FromFieldsProxy.new(@connection).find(value)
      end
    end


    # Set object (without sending API 'set' request) level confirmation body. If value is not
    # <tt>GetResponse::ConfirmationBody</tt> instance method will try to fetch attributes through API.
    #
    # @param value [GetResponse::ConfirmationBody]
    # @return [GetResponse::ConfirmationBody]
    def confirmation_body=(value)
      if value.instance_of? GetResponse::ConfirmationBody
        @confirmation_body = value
      else
        @confirmation_body = ConfirmationBodyProxy.new(@connection).find(value)
      end
    end


    # Set object (without sending API 'set' request) level confirmation subject. If value is not
    # <tt>GetResponse::ConfirmationSubject</tt> instance method will try to fetch attributes through API.
    #
    # @param value [GetResponse::ConfirmationSubject]
    # @return [GetResponse::ConfirmationSubject]
    def confirmation_subject=(value)
      if value.instance_of? GetResponse::ConfirmationSubject
        @confirmation_subject = value
      else
        @confirmation_subject = ConfirmationSubjectProxy.new(@connection).find(value)
      end
    end


    # Saves new campaign.
    #
    # @return [GetResponse::Campaign]
    def save
      attributes = {
        "name" => name,
        "description" => description,
        "language_code" => language_code,
        "from_field" => from_field.id,
        "reply_to_field" => reply_to_field.id,
        "confirmation_subject" => confirmation_subject.id,
        "confirmation_body" => confirmation_body.id
      }
      save_result = @connection.send_request("add_campaign", attributes)["result"]
      @id = save_result["CAMPAIGN_ID"]
      self
    end


    # Get the entire blacklisted emails list for this campaign.
    #
    # @return [GetResponse::Blacklist]
    def blacklist
      params = {"campaign" => @id}
      entries = @connection.send_request("get_campaign_blacklist", params)["result"].values
      GetResponse::Blacklist.new(entries, @connection, self)
    end


    def create_follow_up(follow_up_attributes)
      follow_up_attributes.merge!("campaign" => @id)
      GetResponse::FollowUp.new(follow_up_attributes, @connection).tap do |follow_up|
        follow_up.save
      end
    end

  end

end
