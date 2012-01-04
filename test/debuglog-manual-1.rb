D "DebugLog manual configuration (successful)" do

  D.< { DebugLog.send :wipe_slate_clean_for_testing }

  D ":debug => :my_debug, :filename => 'xyz.txt'" do
    Debuglog.configure(:debug => :my_debug, :filename => 'xyz.txt')
    D "my_debug method works" do
      my_debug "abc123"
      T :debuglog, /abc123/, "xyz.txt"
    end
    D "debug, trace and time methods are not defined" do
      E(NoMethodError) { debug "abc123" }
      E(NoMethodError) { trace :x, binding }
      E(NoMethodError) { time('task') { :foo } }
    end
  end

  D ":trace => :my_trace, :time => :my_time" do
    Debuglog.configure(:trace => :my_trace, :time => :my_time)
    D "my_trace and my_time methods work" do
      foo = :chorus
      my_trace "foo", binding
      xT :debuglog, /foo == :chorus/, "debug.log"
      my_time('blah') { :dotdotdot }
      T :debuglog, /blah: .* sec/, "debug.log"
    end
    D "debug method not defined" do
      E(NoMethodError) { debug "..." }
    end
  end

  D "empty configuration" do
    Debuglog.configure({})
    D "debug, trace and time methods don't work" do
      E(NoMethodError) { debug "abc123" }
      E(NoMethodError) { trace :x, binding }
      E(NoMethodError) { time('task') { :foo } }
    end
  end

end
