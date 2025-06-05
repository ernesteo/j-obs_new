#!/usr/bin/perl -T

use warnings;
use strict;
use lib "../lib";
use bufr_routines;

$ENV{'PATH'} = '/bin:/usr/bin';
delete @ENV{'IFS', 'CDPATH', 'BASH_ENV'};

#----------------------------------------------------------
#           Following variables define html type
#
my $title    = "BUFR Ship File";
my $data_type= "bufr_shp";
my $source   = "shp";
#----------------------------------------------------------

bufr_routines::main( $title, $data_type, $source );

