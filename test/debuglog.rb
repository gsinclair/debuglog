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

D "Debuglog" do
  D "Debuglog and DebugLog are the same thing" do
    Id Debuglog, DebugLog
  end
  D "Methods are defined in Kernel" do
    kernel_methods = Kernel.instance_methods
    T { kernel_methods.include? :debug }
    T { kernel_methods.include? :trace }
    T { kernel_methods.include? :time }
  end
  D "debug" do
    debug "abc123"
    T :debuglog, /abc123/, "debug.log"
  end
  D "trace" do
    foo = [1,2,3]
    trace :foo, binding
    T :debuglog, /foo == \[1, 2, 3\]/, "debug.log"
  end
  D "time" do
    time('sum to 10') { 1+2+3+4+5+6+7+8+9+10 }
    T :debuglog, /sum to 10: .* sec/, "debug.log"
  end
end
