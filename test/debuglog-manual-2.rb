D "DebugLog manual configuration (unsuccessful)" do
  D.< { DebugLog.send :wipe_slate_clean_for_testing }

  D "clash with existing :debug method" do
    def Kernel.debug() :foo end
    E(DebugLog::Error) { DebugLog.autoconfigure }
  end

  D "clash with custom methods" do
    def Kernel.my_debug() :foo end
    def Kernel.my_trace() :foo end
    def Kernel.my_time()  :foo end
    E(DebugLog::Error) { DebugLog.configure(:debug => :my_debug) }
    E(DebugLog::Error) { DebugLog.configure(:trace => :my_trace) }
    E(DebugLog::Error) { DebugLog.configure(:time  => :my_time)  }
  end

  D "calling methods without having configured -> error" do
    # At this point DebugLog is not configured.
    E(NameError) { debug }
    E(DebugLog::Error) { DebugLog.call_method(:debug, "...") }
  end

  D "specifying unwritable log file -> error" do
    E(DebugLog::Error) { DebugLog.configure(:filename => '/fodsfw/fgsg/e/debug.log') }
  end
end
