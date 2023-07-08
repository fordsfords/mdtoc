#!/usr/bin/env perl
# mdtoc.pl
#
# This code and its documentation is Copyright 2011-2021 Steven Ford
# and licensed "public domain" style under Creative Commons "CC0":
#   http://creativecommons.org/publicdomain/zero/1.0/
# To the extent possible under law, the contributors to this project have
# waived all copyright and related or neighboring rights to this work.
# In other words, you can use this code for any purpose without any
# restrictions.  This work is published from: United States.  The project home
# is https://github.com/fordsfords/mdtoc

use strict;
use warnings;
use Getopt::Std;
use File::Basename;
use Carp;
use File::Copy 'copy';

# globals
my $tool = basename($0);

# process options.
use vars qw($opt_h $opt_b);
$opt_b = ".bak";  # default.

getopts('hb:') || mycroak("getopts failure");
my $backup_suffix = $opt_b;

if (defined($opt_h)) {
  help();
}

my @pre_lines;
my @post_lines;
my @toc_lines;
my $state = "pre";

# Main loop; read each line in each file.
while (<>) {
  if ($state eq "pre") {
    get_toc_line($_);
    push(@pre_lines, $_);
    if (/<!-- toc-start -->/) {
      $state = "mid";
    }
  }
  elsif ($state eq "mid") {
    if (/<!-- toc-end -->/) {
      push(@post_lines, $_);
      $state = "post";
    }
  }
  elsif ($state eq "post") {
    get_toc_line($_);
    push(@post_lines, $_);
  }
  else { mycroak("Invalid state '$state'"); }

} continue {  # This continue clause makes "$." give line number within file.
  if (eof) {
    my $f = $ARGV;  # filename
    close ARGV;
    my $fh;
    if ($f eq "-") {
      $fh = *STDOUT
    } else {
      if (length($backup_suffix) > 0) {
        copy($f, "$f$backup_suffix") or mycroak("failed copy '$f' '$f$backup_suffix'");
      }
      open($fh, ">", $f) or mycroak("open for write: '$f'");
    }
    print $fh @pre_lines;
    print $fh @toc_lines;
    print $fh @post_lines;
    if ($f ne "-") {
      close($fh) or mycroak("close: '$f'");
    }

    $state = "pre";
    @pre_lines = ();
    @post_lines = ();
    @toc_lines = ();
  }
}

# All done.
exit(0);


# End of main program, start subroutines.


sub mk_id {
  my ($hdr_text) = @_;

  my $id = lc($hdr_text);
  $id =~ s/ /-/g;
  $id =~ s/[^a-z-]//g;

  return $id;
}  # mk_id


sub get_toc_line {
  my ($iline) = @_;

  if ($iline =~ /^(##*)\s\s*(\S.*)$/) {
    my ($hashes, $title) = ($1, $2);

    $hashes =~ s/^.//;    # get rid of one hash
    $hashes =~ s/#/  /g;  # convert rest of hashes to spaces for indention.
    push (@toc_lines, "$hashes- [$title](#" . mk_id($title) . ")\n");
  }
}  # get_toc_line


sub mycroak {
  my ($msg) = @_;

  if (defined($ARGV)) {
    # Print input file name and line number.
    croak("Error (use -h for help): input_file:line=$ARGV:$., $msg");
  } else {
    croak("Error (use -h for help): $msg");
  }
}  # mycroak


sub assrt {
  my ($assertion, $msg) = @_;

  if (! ($assertion)) {
    if (defined($msg)) {
      mycroak("Assertion failed, $msg");
    } else {
      mycroak("Assertion failed");
    }
  }
}  # assrt


sub help {
  my($err_str) = @_;

  if (defined $err_str) {
    print "$tool: $err_str\n\n";
  }
  print <<__EOF__;
Usage: $tool [-h] [-b backup_suffix] [file ...]
    -h - help
    -b backup_suffix - File name suffix for backup file.
       Use '-b ""' for no backup. Defaults to '-b ".bak"'.
    file ... - one or more input files.  If omitted, inputs from stdin.

__EOF__

  exit(0);
}  # help
