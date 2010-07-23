#
# require 'debuglog/manual'
# DebugLog.debug_method = :dbg
#
# dbg "..."         # -> writes "..." to file 'debug.log'
#

class DebugLog

  class << DebugLog

    def configure(hash)
      err "DebugLog.configure already called" if @configured
      @configured = true
      self.debug_method = hash[:debug]
      self.trace_method = hash[:trace]
      self.time_method = hash[:time]
      self.filename = hash[:filename] || 'debug.log'
      @start_time = Time.now
    end

    def debug_method=(m)
      Kernel.module_eval do
        send(:define_method, m) { |*args| DebugLog.debug(*args) }
      end
    end

    def trace_method=(m)
      Kernel.module_eval do
        send(:define_method, m) { |*args| DebugLog.trace(*args) }
      end
    end

    def time_method=(m)
      Kernel.module_eval do
        send(:define_method, m) { |*args, &block| DebugLog.time(*args, &block) }
      end
    end

    def filename=(f)
      @filename = f
    end

    def err(string)
      STDERR.puts string
      exit 127
    end

    def debug(string)
      write(string)
    end

    def trace(expr, _binding)
      value = eval expr, _binding
      message = "#{expr} == #{value}"
        # todo: consider :p, :pp, :yaml, etc.
      write(message)
    end

    def time(task)
      message =
        if block_given?
          t = Time.now
          yield
          "#{task}: #{t} sec"
        else
          "*** Debuglog.task: block required ***"
        end
      write(message)
    end

    def write(message)
      time = (Time.now - @start_time)
      if time.to_i != @time.to_i
        _logfile.puts "-------"
      end
      @time = time
      time = sprintf "%04.1f", time.to_f
      text = "[#{time}] #{message}"
      _logfile.puts(message)
      _logfile.flush
    end

    def _create_debug_method(method_name)
      Kernel.send(:define_method, method_name) { |message|
        DebugLog.write(message)
      }
    end

    def _logfile
      @fh ||= File.new(@filename, "w")
    end

  end  # class << DebugLog

end  # class DebugLog

Debuglog = DebugLog
