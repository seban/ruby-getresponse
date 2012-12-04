module GetResponse

  class Segment

    attr_reader :id, :name, :created_on


    def initialize(params)
      @id         = params['id']
      @name       = params['name']
      @created_on = params['created_on']
    end

  end

end
