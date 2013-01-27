# -*- encoding: utf-8 -*-
require File.expand_path('../lib/leafy_cui_client/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["hassaku"]
  gem.email         = ["hassaku.apps@gmail.com"]
  gem.description   = %q{Enable you to use leafy by CUI.}
  gem.summary       = %q{CUI client for Leafy}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "leafy_cui_client"
  gem.require_paths = ["lib"]
  gem.version       = LeafyCuiClient::VERSION
end
