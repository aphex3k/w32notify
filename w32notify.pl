#!/bin/perl
#
# w32notify - Execute a command when the contents of a directory change
use strict;

use Getopt::Long;
require Win32::ChangeNotify;

Getopt::Long::Configure ('bundling_override');

#   ATTRIBUTES   Any attribute change
#   DIR_NAME     Any directory name change
#   FILE_NAME    Any file name change (creating/deleting/renaming)
#   LAST_WRITE   Any change to a file's last write time
#   SECURITY     Any security descriptor change
#   SIZE         Any change in a file's size

my $seperator = "|";
my @all_events = ("ATTRIBUTES","DIR_NAME","FILE_NAME","LAST_WRITE","SECURITY","SIZE");
my $events = "";
my $subTree = 0;
my $path = "./";
my $all = 0;
my $help = 0;
my $silent = 0;

my $attributes = 0;
my $dir_name = 0;
my $file_name = 0;
my $last_write = 0;
my $security = 0;
my $size = 0;

GetOptions (
	'p|path=s' => \$path, 
	's|subtree' => \$subTree,
	'a|all' => \$all,
	'h|help|?' => \$help,
	'q|quiet|silent' => \$silent,
	'B|attrib' => \$attributes,
	'R|rename' => \$file_name,
	'D|dir' => \$dir_name,
	'W|write' => \$last_write,
	'S|security' => \$security,
	'Z|size' => \$size,
 );

if ($help) {
	usage();
	exit(0);
}
if (!(-d $path || -f $path)) {
	echo ("Path or File not found: ".$path);
	exit(-1);
}

if ($all) {
	$events = join($seperator, @all_events);
} else {
	my @e = ();
	push(@e, "ATTRIBUTES") if $attributes;
	push(@e, "FILE_NAME") if $file_name;
	push(@e, "DIR_NAME") if $dir_name;
	push(@e, "LAST_WRITE") if $last_write;
	push(@e, "SECURITY") if $security;
	push(@e, "SIZE") if $size;
	$events = join($seperator, @e);
}

if ($events eq "") {
	echo("No events specified ".$events."\n");
	exit(-1);
}

my $notify = Win32::ChangeNotify->new($path,$subTree,$events);
$notify->wait or warn "Something failed: $!\n";

sub echo() {
	if (!$silent) {
		my $string = @_[0];
		print($string."\n");
	}
}

sub usage() {
	print 'w32notify - exit when the contents of a directory change

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
' 
}
