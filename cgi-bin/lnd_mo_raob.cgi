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
my $title="Encoded Land Mobile Upperair Sounding";
my $data_type="lnd_mo_raob";
my $rpt_id="IIAA,IIBB,IICC,IIDD";
#----------------------------------------------------------

wmo_lnd_routines::setup();
wmo_lnd_routines::main( $title, $data_type, $rpt_id );
