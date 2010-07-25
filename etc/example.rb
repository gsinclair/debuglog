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

t = time('sleep 3.52') { sleep 3.52 }
debug "Time actually slept (rounded): #{t}"

debug ""
debug "Multi-\nline\ntext\n   with an indented (3 spaces) final line"
debug ""
debug "Display large array/hash with pp"
hash = ENV.select { |k,v| k =~ /PATH/ }
trace :hash, binding
