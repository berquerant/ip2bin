
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ip2bin/version"

Gem::Specification.new do |spec|
  spec.name          = "ip2bin"
  spec.version       = Ip2bin::VERSION
  spec.authors       = ["berquerant"]

  spec.summary       = %q{ipv4 utils}
  spec.description   = %q{ipv4 utils}
  spec.homepage      = "https://github.com/berquerant/ip2bin"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 1.2"
  spec.add_development_dependency "rufo", "~> 0.16.2"
  spec.add_development_dependency "steep", "~> 1.5.3"
  spec.add_development_dependency "rbs", "~> 3.2.0"
  spec.add_development_dependency "typeprof", "~> 0.21.7"
  spec.add_development_dependency "bundler", "~> 2.4.18"
  spec.add_development_dependency "rake", "~> 13.1.0"
  spec.add_development_dependency "rspec", "~> 3.12.0"
end
