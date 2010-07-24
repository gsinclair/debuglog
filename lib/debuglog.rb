#
# Usage:
#
#   require 'debuglog'
#   debug "..."        # -> writes "..." to 'debug.log'
#
# Note: +debug+ is the _default_ method name.  You can set a different one like
# this:
#
#   require 'debuglog/manual'
#   DebugLog.configure(...)  # todo: complete
#   dbg "..."          # -> writes "..." to 'debug.log'
#
# If +debug+ (or the name you choose manually) is the name of an existing
# method, it will _not_ be overwritten.

require 'debuglog/auto'
