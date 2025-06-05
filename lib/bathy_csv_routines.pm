#!/usr/bin/perl -w

package bathy_csv_routines;

use warnings;
use strict;
use lib qw(/fnmoc/web/webservices/apache/app/common/lib);

use vars qw($title);
use vars qw($sub_dir $web_dir $bathy_csv_intro $bathy_csv_explanation $remote_id $browser_type $q);
use vars qw($results $server_receive_time $server_send_time
            $client_receive_time $client_send_time $accept_location);
# activity_file
use vars qw($sec_s $min_s $hour_s $mday_s $mon_s $year_s $wday_s $yday_s $isdat_s $send_dtg);
# bathy_csv_input
use vars qw($observer_title $observer $email $csgn_name $ship_title $ship_name
     %month_name
     $upload_csv_file $upload_csv_file_out $upload_csv_header $fh
     $obs_yr $obs_mo $obs_day $obs_hr $obs_min
     $actl_ob_hr $actl_ob_min $obs_time
     $sub_yr $sub_mo $sub_day $sub_hr $sub_min $sub_time
     $clas_type $cls_sel $cls_cvt $cls_ath $cls_rsn $cls_doc $clas
     $dcls_sel $dcls_yr $dcls_mon $dcls_day $dcls_tday $dcls_txt
     $dcls_sec $dcls_min $dcls_hr $dcls_wday $dcls_yday $dcls_isdat $dcls_inst
     $lat_sign $lat $lon_sign $lon $quad $oct
     $submit_type
     $day_utc $mon_utc $yr_utc $hr_utc $min_utc $units
     $lat_d $lat_m $lat_s $lon_sign $lon_d $lon_m $lon_s
     $bt_type $rcrdr @zz $profile_cnt @ttt $radio_call);
# process_data
use vars qw($obs_dtg $sub_dtg $group $section_0 $section_1 $section_2 $section_3
            $section_4 $section_m $dps_hdr);
# round_date
use vars qw($new_obs_yr $new_obs_mo $new_obs_day $new_obs_hr $obs_jul);

sub setup
{
  #
  # Setup Pearl CGI
  #
  use lib "/fnmoc/u/curr/lib/perllib";
  use CGI;
  #
  # Limit file upload size
  #
  #  use constant MAX_FILE_SIZE => 7_000;

  return();

}#End setup

#================================= Begin Functions =============================

sub check_location
{
  my $rlat;
  my $rlon;
  $rlat = $lat_d + $lat_m/60.0 + $lat_s/3600.0;
  if($lat_sign eq "S")
  {
    $rlat = -$rlat;
  }

  $rlon = $lon_d + $lon_m/60.0 + $lon_s/3600.0;
  if($lon_sign eq "W")
  {
    $rlon = -$rlon;
  }

  open( my $FILE, ">", "../dynamic/temp/location_$$.list" ) or die "../dynamic/temp/location_$$.list: $!";
  printf( $FILE "%-6s %-6.1f %6.1f\n", $csgn_name, $rlat, $rlon );
  close( $FILE );

  # -------------------------
  # draw map with location

  open( $FILE, ">", "../dynamic/temp/coverage_plot_$$.in" ) or die "../dynamic/temp/coverage_plot_$$.in: $!";
  printf( $FILE "%s\n","TITLE1=Location Check" );
  printf( $FILE "%s\n","IMAGE_FILE=../dynamic/temp/location_check_plot_$$.png" );
  #printf (FILE "%s\n","IMAGE_FILE=STDOUT");
  if($clas_type eq "U")
  {
    printf( $FILE "%s\n","IMAGE_BG=/fnmoc/u/curr/etc/static/app/cov_plots2/images/basic_white_unclassified.png" );
  }
  elsif($clas_type eq "C")
  {
    printf( $FILE "%s\n","IMAGE_BG=/fnmoc/u/curr/etc/static/app/cov_plots2/images/basic_white_confidential.png" );
  }
  elsif($clas_type eq "C")
  {
    printf( $FILE "%s\n","IMAGE_BG=/fnmoc/u/curr/etc/static/app/cov_plots2/images/basic_white_secret.png" );
  }
  else
  {
    printf( $FILE "%s\n","IMAGE_BG=/fnmoc/u/curr/etc/static/app/cov_plots2/images/basic_white.png" );
  }

  printf( $FILE "%s\n","NAME_LENGTH=4" );
  printf( $FILE "%s\n","NAME_START=1" );
  printf( $FILE "%s\n","LATITUDE_LENGTH=6" );
  printf( $FILE "%s\n","LATITUDE_START=7" );
  printf( $FILE "%s\n","LONGITUDE_LENGTH=7" );
  printf( $FILE "%s\n","LONGITUDE_START=14" );
  printf( $FILE "%s\n","#" );
  printf( $FILE "%s\n","CAPTION1=Ship call sign $csgn_name" );
  printf( $FILE "%s\n","COLOR=red" );
  printf( $FILE "%s\n","SYMBOL=x" );
  printf( $FILE "%s\n","SYMBOL_SIZE=vbig" );
  printf( $FILE "%s\n","LOCATION_FILE=../dynamic/temp/location_$$.list" );
  close( $FILE );

  my $INPUT = `/fnmoc/u/curr/bin/coverage_plot ../dynamic/temp/coverage_plot_$$.in 2>&1`;

  if( -e "../dynamic/temp/location_$$.list" )
  {
      unlink "../dynamic/temp/location_$$.list" or warn "Failed to delete '../dynamic/temp/location_$$.list': $!" ;
  }

  if( -e "../dynamic/temp/coverage_plot_$$.in" )
  {
      unlink "../dynamic/temp/coverage_plot_$$.in" or warn "Failed to delete '../dynamic/temp/coverage_plot_$$.in': $!" ;
  }

  #
  # -------------------------
  #
  print "Content-type: text/html\n\n";
  print <<EOF;
<!DOCTYPE html>
<html>
<head>
<title>location check</title>
</head> 
<body>

<script src="../js/functions.js" language="JavaScript" type="text/javascript"></script>

<form
EOF
  print('action="../cgi-bin/bathy_csv.cgi"');

  print <<EOF;
  onsubmit="return check_accept_location()"
  method="post"
  target="loc_target"
  enctype="multipart/form-data">
EOF

  print <<EOF;
<!--# Bookkeeping -->
<input type="hidden" name="title" value="$title">
<input type="hidden" name="submit_type" value="$submit_type">
<input type="hidden" name="clas" value="$clas">
<input type="hidden" name="id_num" value="$$">
EOF

  print <<EOF;
<!--# Uploaded Header -->
<input type="hidden" name="upload_csv_header" value="$upload_csv_header">
EOF

  print <<EOF;
<!--# input sourcer -->
<input type="hidden" name="upload_csv_file" value="$upload_csv_file">
<input type="hidden" name="upload_csv_file_out" value="$upload_csv_file_out">
EOF

  print <<EOF;
<!--# Point of Origin -->
<input type="hidden" name="observer" value="$observer">
<input type="hidden" name="observer_title" value="$observer_title">
<input type="hidden" name="email" value="$email">
<input type="hidden" name="csgn_name" value="$csgn_name">
<input type="hidden" name="ship_name" value="$ship_name">
<input type="hidden" name="ship_title" value="$ship_title">
EOF

  print <<EOF;
<!--# Time of Observation -->
<input type="hidden" name="obs_yr" value="$obs_yr">
<input type="hidden" name="obs_mo" value="$obs_mo">
<input type="hidden" name="obs_day" value="$obs_day">
<input type="hidden" name="obs_hr" value="$obs_hr">
<input type="hidden" name="obs_min" value="$obs_min">
EOF

  print <<EOF;
<!--# Time of Submission -->
<input type="hidden" name="sub_yr" value="$sub_yr">
<input type="hidden" name="sub_mo" value="$sub_mo">
<input type="hidden" name="sub_day" value="$sub_day">
<input type="hidden" name="sub_hr" value="$sub_hr">
<input type="hidden" name="sub_min" value="$sub_min">
EOF

  print <<EOF;
<!--# Security -->
<input type="hidden" name="clas_type" value="$clas_type">
<input type="hidden" name="cls_sel" value="$cls_sel">
<input type="hidden" name="cls_ath" value="$cls_ath">
<input type="hidden" name="cls_rsn" value="$cls_rsn">
<input type="hidden" name="cls_doc" value="$cls_doc">
<input type="hidden" name="cls_cvt" value="$cls_cvt">
<input type="hidden" name="dcls_sel" value="$dcls_sel">
<input type="hidden" name="dcls_tday" value="$dcls_tday">
<input type="hidden" name="dcls_yr" value="$dcls_yr">
<input type="hidden" name="dcls_mon" value="$dcls_mon">
<input type="hidden" name="dcls_day" value="$dcls_day">
<input type="hidden" name="dcls_txt" value="$dcls_txt">
<!--# Transmission -->
<input type="hidden" name="server_send_time" value="$server_send_time">
<input type="hidden" name="client_receive_time" value="$client_receive_time">
<input type="hidden" name="client_send_time" value="$client_send_time">
EOF

#
# JJVV --- bathy
#
  print <<EOF;
<!--# Location -->
<input type="hidden" name="lat_sign" value="$lat_sign">
<input type="hidden" name="lat_d" value="$lat_d">
<input type="hidden" name="lat_m" value="$lat_m">
<input type="hidden" name="lat_s" value="$lat_s">
<input type="hidden" name="lon_sign" value="$lon_sign">
<input type="hidden" name="lon_d" value="$lon_d">
<input type="hidden" name="lon_m" value="$lon_m">
<input type="hidden" name="lon_s" value="$lon_s">
<!--# Observation Date and Time -->
<input type="hidden" name="yr_utc" value="$yr_utc">
<input type="hidden" name="mon_utc" value="$mon_utc">
<input type="hidden" name="day_utc" value="$day_utc">
<input type="hidden" name="hr_utc" value="$hr_utc">
<input type="hidden" name="min_utc" value="$min_utc">

<!--# Instrument inofrmation -->
<input type="hidden" name="bt_type" value="$bt_type">
<input type="hidden" name="rcrdr" value="$rcrdr">
EOF

  print <<EOF;
<!--# Profile -->
<input type="hidden" name="units" value="$units">
<input type="hidden" name="profile_cnt" value="$profile_cnt">
EOF
  my $i;
  for ($i = 0; $i < $profile_cnt; $i++)
  {

  print <<EOF;
<input type="hidden" name="zz$i" value="$zz[$i]">
<input type="hidden" name="tt$i" value="$ttt[$i]">
EOF
  }

  print <<EOF;
<table style="margin:auto; text-align:center;">
<tr>
<td style='text-align:center'>
<br>
<a href=\"javascript:window.open('','_self').close();window.open('','_long_form').close()\">close windows</a>
</td>
</tr>
<tr>
<td style='text-align:center;'>
<img src="../dynamic/temp/location_check_plot_$$.png" alt="display map with location">
<br>
Is this location acceptable?
<input type="radio" id="accept_location" name="accept_location" value="yes" /> YES
<input type="radio" id="accept_location" name="accept_location" value="no" /> NO
<br>
<input type="submit" value="Process">
<input type="hidden" name="results" value="submit">
</td>
</tr>
</table>
</form>
</body>
</html>
EOF

return();

}#End check_location

