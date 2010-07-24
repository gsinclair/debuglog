#
# require 'debuglog/manual'
#
# DebugLog.configure(:debug => :dbg)
# dbg "..."         # -> writes "..." to file 'debug.log'
#

class DebugLog

  class Error < StandardError; end

  class << DebugLog

    DEFAULT_CONFIGURATION = {
      :debug => :debug,
      :trace => :trace,
      :time  => :time,
      :file  => 'debug.log'
    }

    def configure(hash)
      err "DebugLog.configure already called" unless @configuration.nil?
      @configuration = hash.dup
      self.debug_method = hash[:debug]
      self.trace_method = hash[:trace]
      self.time_method = hash[:time]
      self.filename = hash[:filename] || 'debug.log'
      @start_time = Time.now
    end

    def autoconfigure
      configure(DEFAULT_CONFIGURATION)
    end

    def debug_method=(m)
      return if m.nil?
      _check_error_clash(m)
      Kernel.module_eval do
        send(:define_method, m) { |*args| DebugLog.debug(*args) }
      end
    end

    def trace_method=(m)
      return if m.nil?
      _check_error_clash(m)
      Kernel.module_eval do
        send(:define_method, m) { |*args| DebugLog.trace(*args) }
      end
    end

    def time_method=(m)
      return if m.nil?
      _check_error_clash(m)
      Kernel.module_eval do
        send(:define_method, m) { |*args, &block| DebugLog.time(*args, &block) }
      end
    end

    def filename=(f)
      @filename = f
    end

    def err(string)
      raise ::DebugLog::Error, "DebugLog error -- #{string}"
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
          t = sprintf "%.3f", (Time.now - t)
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
      _logfile.puts(text)
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

    def _check_error_clash(_method)
      if Kernel.respond_to? _method
        err "Method clash: #{_method.inspect}"
      end
    end

    def wipe_slate_clean_for_testing
      STDERR.tap do |s|
        s.puts "wipe_slate_clean_for_testing"
        s.puts "  @configuration == #{@configuration.pretty_inspect}"
        s.puts "  Kernel methods: #{Kernel.methods.grep /^(debug|trace|time)$/}"
      end
      # This method has nothing to do if configuration hasn't happened.
      return unless @configuration

      # Remove methods from Kernel that were set up before.
      @configuration.values_at(:debug, :trace, :time).compact.each do |method|
        if Kernel.respond_to? method
          Kernel.send(:remove_method, method)
        end
      end

      # Close log file.
      @fh.close if @fh
      @fh = nil

      # Reset 'configuration' object so configuration can happen again.
      @configuration = nil
    end

  end  # class << DebugLog

end  # class DebugLog

Debuglog = DebugLog
