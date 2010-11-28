module GetResponse

  # GetResponse Account.
  class Account
    attr_reader :login, :name, :email, :created_on


    def initialize(params)
      @login = params["login"]
      @name = params["from_name"]
      @email = params["from_email"]
      @created_on = params["created_on"]
    end
  end
end
