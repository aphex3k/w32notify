w32notify
=========

w32notify - exit when the contents of a directory change

  w32notify [OPTION]... DIRECTORY...

What is considered a change is determined by the --attrib, --modify, --size, --write, --security and --dir options (see below). These options may be combined. Use --all for all options enabled. If none of them are specified, the execution fails.

This program follow the usual GNU command line syntax, with long options starting with two dashes (--).
-B, --attrib
	Exit when any attribute changes.
-M, --modify
	Exit when a file name changes.
-Z, --size
	Exit when a file size changes.
-W, --write
	Exit when a change to a files last write time occurs.
-S, --security
	Exit when a security descriptor changes.
-D, --dir
	Exit when a directory name changes.
-a, --all
	Exit when any of the events above occurs. That is, this is a shorthand for -BMZWSD.

-q, --quiet, --silent
	Do not print warnings when the executed commands exits with a non-zero return value.
-h, --help
	Show this summary of options.

w32notify was written by Michael Henke <w32notify@codingmerc.com>.
