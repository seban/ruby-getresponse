module GetResponse

  # Operators that may be used in queries to GetResponse API service
  OPERATORS = {
    "is_eq"       => "EQUALS",
    "is_not_eq"   => "NOT_EQUALS",
    "contain"     => "CONTAINS",
    "not_contain" => "NOT_CONTAINS",
    "match"       => "MATCHES"
  }
end
