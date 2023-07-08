#!/usr/bin/env perl
# tst.pl
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
use vars qw($opt_h);

getopts('h') || mycroak("getopts failure");

if (defined($opt_h)) {
  help();
}

my @toc_ids;
my @toc_hrefs;

# Main loop; read each line in each file.
while (<>) {
  if (/a href="#([^"]+)"/) {
    push(@toc_ids, $1);
  }
  elsif (/user-content-.*href="#([^"]+)"/) {
    push(@toc_hrefs, $1);
  }
} continue {  # This continue clause makes "$." give line number within file.
  if (eof) {
    my $num_ids = scalar(@toc_ids);
    assrt($num_ids == scalar(@toc_hrefs), "$num_ids == " . scalar(@toc_hrefs));

    for (my $i = 0; $i < $num_ids; $i++) {
print "??? toc_ids[$i]=$toc_ids[$i], toc_hrefs[$i]=$toc_hrefs[$i]\n";
      assrt($toc_ids[$i] eq $toc_hrefs[$i], "$toc_ids[$i] eq $toc_hrefs[$i]");
    }
    my $f = $ARGV;  # filename
    close ARGV;

    @toc_ids = ();
    @toc_hrefs = ();
  }
}

# All done.
exit(0);


# End of main program, start subroutines.


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
    file ... - one or more input files.  If omitted, inputs from stdin.

__EOF__

  exit(0);
}  # help
