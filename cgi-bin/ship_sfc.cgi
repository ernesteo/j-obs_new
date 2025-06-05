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
my $title="Encoded Ship's Synoptic";
my $data_type="ship_sfc";
my $rpt_id="BBXX";
#----------------------------------------------------------

wmo_routines::main( $title, $data_type, $rpt_id );

