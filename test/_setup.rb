require 'debuglog'
require 'ruby-debug'

Attest.custom :debuglog, {
  :description => "Last line of log file",
  :parameters  => [ [:regex, Regexp], [:filename, String] ],
  :run => proc {
    file_data = File.read(filename)
    test('file exists') { N! file_data }
    last_line = file_data.split("\n").last
    test('match') { Mt last_line, regex }
  }
}