sub cleanup
{
  my $id_num;
  ($id_num = $q->param("id_num")) =~ s/[^0-9]//g;
  if ($id_num =~ /^([-\@\w.]+)$/)
  {
    $id_num = $1;                     # $data now untainted
  }
  else
  {
    die "Bad data in '$id_num'";      # log this somewhere
  }

  unlink "../dynamic/temp/location_check_plot_${id_num}.png" or warn "Failed to delete '../dynamic/temp/location_check_plot_${id_num}.png': $!" ;

  return();

}#End cleanup

sub redo_location_mess
{
  print "Content-type: text/html; charset=utf-8\n\n";
  print "<!DOCTYPE html><html><head><title>resubmit</title></head><body>\n";
  print "<h1 style='text-align:center'>";
  print "<br> PLEASE CHANGE LOCATION";
  print "<br> <a href=\"javascript:window.open('','_self').close();\">close window</a>";
  print "</h1>";
  print "</body></html>";

  return();

}#End redo_location_mess

sub generate_html
{
  #
  # Need to parse the including file and set the value of server_send_time to a
  # unique value. This could be YYYYMMDDHHMMSS.  This value would be saved
  # in ain id  log file along with the ship's call sign and possibly the obs time.
  # To guard against diplicate resubission through the use of the browser's
  # refresh the log file would be checked.
  #
  use vars qw($clas_banner);
  use sys_info qw(getDevLevel getHostClass getAppName);
  use web_routines qw(getClasBnr getClas);



  ( my $sec, my $min, my $hour, my $mday, my $mon, my $year, my $wday, my $yday, my $isdat ) = gmtime;

  #
  # Create the html file and send to client
  #
  print "Content-type: text/html; charset=utf-8\n\n";

  open( my $IN, "<", "../html/data_type_form.html_template" ) or die "Can't open ../html/data_type_form.html_template: $!";

  my $clas_banner = getClasBnr();

  $year = $year + 1900;
  $mon  = $mon +1;

  my $date_time = join ("_",$year, $mon, $mday, $hour, $min, $sec);

  while( <$IN> )
  {
    #
    # skip line
    #
    if( index( $_, '//' ) == 0 )
    {
      next;
    }
    s/#WEB_DIR#/$web_dir/g;
    s/#TITLE#/$title/g;
    s/#DATA_TYPE#/bathy_csv/g;
    s/#FORM_STAT#/$date_time/g;
    s/#SUBMIT_TYPE#/bathy_csv/g;
    s/#FORM_INTRO#/$bathy_csv_intro/g;
    s/#FORM_EXPLAN#/$bathy_csv_explanation/g;
    s/#CLAS_BANNER#/$clas_banner/g;

    if( getHostClass() eq "secret" )
    { 
      s/#CLAS_LABEL#/clas/g;
    }
    else
    {
      s/#CLAS_LABEL#/unclas/g;
    }

    if( index( $_, "#COL_INSERT#" ) >= 0 )
    {
      open( my $INS, "<", "../html/color_insert.html_template" ) or die "Can't open ../html/color_insert.html_template: $!";
      while( <$INS> )
      {
        if( index( $_, '//' ) == 0 )
        {
          next;
        }
        print;
      }
      close( $INS );
    }
    elsif( index( $_, "#ORG_INSERT#" ) >= 0 )
    {
        my $mail;

        if( getHostClass() eq "secret" ){ $mail = "check_email_clas"; }
        else                            { $mail = "check_email_unclas"; }

        system( "../cgi-bin/origin_insert.cgi", $mail );

    }
    elsif( index( $_, "#TIM_INSERT#" ) >= 0 )
    {
      open( my $INS, "<", "../html/time_insert.html_template" ) or die "Can't open ../html/time_insert.html_template: $!" ;
      while( <$INS> )
      {
        if( index( $_, '//' ) == 0 )
        {
          next;
        }
        print;
      }
      close( $INS );
    }
    elsif( index( $_, "#SEC_INSERT#" ) >= 0 )
    {
      my $INS;
      if( getHostClass() eq "unclas" )
      {
        open( $INS, "<", "../html/security_unclas_insert.html_template" ) or die "../html/security_insert.html_template: $!";
      }
      else
      {
        open( $INS, "<", "../html/security_insert.html_template" ) or die "../html/security_insert.html_template: $!";
      }

      while( <$INS> )
      {
        if( index( $_, '//' ) == 0 )
        {
          next;
        }

        if( getClas() eq "training" )
        {
          s/#TRAINING#/  (FOR TRAINING PURPOSES ONLY/g;
        }
        else
        {
          s/#TRAINING#//g;
        }

        if( getHostClass() eq "unclas" )
        {
          s/#ABLE#/disabled/g;
          #CDM use following for testing on NIPR side
          #s/#ABLE#//g;
        }
        else
        {
          s/#ABLE#//g;
        }

        print;
      }
      close( $INS );
    }
    elsif( index( $_, "#FORM_INSERT#" ) >= 0 )
    {
      open( my $INS, "<", "../html/bathy_csv_insert.html_template" ) or die "Can't open ../html/bathy_csv_insert.html_template: $!";
      while( <$INS> )
      {
        if( index( $_, '//' ) == 0 )
        {
          next;
        }
        print;
      }
      close( $INS );
    }
    else
    {
      if( index( $_, '//' ) == 0 )
      {
        next;
      }
      print;
    }
  }

  close( $IN );

  return();

}#End generate_html

