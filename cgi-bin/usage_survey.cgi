#!/usr/bin/perl -wT
use warnings;
use strict;
use lib qw( /usr/share/perl5/vendor_perl 
            /fnmoc/web/webservices/apache/app/common/lib 
            /fnmoc/u/curr/lib/perllib 
            ../lib );
use POSIX qw( uname );
use vars qw($clas_banner);
use vars qw($check_email);
use CGI;
use sys_info qw(getDevLevel getHostClass);
use web_routines qw(getClasBnr);

my $check_email;
my $clas_banner = getClasBnr();

$ENV{'PATH'} = '/usr/bin';
delete @ENV{'IFS', 'CDPATH', 'BASH_ENV'};

if( getHostClass() eq "unclas" )
{
  $check_email="<input size='50' maxlength='50' type='text' name='email' id='email' onblur=\"check_email_unclas(this.value,'email','Y');\">";
}
elsif( getHostClass() eq "secret" )
{
  $check_email="<input size='50' maxlength='50' type='text' name='email' id='email' onblur=\"check_email_clas(this.value,'email','Y');\">";
}

print "Content-type: text/html; charset=utf-8\n\n";
open( my $IN, "<", "../html/usage_survey.html_template" ) or die "Can't open ../html/usage_survey.html_template: $!";
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
  s/#CHECK_EMAIL#/$check_email/g;
  print;
}
close( $IN );

