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
end