sub activity_file
{
  #
  # Use activity file to record web page useage
  #

  #
  # Create activity.log if it isn't there.
  #
  if( ! -e "../dynamic/activity_logs/bathy_csv_activity.log" )
  {
    open( my $USERS, ">", "../dynamic/activity_logs/bathy_csv_activity.log" ) || die "Can't open bathy_csv_activity.log: $!";
    close( $USERS );
    chmod (0664, "../dynamic/activity_logs/bathy_csv_activity.log");
  }

  #
  # Check if this is an accidental resubmital, such as a browser refresh
  #
  open( my $USERS, "<", "../dynamic/activity_logs/bathy_csv_activity.log" ) || die "Can't open bathy_csv__activity.log: $!";

  my @users  = <$USERS>;
  close( $USERS );
  chmod (0664, "../dynamic/activity_logs/bathy_csv__activity.log");
  my $new_user = "$csgn_name $remote_id ob_time $sub_time";

  foreach my $user (@users)
  {
    chomp $user;
    if ($new_user eq $user)
    {
      print "Content-type: text/html; charset=utf-8\n\n";
      print "<!DOCTYPE html><html><head><title>accident</title></head><body>\n";
      print "<h1 style='text-align:center'>";
      print "A REPORT WITH SAME OBS TIME HAS BEEN ACCIDENTLY SUBMITTED";
      print "</h1>";
      print "</body></html>";
      exit;
    }
  }

  #
  # Add new log entry
  #
  # Should wait until another application unlocks activity.log
  #
  ($sec_s, $min_s, $hour_s, $mday_s, $mon_s, $year_s, $wday_s, $yday_s, $isdat_s) = gmtime;

  $year_s = $year_s + 1900;
  $mon_s  = $mon_s +1;
  $yday_s = $yday_s +1;
  $server_receive_time = join("_", $year_s, $mon_s,$mday_s, $hour_s, $min_s, $sec_s);
  $send_dtg = sprintf("%4d%02d%02d%02d%02d%02d",$year_s, $mon_s,$mday_s, $hour_s, $min_s, $sec_s);

  my $log_filename = "bathy_csv_activity.log";
  my $log_file = "../dynamic/activity_logs/$log_filename";

  open( $USERS, ">>", $log_file ) || die "Can't open $log_file: $!";
  flock $USERS, 2;
  print $USERS "$csgn_name $remote_id svr_snd $server_send_time\n";
  print $USERS "$csgn_name $remote_id clt_rcv $client_receive_time\n";
  print $USERS "$csgn_name $remote_id clt_snd $client_send_time\n";
  print $USERS "$csgn_name $remote_id svr_rcv $server_receive_time\n";
  print $USERS "$csgn_name $remote_id ob_time $obs_time\n";
  print $USERS "$csgn_name $remote_id sb_time $sub_time\n";
  print $USERS "--------------------------------------------------\n";
  close( $USERS );
  chmod (0664, "../dynamic/activity_logs/bathy_csv__activity.log");

  return();

}#End activity_file

