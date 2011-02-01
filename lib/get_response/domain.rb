module GetResponse

  # Domain connected with account or campaign in GetResponse
  class Domain

    attr_reader :id, :domain, :created_on

    def initialize(attributes)
      @id         = attributes["id"]
      @domain     = attributes["domain"]
      @created_on = attributes["created_on"]
    end

  end

end
