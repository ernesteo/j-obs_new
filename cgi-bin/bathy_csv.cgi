#!/usr/bin/perl -T

use warnings;
use strict;
use lib "../lib";
use bathy_csv_routines;

$ENV{'PATH'} = '/bin:/usr/bin';
delete @ENV{'IFS', 'CDPATH', 'BASH_ENV'};

#----------------------------------------------------------
#           Following variables define html type
#
my $title = "Bathy - CSV";
#----------------------------------------------------------

bathy_csv_routines::setup();
bathy_csv_routines::main( $title );