sub bathy_csv_input
{
#
# Assign web page form input to variables
#
  % month_name = (
  "0"=>"JAN",
  "1"=>"FEB",
  "2"=>"MAR",
  "3"=>"APR",
  "4"=>"MAY",
  "5"=>"JUN",
  "6"=>"JUL",
  "7"=>"AUG",
  "8"=>"SEP",
  "9"=>"OCT",
  "10"=>"NOV",
  "11"=>"DEC",
  );

# Submitter information
  ($observer       = $q->param("observer")) =~ s/[^a-zA-Z]//g;
  ($observer_title = $q->param("observer_title")) =~ s/[^a-zA-Z0-9. ]//g;
# webservices 8 Fast and flexible email validation
  my $expr;
# $expr = '^(([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?))$';
# webservices 9 Email validation which complies with RFC 2822
  $expr = '^(((\"[^\"\f\n\r\t\b]+\")|([\w\!\#\$\%\&\'\*\+\-\~\/\^\`\|\{\}]+(\.[\w\!\#\$\%\&\'\*\+\-\~\/\^\`\|\{\}]+)*))@((\[(((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9])))\])|(((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9])))|((([A-Za-z0-9\-])+\.)+[A-Za-z\-]+)))$';

  my $temp_var = $q->param("email") =~ /$expr/;
  if ( !defined ($temp_var) )
  {
    $email        = "not valid";
  }
  else
  {
    $email        = $q->param("email");
  } 

# ship information
  ($csgn_name      = $q->param("csgn_name")) =~ s/[^a-zA-Z]//g;
  $csgn_name      =~ tr/a-z/A-Z/;               # all characters to uppercase 
  ($ship_name      = $q->param("ship_name")) =~ s/[^a-zA-Z]//g;
  $ship_name      =~ tr/a-z/A-Z/;               # all characters to uppercase
  ($ship_title     = $q->param("ship_title")) =~ s/[^a-zA-Z]//g;
  $ship_title     =~ tr/a-z/A-Z/;               # all characters to uppercase

# time of observation
  ($obs_yr      = $q->param("obs_yr"))  =~ s/[^0-9]//g;
  ($obs_mo      = $q->param("obs_mo"))  =~ s/[^0-9]//g;
  ($obs_day     = $q->param("obs_day")) =~ s/[^0-9]//g;
  ($obs_hr      = $q->param("obs_hr"))  =~ s/[^0-9]//g;
  ($actl_ob_hr  = $q->param("obs_hr"))  =~ s/[^0-9]//g;
  ($obs_min     = $q->param("obs_min")) =~ s/[^0-9]//g;
  ($actl_ob_min = $q->param("obs_min")) =~ s/[^0-9]//g;
  $obs_time    = "${obs_yr}_${obs_mo}_${obs_day}_${obs_hr}_${obs_min}";

# time of submittal
  my $sub_sec;
  my $sub_wday;
  my $sub_yday;
  my $sub_isdat;
  ($sub_sec, $sub_min, $sub_hr, $sub_day, $sub_mo, $sub_yr, $sub_wday, $sub_yday, $sub_isdat) = gmtime;
  $sub_mo = $sub_mo +1;
  $sub_yr = $sub_yr +1900;
  $sub_time    = "${sub_yr}_${sub_mo}_${sub_day}_${sub_hr}_${sub_min}";

# security
  ($clas_type      = $q->param("clas_type")) =~ s/[^UCS]//g;

  if($clas_type eq "S")
  {
    $clas = "secret";
  }
  elsif($clas_type eq "C")
  {
    $clas = "confid";
  }
  else
  {
    $clas = "unclas";
  }

  if($clas_type eq "S" || $clas_type eq "C")
  {
    ($cls_sel        = $q->param("cls_sel")) =~ s/[^123]//g;
    if($cls_sel eq "1")
    {
      ($cls_doc        = $q->param("cls_doc")) =~ s/[^a-zA-Z0-9.-_:]//g;
      $cls_ath        = "";
      $cls_rsn        = "";
    }
    elsif($cls_sel eq "2")
    {
      $cls_doc        = "";
      ($cls_ath        = $q->param("cls_ath")) =~ s/[^a-zA-Z0-9.-_:]//g;
      ($cls_rsn        = $q->param("cls_rsn")) =~ s/[^a-zA-Z0-9.-_:]//g;
    }
    ($dcls_sel       = $q->param("dcls_sel")) =~ s/[^a-zA-Z0-9.-_:]//g;
    if($dcls_sel eq "1")
    {
      ($dcls_tday      = $q->param("dcls_tday")) =~ s/[^0-9]//g;
      $dcls_yr        = "";
      $dcls_mon       = "";
      $dcls_day       = "";
      $dcls_txt       = "";
    }
    elsif($dcls_sel eq "2")
    {
      $dcls_tday      = "";
      ($dcls_yr        = $q->param("dcls_yr")) =~ s/[^0-9]//g;
      ($dcls_mon       = $q->param("dcls_mon")) =~ s/[^0-9]//g;
      ($dcls_day       = $q->param("dcls_day")) =~ s/[^0-9]//g;
      $dcls_txt       = "";
    }
    elsif($dcls_sel eq "3")
    {
      $dcls_tday      = "";
      $dcls_yr        = "";
      $dcls_mon       = "";
      $dcls_day       = "";
      ($dcls_txt       = $q->param("dcls_txt")) =~ s/[^a-zA-Z0-9.-_:]//g;
    }
    ($cls_cvt        = $q->param("cls_cvt")) =~ s/[^a-zA-Z0-9.-_:]//g;
  }
  else
  {
    $dcls_sel       = "";
    $dcls_tday      = "";
    $dcls_yr        = "";
    $dcls_mon       = "";
    $dcls_day       = "";
    $dcls_txt       = "";
    $cls_sel        = "";
    $cls_ath        = "";
    $cls_rsn        = "";
    $cls_doc        = "";
    $cls_cvt        = "";
  }

# initialize
  if ($dcls_sel eq "1")
  {
    if ($dcls_tday ne "")
    {
      my $time_s = time + $dcls_tday * 86400;
      ($dcls_sec, $dcls_min, $dcls_hr, $dcls_day, $dcls_mon, $dcls_yr, $dcls_wday, $dcls_yday, $dcls_isdat) = gmtime($time_s);
      $dcls_mon = $dcls_mon + 1;
      $dcls_yr = $dcls_yr + 1900;
    }
    else
    {
      $dcls_yr  = "";
      $dcls_mon = "";
      $dcls_day = "";
    }
  }
  else
  {
      $dcls_tday = "";
  }


# need actual obs date and time
  ($day_utc  = $q->param("obs_day")) =~ s/[^0-9]//g;
  ($mon_utc  = $q->param("obs_mo")) =~ s/[^0-9]//g;
  ($yr_utc   = $q->param("obs_yr")) =~ s/[^0-9]//g;
  ($yr_utc) = ($yr_utc =~ /(.{1}$)/);
  ($hr_utc   = $q->param("obs_hr")) =~ s/[^0-9]//g;
  ($min_utc  = $q->param("obs_min")) =~ s/[^0-9]//g;

  ($units    = $q->param("units")) =~ s/[^9\/]//g;
  ($lat_d    = $q->param("lat_d")) =~ s/[^0-9]//g;
  ($lat_m    = $q->param("lat_m")) =~ s/[^0-9]//g;
  ($lat_s    = $q->param("lat_s")) =~ s/[^0-9]//g;
  $lat      = $lat_d + $lat_m/60.0 + $lat_s/3600.0;
  ($lon_d    = $q->param("lon_d")) =~ s/[^0-9]//g;
  ($lon_m    = $q->param("lon_m")) =~ s/[^0-9]//g;
  ($lon_s    = $q->param("lon_s")) =~ s/[^0-9]//g;
  $lon      = $lon_d + $lon_m/60.0 + $lon_s/3600.0;
  ($lat_sign = $q->param("lat_sign")) =~ s/[^NS]//g;
  ($lon_sign = $q->param("lon_sign")) =~ s/[^EW]//g;
  if($lat_sign eq "N" && $lon_sign eq "E")
  {
    $quad = "1";
  }

  if($lat_sign eq "N" && $lon_sign eq "W")
  {
    $quad = "7";
  }

  if($lat_sign eq "S" && $lon_sign eq "W")
  {
    $quad = "5";
  }

  if($lat_sign eq "S" && $lon_sign eq "E")
  {
    $quad = "3";
  }

  ($bt_type  = $q->param("bt_type")) =~ s/[^0-9\/]//g;
  ($rcrdr    = $q->param("rcrdr")) =~ s/[^0-9\/]//g;
  ($radio_call = $q->param("csgn_name")) =~ s/[^a-zA-Z]//g;

  ($upload_csv_file =  $q->param("upload_csv_file")) =~ s/[^a-zA-Z0-9.-_\/]//g;

  if($accept_location eq "unk")
  {


  if($upload_csv_file ne "")
  {
    my $buffer = "";
    $upload_csv_header = "";
    $upload_csv_file_out = "";
    $fh = $q->upload( "upload_csv_file" );
    my $data_read = "no";
    my $depth;
    my $temp;

    open( my $FILE, ">", "../dynamic/temp/upload_csv_file.out_$$" ) || die "Can't open ../dynamic/temp/upload_csv_file.out_$$: $!";

    while( read( $fh, $buffer, 1024 ) )
    {
      $buffer =~ tr/.,0-9A-Za-z\/\n\040//dc; # allow only a-z, A-Z, 0-9,
                                             # new line characters, blanks
                                             # commas and periods
      $upload_csv_file_out = join( "", $upload_csv_file_out, $buffer );
    }
    print( $FILE "$upload_csv_file_out" );
    close( $FILE );


    open( $FILE, "<",  "../dynamic/temp/upload_csv_file.out_$$" ) || die "Can't open ../dynamic/temp/upload_csv_file.out_$$: $!";
    my $line_cnt;
    $profile_cnt = 0;
    my $line_out;
    while( $line_out = <$FILE> )
    {
      if((index(lc($line_out), "depth") == -1) && (index(lc($line_out), "temperature") == -1) && ($data_read eq "no"))
      {
        $upload_csv_header = join("", $upload_csv_header, $line_out);
      }
      elsif((index(lc($line_out), "depth") != -1) && (index(lc($line_out), "temperature") != -1) && ($data_read eq "no"))
      {
        $data_read = "yes";
        next;
      }
      else
      {
        ($depth, $temp) = split("\,", $line_out); 
        push(@zz,$depth);
        push(@ttt,$temp);
        $profile_cnt++; 
      }
    }
    close( $FILE );
    unlink ("../dynamic/temp/upload_csv_file.out_$$");

    if( $data_read eq "no" )
    {
      print "Content-type: text/html; charset=utf-8\n\n";
      print "<!DOCTYPE html><html><head><title>missing</title></head><body>\n";
      print "<h1 style='text-align:center'>";
      print $upload_csv_header;
      print "<br>";
      print "UPLOADED CSV MESSAGE FILE IS MISSING \"Depth, Temperature\" line <br> PLEASE RESUBMIT";
      print "</h1>";
      print "</body></html>";
      exit;
    }
  }
  else
  {
    print "Content-type: text/html; charset=utf-8\n\n";
    print "<!DOCTYPE html><html><head><title>missing</title></head><body>\n";
    print "<h1 style='text-align:center'>";
    print $upload_csv_header;
    print "<br>";
    print "UPLOADED CSV MESSAGE FILE IS MISSING <br> PLEASE RESUBMIT";
    print "</h1>";
    print "</body></html>";
    exit;
  }

  }


  if($accept_location eq "yes")
  {
    ($upload_csv_header = $q->param("upload_csv_header")) =~ s/[^a-zA-Z0-9.,-_\/\n]//g;
    ($profile_cnt = $q->param("profile_cnt")) =~ s/[^0-9\/]//g;
    my $i;
    for ($i = 0; $i < $profile_cnt; $i++)
    {
      ($zz[$i] = $q->param("zz${i}")) =~ s/[^0-9.]//g;
      ($ttt[$i] = $q->param("tt${i}")) =~ s/[^0-9.]//g;
    }

  }

  return();

}#End bathy_csv_input

