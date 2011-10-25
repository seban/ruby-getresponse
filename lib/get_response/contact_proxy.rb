module GetResponse

  # Proxy class for contact related operations.
  class ContactProxy

    def initialize(connection)
      @connection = connection
    end


    # Get all contacts from account. Conditions could be passed to method. Returned contacts
    # will be limited to passed conditions eg. to certain campaign. For more examples of conditions
    # visit: http://dev.getresponse.com/api-doc/#get_contacts
    # Example:
    #   @contact_proxy.all(:campaigns => ["my_campaign_id"])
    #
    # returns:: Array of GetResponse::Contact
    def all(conditions = {})
      response = @connection.send_request("get_contacts", conditions)

      response["result"].inject([]) do |contacts, resp|
        contacts << Contact.new(resp[1].merge("id" => resp[0]), @connection)
      end
    end


    # Create new contact. Method can raise <tt>GetResponseError</tt>.
    #
    # returns:: GetResponse::Contact
    def create(attrs)
      contact = GetResponse::Contact.new(attrs, @connection)
      contact.save
      contact
    end


    # Get contacts subscription stats aggregated by date, campaign and contact’s origin.
    # Example:
    #
    #   # get stats for any camapign, any time period
    #   @contact_proxy.statistics
    #
    #   # get stats for selected camapigns, any time period
    #   @contact_proxy.statistics(:campaigns => ["cmp1", "cmp2"])
    #
    #   # get stats for specified date
    #   @contact_proxy.statistics(:created_on => {:at => Date.today})
    #   @contact_proxy.statistics(:created_on => {:from => "2011-01-01", :to => "2011-12-30"})
    #
    # @param conditions [Hash] conditions for statistics query, empty by default
    # @return [Hash] collection of aggregated statistics
    def statistics(conditions = {})
      if conditions[:created_on]
        conditions[:created_on] = parse_date_conditions(conditions[:created_on])
      end

      @connection.send_request("get_contacts_subscription_stats", conditions)["result"]
    end


    protected


    def parse_date_conditions(conditions)
      parsed_conditions = {}
      conditions.each_pair do |key, value|
        if value.respond_to?(:strftime)
          parsed_conditions[key.to_s.upcase] = value.strftime("%Y-%m-%d")
        else
          parsed_conditions[key.to_s.upcase] = value
        end
      end

      parsed_conditions
    end

  end

end