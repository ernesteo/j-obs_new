#!/usr/bin/perl -T

use warnings;
use strict;
use lib "../lib";
use wmo_routines;

$ENV{'PATH'} = '/bin:/usr/bin';
delete @ENV{'IFS', 'CDPATH', 'BASH_ENV'};

#----------------------------------------------------------
#           Following variables define html type
#
my $title="SHIP MOB TAF";
my $data_type="ship_taf";
my $rpt_id="TAF";
#----------------------------------------------------------

wmo_routines::main( $title, $data_type, $rpt_id );