sub diag_output
{
  use lib qw(.);
  use sys_info qw(getDevLevel getHostClass getAppName);

#
# Return diagnostic display of form input after submission
#

print "Content-type: text/html; charset=utf-8\n\n";

  if($results eq "submit")
  {
    print <<EOF;
<!DOCTYPE html><html> <head> <title>submission complete</title> </head> <body>
<table style="margin:auto; text-align:center;">
<tr>
<td style="text-align:center">
<br><a href=\"javascript:window.open('','_self').close();window.open('','_long_form').close()\">close windows</a>
<h3>
$title Submission Complete
<br>
EOF

    print scalar (gmtime);
    print "<br> remote id: $remote_id";
    print "<br> web browser type: $browser_type";
    print "</h3>";
  }

  if($results eq "message")
  {
    print <<EOF;
<!DOCTYPE html><html> <head> <title>encode message</title> </head> <body>
<table style="margin:auto; text-align:center;">
<tr>
<td style="text-align:center">
<br> <a href=\"javascript:window.open('','_self').close();\">close window</a>
<h1>
<br> $title Encoded Message
</h1>
<br>
</td>
</tr>
<tr>
EOF
  }

  if($results eq "full")
  {
    print <<EOF;
<!DOCTYPE html><html> <head> <title>detail display</title> </head> <body>
<table style="margin:auto; text-align:center;">
<tr>
<td style="text-align:center">
<br>
<a href=\"javascript:window.open('','_self').close();\">close window</a>
<h1>
$title Detail Display
</h1>
<br>
<table>
<tr>
<td style='text-align:left; padding:5px; border:1px solid black'>
EOF

#  printf ("%-25s <I>%s</I><br>",'server_send_time',$server_send_time);

    print "<div style='text-align:left'>";
    print "<pre>\n";

    print "<b>Uploaded Header</b>\n";
#   printf ("%-300s\n",$upload_csv_header);
    print $upload_csv_header;

    print "\n";
    print "<b>Point of Origin</b>\n";
    printf ("%-25s <I>%-13s</I>\n",'observer title',$observer_title);
    printf ("%-25s <I>%-13s</I>\n",'observer',$observer);
    printf ("%-25s <I>%-13s</I>\n",'email',$email);
    printf ("%-25s <I>%-13s</I>\n",'call sign',$csgn_name);
    printf ("%-25s <I>%-13s</I>\n",'ship title',$ship_title);
    printf ("%-25s <I>%-13s</I>\n",'ship name',$ship_name);

    print "\n";
    print "<b>Time of Observation</b>\n";
    printf ("%-25s <I>%-13s</I>\n",'year',$obs_yr);
    printf ("%-25s <I>%-13s</I>\n",'month',$obs_mo);
    printf ("%-25s <I>%-13s</I>\n",'day',$obs_day);
    printf ("%-25s <I>%-13s</I>\n",'hour',$obs_hr);
    printf ("%-25s <I>%-13s</I>\n",'minute',$obs_min);

    print "\n";
    print "<b>Time of Submission</b>\n";
    printf ("%-20s <I>%-13s</I>\n",'year',$sub_yr);
    printf ("%-20s <I>%-13s</I>\n",'month',$sub_mo);
    printf ("%-20s <I>%-13s</I>\n",'day',$sub_day);
    printf ("%-20s <I>%-13s</I>\n",'hour',$sub_hr);
    printf ("%-20s <I>%-13s</I>\n",'minute',$sub_min);

    print "\n";
    print "<b>Location</b>\n";
    printf ("%-30s <I>%-13s</I>\n",'lat sign',$lat_sign);
    printf ("%-30s <I>%-13s</I>\n",'lat degr',$lat_d);
    printf ("%-30s <I>%-13s</I>\n",'lat min',$lat_m);
    printf ("%-30s <I>%-13s</I>\n",'lat sec',$lat_s);
    printf ("%-30s <I>%-13s</I>\n",'lat    ',$lat);
    printf ("%-30s <I>%-13s</I>\n",'lon sign',$lon_sign);
    printf ("%-30s <I>%-13s</I>\n",'lon degr',$lon_d);
    printf ("%-30s <I>%-13s</I>\n",'lon min',$lon_m);
    printf ("%-30s <I>%-13s</I>\n",'lon sec',$lon_s);
    printf ("%-30s <I>%-13s</I>\n",'lon    ',$lon);

    print "\n";
    print "<b>Message</b>\n";
    printf ("%-30s <I>%-13s</I>\n",'day (YY)',$day_utc);
    printf ("%-30s <I>%-13s</I>\n",'month (MM)',$mon_utc);
    printf ("%-30s <I>%-13s</I>\n",'year (J)',$yr_utc);
    printf ("%-30s <I>%-13s</I>\n",'hour (GG)',$hr_utc);
    printf ("%-30s <I>%-13s</I>\n",'minute (gg)',$min_utc);
    printf ("%-30s <I>%-13s</I>\n",'units (u)',$units);
    printf ("%-30s <I>%-13s</I>\n",'quad (Qc)',$quad);
    printf ("%-30s <I>%-13s</I>\n",'latitude (LaLaLaLaLa)',$lat);
    printf ("%-30s <I>%-13s</I>\n",'longitude (LoLoLoLoLoLo)',$lon);
    printf ("%-30s <I>%-13s</I>\n",'bt type (IxIxIx)',$bt_type);
    printf ("%-30s <I>%-13s</I>\n",'recorder (XrXr)',$rcrdr);
    printf ("%-30s <I>%-13s</I>\n",'radio call sign (RADIO)',$radio_call);
    print "\n";
    if($units eq "/")
    {
      printf ("zz - meters / tt - C\n");
    }
    else
    {
      printf ("zz - feet / tt - F\n");
    }

    my $i;
    for ($i = 0; $i < $profile_cnt; $i++)
    {
      printf ("%-4s<I>%4i</I>  %-4s<I>%5.1f</I>\n","zz${i}",$zz[$i],"tt${i}",$ttt[$i]);
    }

    print "<b>Security Information</b>\n";
    printf ("%-25s <I>%-20s</I>\n",'classification type',$clas_type);
    printf ("%-25s <I>%-20s</I>\n",'class authority',$cls_ath);
    printf ("%-25s <I>%-20s</I>\n",'reason',$cls_rsn);
    printf ("%-25s <I>%-20s</I>\n",'derived from',$cls_doc);
    printf ("%-25s <I>%-20s</I>\n",'declas days',$dcls_tday);
    printf ("%-25s <I>%-20s</I>\n",'declas year',$dcls_yr);
    printf ("%-25s <I>%-20s</I>\n",'declas month',$dcls_mon);
    printf ("%-25s <I>%-20s</I>\n",'declas day',$dcls_day);
    printf ("%-25s <I>%-20s</I>\n",'declas text',$dcls_txt);
    printf ("%-25s <I>%-20s</I>\n",'caveats',$cls_cvt);
    print "</pre>\n";
    print "</div>\n";

    print <<EOF;
</tr>
</table>
</td>
</tr>
EOF

  }

  if($results eq "submit" || $results eq "full")
  {

#+++++++++++++++++++++++++++++ WMO REPORT ++++++++++++++++++++++++++++
    print <<EOF;
<tr>
<td style='text-align:center;'>
<table style="margin:auto; text-align:center;">
<tr>
EOF

  }

  if($results eq "message" || $results eq "submit" || $results eq "full")
  {

    print "<td style='text-align:left; padding:5px; border:1px solid black'>";
    print "<b>WMO encoded message</b>\n";
    print "<pre>\n";
    print "$section_1\n";
    print "$section_2 ";
    print "$section_4\n";
    print "</pre>\n";
    print "</td>";

  }

  if($results eq "submit" || $results eq "full")
  {

    print <<EOF;
</tr>
</table>
</td>
</tr>
</table>
</body>
</html>
EOF

  }

  if($results eq "message")
  {

    print <<EOF;
</tr>
</table>
</body>
</html>
EOF

  }

  return();

}#End diag_output

