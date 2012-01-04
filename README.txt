debuglog: zero-conf debug.log file for simple and hassle-free debugging

Synopsis

    Debuglog gives you debug, trace and time  methods that write their output to
    the file ./debug.log.

        require 'debuglog'     # or require 'debuglog/auto'

        debug "Message..."
        trace :x, binding
        time('Task') { action }

    You can change the names of the methods and the filename.

        require 'debuglog/manual'

        DebugLog.configure(
          :debug => :my_debug,
          :trace => :my_trace,
          :time  => :my_time,
          :filename => 'log/xyz.log'
        )

        my_debug "Message..."
        my_trace :x, binding
        my_time('Task') { action }

    In either case, the log file will look something like this:

    DebugLog -- 2010-07-25 18:58:22 +1000
    -------------------------------------
    [00.3] Message...
    [00.5] x == 5
    [00.6] Task: 1.0831 sec


See http://gsinclair.github.com/debuglog.html for full details.
