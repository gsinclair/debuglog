D "Debuglog auto configuration" do

  D.<< {
    DebugLog.send :wipe_slate_clean_for_testing
    DebugLog.autoconfigure
  }

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
    debug -189
    T :debuglog, /-189/, "debug.log"
    D "multiple arguments" do
      x = 5
      debug "The value of x is ", x, "!"
      T :debuglog, /The value of x is 5!/, "debug.log"
    end
    D "multi-line text" do
      text = "I must go down to the seas again\nTo the lonely sea and the sky\nAnd all I want is a tall ship\nAnd a star to steer her by\n     -- John Masefield"
      debug text
      log_text_lines = File.read("debug.log").split("\n").last(5)
      # The text in the log file should be indented to look good.
      Mt log_text_lines.shift, /\[\d\d\.\d\] I must go down to the seas again$/
      Eq log_text_lines.shift, "       To the lonely sea and the sky"
      Eq log_text_lines.shift, "       And all I want is a tall ship"
      Eq log_text_lines.shift, "       And a star to steer her by"
      Eq log_text_lines.shift, "            -- John Masefield"
    end
  end

  D "trace" do
    D "array" do
      foo = [1,2,3]
      trace :foo, binding
      T :debuglog, /foo == \[1, 2, 3\]/, "debug.log"
    end
    D "string" do
      str = "blah"
      trace :str, binding
      T :debuglog, /str == "blah"/, "debug.log"
    end
    D "truncate output" do
      D "output that is too long" do
        str = "x" * 100
        trace :str, binding, 30
        T :debuglog, /str == "xxxxxxxxxxxxxxxxxxxxxxxxxxxxx\.\.\./, "debug.log"
      end
      D "output that is not too long" do
        str = "x" * 10
        trace :str, binding, 30
        T :debuglog, /str == "xxxxxxxxxx"$/, "debug.log"
      end
    end
    D "different formats" do
      # not really interested in this feature at the moment
    end
  end

  D "time" do
    time('sum to 10') { 1+2+3+4+5+6+7+8+9+10 }
    T :debuglog, /sum to 10: .* sec/, "debug.log"
    D "return value of block is accessible" do
      sum = time('sum') { 1 + 1 }
      Eq sum, 2
    end
  end

end
