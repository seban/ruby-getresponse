module GetResponse

  # Form field connected with account.
  class FromField

    attr_reader :id, :name, :email, :created_on


    def initialize(params)
      @id         = params["id"]
      @name       = params["name"]
      @email      = params["email"]
      @created_on = params["created_on"]
    end

  end

end
