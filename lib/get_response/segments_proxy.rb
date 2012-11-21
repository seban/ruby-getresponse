module GetResponse

  class SegmentsProxy

    def initialize(connection)
      @connection = connection
    end

    # Fetch all segments connected with account
    #
    # returns:: [Segments]
    def all
      segments_attrs = @connection.send_request('get_segments')['result']
      segments_attrs.map do |id, attrs|
        Segment.new(attrs.merge('id' => id))
      end
    end
  end
end