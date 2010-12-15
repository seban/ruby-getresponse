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
        contacts << Contact.new(resp[1].merge("id" => resp[0]))
      end
    end

  end

end