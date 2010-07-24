require 'debuglog'

debug "Starting example program"
x = 6
trace :x, binding
trace "ENV['rvm_bin_path']", binding

debug "Environment variables containing PATH"
keys = ENV.keys.grep /PATH/
keys.each do |key|
  trace "  ENV[#{key.inspect}]", binding, 40
end

debug "(end of list)"

t = time('sleep 1.5') { sleep 1.5 }
debug "Time actually slept: #{t}"