sub process_data
{
  #
  # Assign web page form input to variables
  #
  % month_name = (
  "1"=>"Jan",
  "2"=>"Feb",
  "3"=>"Mar",
  "4"=>"Apr",
  "5"=>"May",
  "6"=>"Jun",
  "7"=>"Jul",
  "8"=>"Aug",
  "9"=>"Sep",
  "10"=>"Oct",
  "11"=>"Nov",
  "12"=>"Dec",
  );

  #
  # Process data and place into appropriate files.
  #
  $obs_dtg = sprintf("%4d%02d%02d%02d%02d%02d",$obs_yr, $obs_mo, $obs_day, $obs_hr, $obs_min, 00);
  $sub_dtg = sprintf("%4d%02d%02d%02d%02d%02d",$sub_yr, $sub_mo, $sub_day, $sub_hr, $sub_min, 00);


  #
  # create WMO enocoded message
  #


  # section 1

  # MiMiMjMj
  $section_1 = "JJVV";

  # YYMMJ
  my $YY = sprintf("%02i",$day_utc); 
  my $MM = sprintf("%02i",$mon_utc);
  my $J = $yr_utc;
  my $group = join("", $YY, $MM, $J);
  $section_1 = join(" ", $section_1, $group);

  # GGggu
  my $GG = sprintf("%02i",$hr_utc);
  my $gg = sprintf("%02i",$min_utc);
  #$group = join("", $GG, $gg, $units);
  $group = join("", $GG, $gg, "/");
  $section_1 = join(" ", $section_1, $group);

  # QcLaLaLaLaLa
  my $LaLaLaLaLa = sprintf("%05i",$lat*1000);
  $group = join("", $quad, $LaLaLaLaLa);
  $section_1 = join(" ", $section_1, $group);

  # LoLoLoLoLoLo
  my $LoLoLoLoLoLo = sprintf("%06i",$lon*1000);
  $group = join("", $LoLoLoLoLoLo);
  $section_1 = join(" ", $section_1, $group);

  # section 2

  # 8888k1
  $section_2 = "88888";

  # IxIxIxXrXr
  my $IxIxIx;
  if($bt_type ne "///")
  {
    $IxIxIx = sprintf("%03i",$bt_type);
  }
  else
  {
    $IxIxIx = "///";
  }
  my $XrXr;
  if($rcrdr ne "//")
  {
    $XrXr = sprintf("%02i",$rcrdr);
  }
  else
  {
    $XrXr = "//";
  }
  $group = join("", $IxIxIx, $XrXr);
  $section_2 = join(" ", $section_2, $group);

  my $i;
  my $ii = 0;
  my $ii_r;
  my $zz_temp_t = "00";
  my $zz_temp;
  my $zz_f;
  my $zz_h = 0;
  my $zz_r;
  my $ttt_temp;
  my $ttt_f;
  my $ttt_th;
  for ($i = 0; $i < $profile_cnt; $i++)
  {
    if($units eq "9")
    {
      $zz_f = sprintf("%02.0f", $zz[$i] * .305);
      $ttt_f = sprintf("%04.1f", ($ttt[$i] - 32.0) / 1.8);
    }
    else
    {
      $zz_f = $zz[$i];
      $ttt_f = sprintf("%04.1f", $ttt[$i]);
    }

    $zz_r = $zz_f%100;
    $zz_h = $zz_f/100;
    $zz_temp = sprintf("%02i",$zz_h);
    if($zz_temp != $zz_temp_t)
    {
      $zz_temp_t = $zz_temp;
      $group = join("", "999", $zz_temp);
      $ii_r = $ii%6;
      if($ii_r == 5)
      {
        $section_2 = join("", $section_2, "\n");
        $section_2 = join("", $section_2, $group);
      }
      else
      {
        $section_2 = join(" ", $section_2, $group);
      }
      $ii = $ii + 1;
    }

    $zz_temp = sprintf("%02i",$zz_r);
    $ttt_temp = sprintf("%03i",$ttt_f*10);
    $group = join("", $zz_temp, $ttt_temp);
    $ii_r = $ii%6;
    if($ii_r == 5)
    {
      $section_2 = join("", $section_2, "\n");
      $section_2 = join("", $section_2, $group);
    }
    else
    {
      $section_2 = join(" ", $section_2, $group);
    }
    $ii = $ii + 1;
  }

  # section 3
  $section_3 = "";

  # section 4
  $section_4 = $csgn_name;

  if($results eq "submit")
  {
  #
  # write out values into a diagnostic file
  #

    my $unq_num;
    $unq_num = $$;
    $unq_num = sprintf( "%010d", $unq_num );


    my $file_name = "encode_bathy_csv.$csgn_name.$sub_dtg.$unq_num" =~ /^([\w.]+)$/;
    $file_name = $1;
    my $output_file_name  = "../dynamic/archive/$clas/$file_name";
    open( my $DIAG, ">", $output_file_name ) or die "Can't open diagnostic file, $output_file_name: $!";

    #
    # Set up an encoded file to go in the encoded subdirectory
    #
    my $sec_pre;
    $sec_pre = "j";
    #if($clas_type eq "S" || $clas_type eq "C")
    #{
    #  $sec_pre = "b";
    #}
    #else
    #{
    #  $sec_pre = "e";
    #}

    my $yday_3 = sprintf("%03d", $yday_s);
    my $encode_file_name = "${sec_pre}${yday_3}jo${unq_num}r";
    my $output_encode_file_name  = "../dynamic/encoded/$clas/$encode_file_name";
    open( my $ENCODE, ">",  $output_encode_file_name ) or die "Can't open diagnostic file, $output_encode_file_name: $!";

    my $product_name = "US058OMET-TXTsl1";
    $product_name = join(".", $product_name, $send_dtg);
    $product_name = join("_", $product_name, $encode_file_name);

    $dps_hdr = "BEGIN";
    $dps_hdr = join("\n", $dps_hdr, $csgn_name);
    $dps_hdr = join("\n", $dps_hdr, $product_name);
    if($clas_type eq "U")
    {
      $dps_hdr = join("\n", $dps_hdr, "JXOBSU");
    }
    elsif($clas_type eq "C")
    {
      $dps_hdr = join("\n", $dps_hdr, "JXOBSC");
    }
    else
    {
      $dps_hdr = join("\n", $dps_hdr, "JXOBSS");
    }

    $dps_hdr = join("\n", $dps_hdr, "R");
    $dps_hdr = join("\n", $dps_hdr, $clas_type);
    $dps_hdr = join("\n", $dps_hdr, "000");
    $dps_hdr = join("\n", $dps_hdr, "000");
    $dps_hdr = join("\n", $dps_hdr, "0000");
    $dps_hdr = join("\n", $dps_hdr, $send_dtg);
    if($cls_cvt eq "")
    {
      $dps_hdr = join("\n", $dps_hdr, "NONE");
    }
    else
    {
      $dps_hdr = join("\n", $dps_hdr, $cls_cvt);
    }

    if($clas_type eq "S" || $clas_type eq "C")
    {
      if($cls_sel == 1)
      {
        $dps_hdr = join("\n", $dps_hdr, "DERIVED FROM:");
        $dps_hdr = join(" ", $dps_hdr, $cls_doc);
      }
      else
      {
        $dps_hdr = join("\n", $dps_hdr, "CLASSIFIED BY:");
        $dps_hdr = join(" ", $dps_hdr, $cls_ath);
        $dps_hdr = join("\n", $dps_hdr, "REASON:");
        $dps_hdr = join(" ", $dps_hdr, $cls_rsn);
      }

      if($dcls_sel eq "3")
      {
        $dcls_inst = $dcls_txt;
      }
      else
      {
        $dcls_inst = sprintf("%02d %s %02d", $dcls_day, $month_name{int("$dcls_mon")}, $dcls_yr-2000);
      }
      $dps_hdr = join("\n", $dps_hdr, "DECLASSIFY ON:");
      $dps_hdr = join(" ", $dps_hdr, $dcls_inst);
    }
    $dps_hdr = join("\n", $dps_hdr, "SHIPNAME:");
    $dps_hdr = join(" ", $dps_hdr, $ship_name);
    $dps_hdr = join("\n", $dps_hdr, "END");

    print( $DIAG "$dps_hdr\n" );
    print( $ENCODE "$dps_hdr\n" );
    print( $DIAG "$section_1\n" );
    print( $ENCODE "$section_1\n" );
    print( $DIAG "$section_2" );
    print( $ENCODE "$section_2" );
    print( $DIAG " $section_4" );
    print( $ENCODE " $section_4" );
    print( $DIAG "=" );
    print( $ENCODE "=" );

    close( $DIAG );
    chmod (0664, "$output_file_name");
    close( $ENCODE );
    chmod (0664, "$output_encode_file_name");
  }

  return();

}#End process_data

