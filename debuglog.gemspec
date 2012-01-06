# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "debuglog/version"

Gem::Specification.new do |s|
  s.name        = "debuglog"
  s.version     = DebugLog::VERSION
  s.authors     = ["Gavin Sinclair"]
  s.email       = ["gsinclair@gmail.com"]
  s.homepage    = "http://gsinclair.github.com/debuglog.html"
  s.summary     = "Zero-conf debug.log file with 'debug', 'trace' and 'time' methods"
  s.description = <<-EOF
    require 'debuglog' and record debugging information (including variable traces
    and timing information) to the file debug.log -- cheap and easy.
  EOF

  s.rubyforge_project = ""
  s.has_rdoc = false

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler"
  s.add_development_dependency "whitestone"

  s.required_ruby_version = '>= 1.8.6'    # Tested.
end
