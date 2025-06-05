#!/usr/bin/perl -T

use warnings;
use strict;

#
# Setup Pearl CGI
#
use lib "../lib";
use wmo_routines;
use sys_info qw(getDevLevel getHostClass getAppName);
use CGI;

$ENV{'PATH'} = '/usr/bin';
delete @ENV{'IFS', 'CDPATH', 'BASH_ENV'};

#
# Setup object-oriented CGI
#
my $q = CGI->new();

#============================= Begin main script ===============================

#
# Set variables needed by decoders
#
my $ETC_DIR = "/fnmoc/u/curr/etc/static/app/j-obs_batch";
my $PROGBIN = "/fnmoc/u/curr/bin";

$ENV{'GEMTBL'} = "$ETC_DIR/tables";
$ENV{'GEMERR'} = "$ETC_DIR/error";
$ENV{'GEMHLP'} = "$ETC_DIR/help";

my $data_form = $q->param("data_form");
my $file = $q->param("file");
my $word = "";

print "Content-type: text/html\n\n";

print <<EOF;
     <!DOCTYPE html>
     <html>
     <body>
     <pre>
EOF

# below two lines fixed vulnerability in J-Obs arbitrary file reading - 2/15/19
$file=~ s/\.\.//g;
$data_form=~ s/\.\.//g;

if($file eq "")
{
  print "Please make date/time ship observation selection in Data Display web page";
print <<EOF;
    </pre>
    </body>
    </html>
EOF
  exit;
}

my $line;
my $data_type;

if( $data_form eq "decode" )
{
  # $file has classification directory in its name
  $file =~ s/#DATA_FORM#/encode/;
  my $file_name  = "../dynamic/archive/$file";
  open( my $FILE, "<", $file_name ) or die "Can't open '$file_name'\n$!";
  open( my $WF, ">", "/tmp/wmo_file_$$" ) or die "Can't open /tmp/wmo_file_$$\n$!";
  while( $word ne "END" )
  {
    $line = <$FILE>;
    ($word) = split(' ',$line);
  }
  $line = <$FILE>;
  printf( $WF "%s", $line );
  ( $data_type ) = split( ' ', $line );
  while( <$FILE> )
  {
    printf( $WF "%s", $_ );
  }
  close( $FILE );
  close( $WF );

  $ENV{'WMO_FILE'} = "/tmp/wmo_file_$$";
  my $OUTPUT;
  my $OUTPUT_TMP;
  if ($data_type eq "BBXX" || $data_type eq "OOXX")
  {
    $OUTPUT = `$PROGBIN/dcmsfc_2 -v3 -d /tmp/logdcmsfc_$$.out $ETC_DIR/tables/stns/sfc_stn_msl 2>&1`;
    $OUTPUT_TMP = `cat /tmp/logdcmsfc_$$.out`;
    system("/bin/rm /tmp/logdcmsfc_$$.out");
  }
  elsif ($data_type eq "JJVV" || $data_type eq "KKYY")
  {
    $OUTPUT = `$PROGBIN/dcbthy_2 -v3 -d /tmp/logdcbthy_$$.out dummytbl 2>&1`;
    $OUTPUT_TMP = `cat /tmp/logdcbthy_$$.out`;
    system("/bin/rm /tmp/logdcbthy_$$.out");
  }
  elsif( $data_type eq "UUAA" || $data_type eq "UUBB" || $data_type eq "UUCC" || $data_type eq "UUDD" ||
         $data_type eq "IIAA" || $data_type eq "IIBB" || $data_type eq "IICC" || $data_type eq "IIDD" )
  {
    $OUTPUT = `$PROGBIN/dcusnd_2 -v3 -d /tmp/logdcusnd_$$.out $ETC_DIR/tables/stns/sfc_stn_msl $ETC_DIR/tables/stns/shp_ref_lib 2>&1`;
    $OUTPUT_TMP = `cat /tmp/logdcusnd_$$.out`;
    system("/bin/rm /tmp/logdcusnd_$$.out_$$.out");
  }
  elsif ($data_type eq "AMDAR")
  {
    $OUTPUT = `$PROGBIN/dcacft_2 -v3 -d /tmp/logdcacft_$$.out $ETC_DIR/tables/stns/pirep_navaids.tbl $ETC_DIR/tables/stns/airep_waypnts.tbl 2>&1`;
    $OUTPUT_TMP = `cat /tmp/logdcacft_$$.out`;
    system("/bin/rm /tmp/logdcacft_$$.out_$$.out");
  }
  elsif ($data_type eq "TAF")
  {
    print "NO DECODER FOR TAF";
  }
  else
  {
    print "UNKNOWN DATA TYPE";
  }

  system("/bin/rm /tmp/wmo_file_$$");

  if ($OUTPUT eq "0")
  {
    printf ("%s","ERROR ---> Please check encoded message");
  }
  else
  {
    my $OUTPUT_TMP_2="=========================== DIAGNOSTIC OUTPUT =========================";
    $OUTPUT = join("\n",$OUTPUT,$OUTPUT_TMP_2);
    $OUTPUT = join("\n",$OUTPUT,$OUTPUT_TMP);

    printf("%s",$OUTPUT);
  }
  
}#End if($data_form eq "decode")
else
{
  $file =~ s/#DATA_FORM#/$data_form/;
  my $file_name  = "../dynamic/archive/$file";
  open( my $FILE, "<", $file_name ) or &error;
  print <$FILE>;
  close( $FILE );
}

print <<EOF;
     </pre>
     </body>
     </html>
EOF

sub error {
my $htmlError = "
<HTML>
  <HEAD>
    <TITLE>ERROR PAGE</TITLE>
  </HEAD>
  <style>
    BODY {color:red; text-align: center; font-size:24px;}
  </style>
  <BODY>
    <H4>Invalid Entry. Please try again.</H4>
  </BODY>
</HTML>";

print $htmlError;
      return;
}
