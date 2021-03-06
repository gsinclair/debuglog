require 'debuglog'

Whitestone.custom :debuglog, {
  :description => "Last line of log file",
  :parameters  => [ [:regex, Regexp], [:filename, String] ],
  :run => proc {
    file_data = File.read(filename)
    test('file exists') { N! file_data }
    test('file has data in it') { file_data.size > 0 }
    last_line = file_data.split("\n").last
    test('match') { Mt last_line, regex }
  }
}
