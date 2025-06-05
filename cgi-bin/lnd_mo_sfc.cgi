#!/usr/bin/perl -T

use warnings;
use strict;
use lib "../lib";
use wmo_lnd_routines;

$ENV{'PATH'} = '/bin:/usr/bin';
delete @ENV{'IFS', 'CDPATH', 'BASH_ENV'};

#----------------------------------------------------------
#           Following variables define html type
#
my $title="Encoded Land Mobile Synoptic";
my $data_type="lnd_mo_sfc";
my $rpt_id="OOXX";
#----------------------------------------------------------

wmo_lnd_routines::setup();
wmo_lnd_routines::main( $title, $data_type, $rpt_id );
