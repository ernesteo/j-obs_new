#!/usr/bin/perl -T

use warnings;
use strict;
use lib "../lib";
use loc_routines;

$ENV{'PATH'} = '/bin:/usr/bin';
delete @ENV{'IFS', 'CDPATH', 'BASH_ENV'};

#----------------------------------------------------------
#           Following variables define html type
#
my $title="Ship Location Entry";
my $data_type="shp_loc";
#----------------------------------------------------------

loc_routines::setup();
loc_routines::initialize();
loc_routines::main( $title, $data_type );