sub bathy_csv_output
{
  #
  # Place input data into a file for archiving
  #

  $upload_csv_header =~ s/[^a-zA-Z0-9.,-_\/\n]//g;

  my $unq_num;
  $unq_num = $$;
  $unq_num = sprintf( "%010d", $unq_num );

  my $file_name = "raw_bathy_csv.$csgn_name.$sub_dtg.$unq_num" =~ /^([\w.]+)$/;
  $file_name = $1;

  my $output_file_name  = "../dynamic/archive/$clas/$file_name";

  open( my $FILE, ">", $output_file_name ) or die "Can't open $output_file_name: $!";

  print $FILE "------ Upload Header -----\n";
  print $FILE "$upload_csv_header\n";
  print $FILE "\n----- Point of Origin ----\n";
  print $FILE "observer title        $observer_title\n";
  print $FILE "observer              $observer\n";
  print $FILE "email                 $email\n";
  print $FILE "csgn_name             $csgn_name\n";
  print $FILE "ship_title            $ship_title\n";
  print $FILE "ship_name             $ship_name\n";
  print $FILE "\n-- Time of Observationn ---\n";
  print $FILE "obs_yr                $obs_yr\n";
  print $FILE "obs_mo                $obs_mo\n";
  print $FILE "obs_day               $obs_day\n";
  print $FILE "obs_hr                $obs_hr\n";
  print $FILE "obs_min               $obs_min\n";
  print $FILE "\n-- Time of Submission ----\n";
  print $FILE "year                  $sub_yr\n";
  print $FILE "month                 $sub_mo\n";
  print $FILE "day                   $sub_day\n";
  print $FILE "hour                  $sub_hr\n";
  print $FILE "minute                $sub_min\n";
  print $FILE "\n------- Security --------\n";
  print $FILE "clas_type             $clas_type\n";
  print $FILE "cls_ath               $cls_ath\n";
  print $FILE "cls_rsn               $cls_rsn\n";
  print $FILE "cls_doc               $cls_doc\n";
  print $FILE "cls_cvt               $cls_cvt\n";
  print $FILE "dcls_tday             $dcls_tday\n";
  print $FILE "dcls_yr               $dcls_yr\n";
  print $FILE "dcls_mon              $dcls_mon\n";
  print $FILE "dcls_day              $dcls_day\n";
  print $FILE "dcls_txt              $dcls_txt\n";
  print $FILE "\n------Transmission -------\n";
  print $FILE "server_send_time      $server_send_time\n";
  print $FILE "client_receive_time   $client_receive_time\n";
  print $FILE "client_send_time      $client_send_time\n";
  print $FILE "server_receive_time   $server_receive_time\n";
  print $FILE "\n--------- Location ---------\n";
  print $FILE "lat_sign              $lat_sign\n";
  print $FILE "lat_d                 $lat_d\n";
  print $FILE "lat_m                 $lat_m\n";
  print $FILE "lat_s                 $lat_s\n";
  print $FILE "lat                   $lat\n";
  print $FILE "lon_sign              $lon_sign\n";
  print $FILE "lon_d                 $lon_d\n";
  print $FILE "lon_m                 $lon_m\n";
  print $FILE "lon_s                 $lon_s\n";
  print $FILE "lon                   $lon\n";
  print $FILE "\n--------- Message ----------\n";
  print $FILE "yr (J)                $yr_utc\n";
  print $FILE "mon (MM)              $mon_utc\n";
  print $FILE "day (YY)              $day_utc\n";
  print $FILE "hour (GG)             $hr_utc\n";
  print $FILE "units (u)             $units\n";
  print $FILE "quad (Qc)             $quad\n";
  print $FILE "lat LaLaLaLaLa        $lat\n";
  print $FILE "lon LoLoLoLoLoLo      $lon\n";
  print $FILE "bt type (IxIxIx)      $bt_type\n";
  print $FILE "recorder (XrXr)       $rcrdr\n";
  print $FILE "\n--------- Profile ----------\n";

  if($units eq "/")
  {
    print $FILE "zz - meters / tt - C\n";
  }
  else
  {
  print $FILE "zz - feet / tt - F\n";
  }

  my $i;
  for ($i = 0; $i < $profile_cnt; $i++)
  {
    print $FILE "zz${i} $zz[$i]  ttt${i} $ttt[$i]\n";
  }

  close( $FILE );
  chmod (0664, "$output_file_name");

  return();

}#End bathy_csv_output

