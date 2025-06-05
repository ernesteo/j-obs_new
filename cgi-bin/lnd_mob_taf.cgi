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
my $title="LAND MOB TAF";
my $data_type="mob_taf";
#my $link_form="no";
my $rpt_id="TAF";
#----------------------------------------------------------

wmo_lnd_routines::setup();
wmo_lnd_routines::initialize_taf();
wmo_lnd_routines::main( $title, $data_type, $rpt_id );

