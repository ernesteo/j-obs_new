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
my $title="Encoded Upper Air Sounding";
my $data_type="ship_raob";
my $rpt_id="UUAA,UUBB,UUCC,UUDD";
#----------------------------------------------------------

wmo_routines::main( $title, $data_type, $rpt_id );

