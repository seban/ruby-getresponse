module GetResponse

  # Proxy class for contact related operations.
  class ContactProxy

    def initialize(connection)
      @connection = connection
    end


    # Get all contacts from account.
    #
    # returns:: Array of GetResponse::Contact
    def all
      response = @connection.send_request("get_contacts", {})

      response["result"].inject([]) do |contacts, resp|
        contacts << Contact.new(resp[1].merge("id" => resp[0]))
      end
    end

  end

end