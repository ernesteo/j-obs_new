#!/usr/bin/perl -T

use warnings;
use strict;
use lib "../lib";
use form_routines;

$ENV{'PATH'} = '/bin:/usr/bin';
delete @ENV{'IFS', 'CDPATH', 'BASH_ENV'};

#----------------------------------------------------------
#           Following variables define html type
#
my $title="Bathy";
my $data_type="bathy_form";
#----------------------------------------------------------

form_routines::setup();
form_routines::main( $title, $data_type );
