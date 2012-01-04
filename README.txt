debuglog: zero-conf debug.log file for simple and hassle-free debugging


= SYNOPSIS

Debuglog gives you debug, trace and time methods that write their output to the
file ./debug.log.

    require 'debuglog'     # or require 'debuglog/auto'

    debug "Creating #{n} connections"
    trace "names.first", binding
    time('Process config file') { Subsystem.configure(ARGV.shift) }

The log file (default ./debug.log) will look something like this:

    DebugLog -- 2011-12-28 18:58:22 +1000
    -------------------------------------
    [00.3] Creating 14 connections
    [00.8] names.first == "Sandy White"
    [01.9] Process config file: 1.0831 sec

The [00.3] etc. is the number of seconds (rounded) since the program started
(well, since require 'debuglog', anyway).

You can use different method names (to avoid a clash) and a different filename
with some initial configuration.

    require 'debuglog/manual'

    DebugLog.configure(
      :debug => :my_debug,
      :trace => :my_trace,
      :time  => :my_time,
      :filename => 'log/xyz.log'
    )

    my_debug "Creating #{n} connections"
    my_trace "names.first", binding
    my_time('Process config file') { Subsystem.configure(ARGV.shift) }


= HOMEPAGE

See http://gsinclair.github.com/debuglog.html for full details.

MIT Licence
