#
# require 'debuglog/manual'
#
# DebugLog.configure(:debug => :dbg)
# dbg "..."         # -> writes "..." to file 'debug.log'
#

class DebugLog

  @@instance = nil

  DEFAULT_CONFIGURATION = {
    :debug => :debug,
    :trace => :trace,
    :time  => :time,
    :file  => 'debug.log'
  }

  class Error < StandardError; end

  def DebugLog.err(string)
    raise ::DebugLog::Error, "DebugLog error -- #{string}"
  end

  def DebugLog.configure(hash)
    if @@instance.nil?
      @@instance = DebugLog.new(hash)
    else
      err("DebugLog already configured")  # todo: replace
    end
  end

  def DebugLog.autoconfigure
    configure(DEFAULT_CONFIGURATION)
  end

  def initialize(config)
    @kernel_methods_defined = []
    _create_kernel_method(config[:debug], :debug)
    _create_kernel_method(config[:trace], :trace)
    _create_kernel_method(config[:time],  :time)
    @filename = config[:filename] || 'debug.log'
    @fh = File.open(@filename, 'w')
    @fh.sync = true
    @start_time = Time.now
    header = "DebugLog -- #{@start_time}"
    @fh.puts header
    @fh.puts('-' * header.length)
  end

  def debug(string)
    _write(string.to_s)
  end

  def trace(expr, _binding)
    value = eval expr, _binding
    message = "#{expr} == #{value}"
      # todo: consider :p, :pp, :yaml, etc.
    _write(message)
  end

  def time(task, &block)
    message =
      if block.nil?
        "*** Debuglog.task: block required (#{caller[0]}) ***"
      else
        t = Time.now
        block.call
        t = sprintf "%.3f", (Time.now - t)
        "#{task}: #{t} sec"
      end
    _write(message)
  end

  def _write(message)
    time = (Time.now - @start_time)
    if time.to_i != @time.to_i
      @fh.puts "-------"
    end
    @time = time
    time = sprintf "%04.1f", time.to_f
    text = "[#{time}] #{message}"
    @fh.puts(text)
  end

  def _create_kernel_method(name, target)
    if name.nil?
      return 
    elsif Kernel.respond_to? name
      DebugLog.err "DebugLog: Method clash in Kernel: #{name.inspect}"
    else
      Kernel.module_eval %{
        def #{name}(*args, &block)
          DebugLog.call_method(:#{target}, *args, &block)
        end
      }
      @kernel_methods_defined << name
    end
  end

  DEBUG_METHODS = [:debug, :trace, :time]
  def DebugLog.call_method(name, *args, &block)
    if DEBUG_METHODS.include? name
      if @@instance
        @@instance.send(name, *args, &block)
      else
        err %{
          ~ DebugLog is not configured.  You can:
          ~   * require 'debuglog/auto' or call DebugLog.autoconfigure; or
          ~   * call DebugLog.configure(...) to configure it manually
        }.strip.gsub(/^\s+~ /, '')
      end
    else
      err "illegitimate method called: #{name}"
    end
  end

  def terminate   # For testing
    @fh.close unless @fh.closed?
    @kernel_methods_defined.each do |m|
      Kernel.send(:remove_method, m)
    end
  end
  private :terminate

  def DebugLog.wipe_slate_clean_for_testing
    if @@instance
      @@instance.send(:terminate)
      @@instance = nil
    end
  end

end  # class DebugLog

Debuglog = DebugLog
