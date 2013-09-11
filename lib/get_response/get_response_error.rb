# Errors for GetResponse. For example: bad requests, ...
module GetResponse
  class GetResponseError < StandardError
  end

  # raised in case campaigns.by_name(name) or campaigns.by_id(id) returns 
  # empty result
  #
  class GRNotFound < StandardError
  end
end
