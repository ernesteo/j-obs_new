#!/usr/bin/perl -T

use warnings;
use strict;

use lib "/fnmoc/web/webservices/apache/app/common/lib";
# use lib "/opt/global/perllib";
use lib "../lib";
use CGI;
use sys_info qw(getDevLevel getHostClass getAppName);
use web_routines qw(getClasBnr);

$ENV{'PATH'} = '/usr/bin';
delete @ENV{'IFS', 'CDPATH', 'BASH_ENV'};

#
# Limit file upload size
#
#use constant MAX_FILE_SIZE => 5_000;

use vars qw($clas_banner);
$clas_banner = getClasBnr();

print "Content-type: text/html; charset=utf-8\n\n";
open( my $IN, "<", "../html/updates.html_template" ) or die " Can't open ../html/updates.html_template: $!";
while( <$IN> )
{ 
# 
# skip line
#
  if( index( $_, '//' ) == 0 )
  {
    next;
  }
  s/#CLAS_BANNER#/$clas_banner/g;
  print;
}
close( $IN );


