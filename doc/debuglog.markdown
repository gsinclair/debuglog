---
layout: default
title: Debuglog
---

# Debuglog -- a zero-conf debug.log file

**Status: awaiting release (July 2010)**

* This will be replaced by a table of contents
{:toc}


## Synopsis

Debuglog gives you `debug`, `trace` and `time` methods that write their output
to the file `./debug.log`.

{% highlight ruby %}

    require 'debuglog'     # or require 'debuglog/auto'

    debug "Message..."
    trace :x, binding
    time('Task') { action }

{% endhighlight %}

You can change the names of the methods and the filename.

{% highlight ruby %}

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

{% endhighlight %}

In either case, the log file will look something like this:

    DebugLog -- 2010-07-25 18:58:22 +1000
    -------------------------------------
    [00.3] Message...
    [00.5] x == 5
    [00.6] Task: 1.0831 sec

The `[00.3]` etc. is the number of seconds (rounded) since the program started
(well, since `require 'debuglog'`, anyway).

More nuanced configuration is possible; see [Configuration](#Configuration).

### Installation

    $ [sudo] gem install debuglog

Source code is hosted on Github.  See [Project details](#project_details).


## Description

Debuglog allows you easy access to a log file named `debug.log` in the current
directory.  In that file, you can record:
* arbitrary messages with `debug`
* the value of variables with `trace`
* the time taken to execute some code with `time`

Of course, any or all of those methods names might be used by another library or
by your own code. You can choose different method names and a different
filename; see [Configuration](#Configuration).  Debuglog will raise an
exception (`DebugLog::Error`) if it detects a method clash.

### `debug`

The `debug` method is straightforward.  It calls `to_s` on its argument(s) and
writes them to the log file.

[col]: http://gsinclair.github.com/col.html

### `trace`

`trace` requires you to pass the binding with the `binding` method.  The two
following lines are equivalent:

{% highlight ruby %}

    trace :radius, binding
    debug "radius == #{radius.pretty_inspect}"

{% endhighlight %}

> Tip: You may choose to `alias _b binding` for convenience; DebugLog doesn't do that
> for you.

If you want the output truncated, pass an integer argument:

{% highlight ruby %}

    trace :text, binding, 30

{% endhighlight %}

### `time`

`time` calculates the amount of time taken to execute the code in the block
given and records it in the log file.

{% highlight ruby %}

    time("Process configuration file") { @options = parse_config }

{% endhighlight %}

It requires a single string (`#to_s`) argument and a block.

### Notes

`Debuglog` is a synonym for `DebugLog`, so you don't have to trouble yourself to
remember the capitalisation.

The text written to the log file has some nice touches:
* Multi-line output is indented correctly.
* `-------` is inserted each time an extra second of running time has elapsed.
  This gives you a quick visual indication of how much logfile activity is
  taking place.  If more than one second has elapsed since the last log item,
  something like `------- (3 sec)` is emitted.


## Configuration

The [Synopsis](#synopsis) gave a good example of configuration:

{% highlight ruby %}

    require 'debuglog/manual'

    DebugLog.configure(
      :debug => :my_debug,
      :trace => :my_trace,
      :time  => :my_time,
      :filename => 'log/xyz.log'
    )

{% endhighlight %}

This changes the names of the methods that Debuglog defines.  The motivation for
that, of course, is another library or your own code defining methods of those
names.  Debuglog will raise an exception (`DebugLog::Error`) if it detects a
method name clash.  (Of course, you might load the other library _after_
Debuglog, in which case it won't detect the clash.)  This precaution is taken
because they are common method names at the top-level, and it's just not right
for a debugging library to _cause_ bugs.

If you omit a method name from the configuration, that method will not be
defined.  The following code defines the method `d` instead of `debug`, but does
_not_ define `trace` or `time`.  The standard filename `debug.log` is used.

{% highlight ruby %}

    DebugLog.configure(
      :debug => :d,
    )

{% endhighlight %}

If you want to change one or two methods but leave the rest as standard, simply
do:

{% highlight ruby %}

    DebugLog.configure(
      :debug => :d,
      :trace => :trace,
      :time  => :time
    )

{% endhighlight %}

Once you have called `DebugLog.configure`, any further calls to it will be
ignored with a message on STDERR.  That includes this case:

{% highlight ruby %}

    require 'debuglog'           # should be 'debuglog/manual'

    DebugLog.configure(...)

{% endhighlight %}

The code `require 'debuglog` is equivalent to the following code, meaning
your one shot at calling `configure` has been taken.

{% highlight ruby %}

    require 'debuglog/manual'

    DebugLog.configure(
      :debug => :debug,
      :trace => :trace,
      :time  => :time,
      :file  => 'debug.log'
    )

{% endhighlight %}

Final note: if you specify a file that is not writable, an error
(`DebugLog::Error`) will be raised.


## Endnotes

### Motivation

Debugging to a log file is very useful, even if your program doesn't do
"logging" as such.  Ages ago I released `dev-utils/debug` which did this and
intended to do more.  That's outdated now, only working on 1.8, so a revisit was
worthwhile with a better name.  (If anyone wants the old name for something
else, they're welcome to it.)

### Dependencies and requirements

Debuglog does not depend on any other libraries and works in Ruby 1.8 and Ruby
1.9.

Unit tests are implemented in [Attest](http://gsinclair.github.com/attest.html).

### Project details

* Author: Gavin Sinclair (user name: `gsinclair`; mail server: `gmail.com`)
* Date: July 2010
* Licence: MIT licence
* Project homepage: [http://gsinclair.github.com/debuglog.html][home]
* Source code: [http://github.com/gsinclair/debuglog][code]
* Documentation: (project homepage)

[home]: http://gsinclair.github.com/debuglog.html
[code]: http://github.com/gsinclair/debuglog

### Possible future enhancements

Color.  For instance, `debug "!! Object pool overloaded"` could print the
message (minus the exclamation marks) in red.  Traces could be in yellow.  Times
could be in dark cyan, etc.

Further to the above: symbol arguments to `debug` could provide some color
using the `Col` library.  E.g. `debug "blah...", :yb` for yellow bold.

Method to turn it off and on: `DebugLog.off` and `DebugLog.on` or something.

Indenting via `DebugLog.indent` and `DebugLog.outdent`.

Options for `trace` output: `p` for `:inspect`; `y` for `:to_yaml` etc.  I
don't see why the current `:pretty_inspect` would ever be insufficient, but of
course there may be cases.
