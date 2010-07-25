require 'rake'  # FileList
Gem::Specification.new do |spec|
  spec.name = "debuglog"
  spec.version = "1.0.0"
  spec.summary = "Zero-conf debug.log file with 'debug', 'trace' and 'time' methods"
  spec.description = <<-EOF
    require 'debuglog' and record debugging information (including variable traces
    and timing information) to the file debug.log -- cheap and easy.
  EOF
  spec.email = "gsinclair@gmail.com"
  spec.homepage = "http://gsinclair.github.com/debuglog.html"
  spec.authors = ['Gavin Sinclair']

  spec.files = FileList['lib/**/*.rb', '[A-Z]*', 'test/**/*', 'doc/*'].to_a
  spec.test_files = FileList['test/**/*'].to_a
  spec.has_rdoc = false
end
