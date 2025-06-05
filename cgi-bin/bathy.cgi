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
my $title = "Encoded Bathy";
my $data_type = "bathy";
my $rpt_id = "JJVV";
#----------------------------------------------------------

wmo_routines::main($title, $data_type, $rpt_id);