sub round_date
{
  # need actual obs date and time
  if($obs_min < 30)
  {
    $new_obs_yr = $obs_yr;
    $new_obs_mo = $obs_mo;
    $new_obs_day = $obs_day;
    $new_obs_hr = $obs_hr;
  }
  else
  {
    if($obs_hr < 23)
    {
      $new_obs_yr = $obs_yr;
      $new_obs_mo = $obs_mo;
      $new_obs_day = $obs_day;
      $new_obs_hr = $obs_hr + 1;
    }
    else
    {
      $new_obs_hr = 0;
      &dat2jul();
      $obs_jul = $obs_jul + 1;
      &jul2dat();
    } 
  }

  return();

}#End round_date

sub jul2dat
{
  my $year = $obs_yr;
  my $julday = $obs_jul;
  my $month = 0;
  my $done = 0;
  my $daysofmth;
  my $year_add = 0;
  
  while($done != 1)
  {
    $month = $month + 1;
  
    if($month == 1 || $month == 3 || $month == 5 || $month == 7 || $month == 8 || $month == 10 || $month == 12)
    {
      $daysofmth = 31;
    }
    elsif($month == 2)
    {
      if(($year %= 100) == 0 && ($year %= 400) == 0)
      {
        $daysofmth = 29;
      }
      elsif(($year %= 100) == 0 && ($year %= 4) == 0)
      {
        $daysofmth = 29;
      }
      else
      {
        $daysofmth = 28;
      }
    }
    elsif($month == 4 || $month == 6 || $month == 9 || $month == 10)
    {
      $daysofmth = 30;
    }
  
    $julday = $julday - $daysofmth;
    if($julday < 0)
    {
      $done = 1;
      $julday = $daysofmth + $julday;
    }
    elsif($julday == 0)
    {
      $done = 1;
      $julday = $daysofmth;
    }

    if($month == 12)
    {
      $year = $year + 1;
      $julday = $julday - 31;
      $month = 0;
    }
  }
  $new_obs_yr = $year;
  $new_obs_mo = $month;
  $new_obs_day = $julday;

  return();

}#End jul2dat

sub dat2jul
{
  my $daysofmth = 0;

  if($obs_mo > 1)
  {
    $daysofmth = 31;
  }

  if($obs_mo > 2)
  {
    if(($obs_yr %= 100) == 0 && ($obs_yr %= 400) == 0)
    {
      $daysofmth = $daysofmth + 29;
    }
    elsif(($obs_yr %= 100) == 0 && ($obs_yr %= 4) == 0)
    {
      $daysofmth = $daysofmth + 29;
    }
    else
    {
      $daysofmth = $daysofmth + 28;
    }
  }

  if($obs_mo > 3)
  {
    $daysofmth = $daysofmth + 31;
  }

  if($obs_mo > 4)
  {
    $daysofmth = $daysofmth + 30;
  }

  if($obs_mo > 5)
  {
    $daysofmth = $daysofmth + 31;
  }

  if($obs_mo > 6)
  {
    $daysofmth = $daysofmth + 30;
  }

  if($obs_mo > 7)
  {
    $daysofmth = $daysofmth + 31;
  }

  if($obs_mo > 8)
  {
    $daysofmth = $daysofmth + 31;
  }

  if($obs_mo > 9)
  {
    $daysofmth = $daysofmth + 30;
  }

  if($obs_mo > 10)
  {
    $daysofmth = $daysofmth + 31;
  }

  if($obs_mo > 11)
  {
    $daysofmth = $daysofmth + 30;

  }
  $obs_jul = $daysofmth + $obs_day;

  return();

}#End dat2jul

#=============================== End Functions ===========================

sub main
{
  $title = shift();
  $title =~ s/[^a-zA-Z' ]//g;

  # setup web directory.  
  my @str_array = split( "\/", $ENV{SCRIPT_NAME} );
  $sub_dir = $str_array[1];
  $web_dir = "$ENV{SERVER_NAME}/$sub_dir";

  #
  # form introduction
  #
  $bathy_csv_intro="Bathy Excel CSV Submission";
  $bathy_csv_explanation="Submit the Excel spread sheet as an CSV file.";

  #
  # Determine remote name or address
  #
  $remote_id = $ENV{REMOTE_HOST} || $ENV{REMOTE_ADDR};

  #
  # Determine user's web browser
  #
  $browser_type = $ENV{HTTP_USER_AGENT};

  #
  # Setup object-oriented CGI
  #
  $q = new CGI;

  #============================= Begin main script ===============================

  #
  # Process form output if present
  #
  if ($q->param())
  {
    $results = $q->param("results");
    if ( !defined ($results) )
    {
      print "Content-type: text/html; charset=utf-8\n\n";
      print "<!DOCTYPE html><html><head><title>IMPROPER SUBMISSION</title></head><body>\n";
      print "<h1 style='text-align:center'>";
      print "IMPROPER SUBMISSION";
      print "</h1>";
      print "</body></html>";
      exit;
    }
    $results =~ s/[^a-zA-Z_]//g;
    ($accept_location = $q->param("accept_location")) =~ s/[^a-zA-Z_]//g;

    #
    # Process form output if present
    #
    if($results eq "submit" && $accept_location eq "no")
    {
      &redo_location_mess();
      &cleanup();
      exit;
    }

    ($server_send_time = $q->param("server_send_time")) =~ s/[^0-9_]//g;
    ($client_receive_time = $q->param("client_receive_time")) =~ s/[^0-9_]//g;
    ($client_send_time = $q->param("client_send_time")) =~ s/[^0-9_]//g;
    ($submit_type = $q->param("submit_type")) =~ s/[^a-zA-Z_]//g;

    &bathy_csv_input();
    if($results eq "submit" && $accept_location eq "unk")
    {
      &check_location();
    }
    elsif($results eq "submit" && $accept_location eq "yes")
    {
      &activity_file();
      &process_data();
      &diag_output();
      &bathy_csv_output();
      &cleanup();
    }
    elsif($results eq "message")
    {
      &process_data();
      &diag_output();
    }
    elsif($results eq "full")
    {
      &process_data();
      &diag_output();
    }
  }
  else
  {
      #
      # Generate html form web page
      # 
      &generate_html();
  }

  return();

}#End main

1;
