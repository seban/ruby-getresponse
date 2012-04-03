Gem::Specification.new do |s|
  s.name          = "getresponse"
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Sebastian Nowak"]
  s.email         = "sebastian.nowak@implix.com"
  s.homepage      = "http://dev.getresponse.com"
  s.summary       = "Ruby wrapper for GetResponse API"
  s.description   = "With this gem you can manage your subscribers, campaigns, messages"
  s.version       = "0.5"

  s.add_dependency "json", "~> 1.4"
  s.add_dependency "json_pure", "~>1.4"
  s.add_development_dependency "rr", "~>1.0"
  s.required_rubygems_version = ">= 1.3.5"

  s.files         = Dir.glob("lib/**/*") + %w(README.rdoc)
  s.require_path  = "lib"
end
