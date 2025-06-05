#!/usr/bin/perl -wT

use warnings;
use strict;
use lib qw( /fnmoc/u/curr/lib/perllib
            /fnmoc/web/webservices/apache/app/common/lib
	    ../lib
	  );
use CGI;
use Validate qw(validate);
use sys_info qw(getDevLevel getHostClass);

$ENV{'PATH'} = '/usr/bin';
delete @ENV{'IFS', 'CDPATH', 'BASH_ENV'};

#
# Setup object-oriented CGI
#
my $q = CGI->new();

#============================= Begin main script ===============================

( my $name = $q->param("name") ) =~ s/[^a-zA-Z.' ]//g;
( my $rank = $q->param("rank") ) =~ s/[^a-zA-Z. ]//g;
( my $site = $q->param("site") ) =~ s/[^a-zA-Z.' ]//g;

my $email = $q->param("email");
if( !defined( validate( $email, 9 ) ) )
{
  $email = "not valid";
}

( my $comments = $q->param("comments") ) =~ s/[^a-zA-Z.' ]//g;
$comments =~ tr/\015//d;   # remove new line

my( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdat ) = gmtime;
$year = $year + 1900;
$mon  = $mon +1;
my $submit_date_time = sprintf( "%4d%02d%02d%02d%02d%02d", $year, $mon, $mday, $hour, $min, $sec );
my $file_name  = "../dynamic/usage_survey/$submit_date_time";

open( my $FILE, ">",  $file_name ) or die " Can't open $file_name: $!";
print( $FILE "RANK:  $rank $name\n" );
print( $FILE "EMAIL: $email\n" );
print( $FILE "SITE:  $site\n" );
print( $FILE "FEEDBACK:\n$comments" );

close( $FILE );

chmod( 0744, "../dynamic/usage_survey/$submit_date_time" );

print "Content-type: text/html\n\n";
print "<!DOCTYPE html><html><body>\n";

#open (IN, "<../html/ship_template.html") " Can't open ../html/ship_template.html";
print <<EOF;
  <font face="Verdana,Helvtica,sans-serif">
  <div style="text-align: center">
  <h1>
  Usage Survey Submission Complete
  </h1>
  </div>
  </font>
EOF

my $level = getDevLevel();
my $clas  = getHostClass();

if( $clas eq "unclas" )
{
  open( my $MAIL, "|-", "/usr/lib/sendmail", "-t" ) or die "could not open sendmail: $!";
  if( $level eq "alpha" | $level eq "beta" )
  {
    print( $MAIL "To: gregory.hoisington2.civ\@us.navy.mil\n" );
    print( $MAIL "Subject: J-OBS Feedback\n" );
    print( $MAIL "Content-type: text/plain\n\n\n" );
    print( $MAIL "The comment below was submitted via the NIPR J-OBS feedback form.\n\n\n" );
    print( $MAIL "FROM:  $rank $name\n" );
    print( $MAIL "EMAIL: $email\n" );
    print( $MAIL "SITE:  $site\n" );
    print( $MAIL "DEV LEVEL: $level\n" );
    print( $MAIL "CLAS LEVEL: $clas\n" );
    print( $MAIL "FEEDBACK:\n" );
    print( $MAIL "$comments\n" );

    print "To: gregory.hoisington2.civ\@us.navy.mil<br>\n";
    print "Subject: J-OBS Feedback<br>\n";
    print "The comment below was submitted via the NIPR J-OBS feedback form.<br>\n";
    print "FROM:  $rank $name<br>\n";
    print "EMAIL: $email<br>\n";
    print "SITE:  $site<br>\n";
    print "DEV LEVEL: $level<br>\n";
    print "CLAS LEVEL: $clas<br>\n";
    print "FEEDBACK:<br>\n";
    print "$comments\n";
  }
  else
  {
    print( $MAIL "To: usn.monterey.flenummetoccenca.mbx.cdo\@us.navy.mil\n" );
    print( $MAIL "cc: gregory.hoisington2.civ\@us.navy.mil\n" );
    print( $MAIL "Subject: J-OBS Feedback\n" );
    print( $MAIL "Content-type: text/plain\n\n\n" );
    print( $MAIL "The comment below was submitted via the NIPR J-OBS feedback form.\n\n\n" );
    print( $MAIL "FROM:  $rank $name\n" );
    print( $MAIL "EMAIL: $email\n" );
    print( $MAIL "SITE:  $site\n" );
    print( $MAIL "DEV LEVEL: $level\n" );
    print( $MAIL "CLAS LEVEL: $clas\n" );
    print( $MAIL "FEEDBACK:\n" );
    print( $MAIL "$comments\n" );

    print "To: usn.monterey.flenummetoccenca.mbx.cdo\@us.navy.mil<br>\n";
    print "cc: gregory.hoisington2.civ\@us.navy.mil<br>\n";
    print "Subject: J-OBS Feedback<br>\n";
    print "The comment below was submitted via the NIPR J-OBS feedback form.<br>\n";
    print "FROM:  $rank $name<br>\n";
    print "EMAIL: $email<br>\n";
    print "SITE:  $site<br>\n";
    print "FEEDBACK:<br>\n";
    print "$comments\n";
  }
  close( $MAIL ) or die "Error closing sendmail: $? / $!";
}
elsif( $clas eq "secret" )
{
  open( my $MAIL, "|-", "/usr/lib/sendmail", "-t" ) or die "could not open sendmail: $!";
  if( getDevLevel() eq "alpha" | getDevLevel() eq "beta" )
  {
    print( $MAIL "To: gregory.j.hoisington\@navy.smil.mil\n" );
    print( $MAIL "Subject: J-OBS Feedback\n" );
    print( $MAIL "Content-type: text/plain\n\n\n" );
    print( $MAIL "The comment below was submitted via the SIPR J-OBS feedback form.\n\n\n" );
    print( $MAIL "FROM:  $rank $name\n" );
    print( $MAIL "EMAIL: $email\n" );
    print( $MAIL "SITE:  $site\n" );
    print( $MAIL "DEV LEVEL: $level\n" );
    print( $MAIL "CLAS LEVEL: $clas\n" );
    print( $MAIL "FEEDBACK:\n" );
    print( $MAIL "$comments\n" );

    print "To: gregory.j.hoisington\@navy.smil.mil<br>\n";
    print "Subject: J-OBS Feedback<br>\n";
    print "The comment below was submitted via the SIPR J-OBS feedback form.<br>\n";
    print "FROM:  $rank $name<br>\n";
    print "EMAIL: $email<br>\n";
    print "SITE:  $site<br>\n";
    print "DEV LEVEL: $level<br>\n";
    print "CLAS LEVEL: $clas<br>\n";
    print "FEEDBACK:<br>\n";
    print "$comments\n";
  }
  else
  {
    print( $MAIL "To: fnmoc.cdo.fct\@navy.smil.mil\n" );
    print( $MAIL "cc: gregory.j.hoisington\@navy.smil.mil\n" );
    print( $MAIL "Subject: J-OBS Feedback\n" );
    print( $MAIL "Content-type: text/plain\n\n\n" );
    print( $MAIL "The comment below was submitted via the SIPR J-OBS feedback form.\n\n\n" );
    print( $MAIL "FROM:  $rank $name\n" );
    print( $MAIL "EMAIL: $email\n" );
    print( $MAIL "SITE:  $site\n" );
    print( $MAIL "DEV LEVEL: $level\n" );
    print( $MAIL "CLAS LEVEL: $clas\n" );
    print( $MAIL "FEEDBACK:\n" );
    print( $MAIL "$comments\n" );

    print "To: fnmoc.cdo.fct\@navy.smil.mil<br>\n";
    print "cc: gregory.j.hoisington\@navy.smil.mil<br>\n";
    print "Subject: J-OBS Feedback<br>\n";
    print "The comment below was submitted via the SIPR J-OBS feedback form.<br>\n";
    print "FROM:  $rank $name<br>\n";
    print "EMAIL: $email<br>\n";
    print "SITE:  $site<br>\n";
    print "FEEDBACK:<br>\n";
    print "$comments\n";
  }
  close( $MAIL ) or die "Error closing sendmail: $? / $!";
}

print <<EOF;
  </body>
  </html>
EOF


