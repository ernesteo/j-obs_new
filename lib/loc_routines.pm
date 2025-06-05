#!/usr/bin/perl -w

package loc_routines;

use warnings;
use strict;
use lib qw(/fnmoc/web/webservices/apache/app/common/lib);
use POSIX qw( uname );


#
# ======================= setup =====================
#

sub setup
{
    #
    # Setup Pearl CGI
    #
    use lib "/fnmoc/u/curr/lib/perllib";
    use CGI;
    # remove before promotion
    #use CGI::Carp "fatalsToBrowser";

    return();

}#End setup


#
# ===================== initialize ==================
#

sub initialize
{

    # subroutine arguments
    use vars qw($title $data_type);

    # bookkeeping variables
    use vars qw($sub_dir $web_dir $remote_id $browser_type $q);

    # values that are from web form input
        
    # Data process method

    # point of origin
    use vars qw($observer_title $observer $email $csgn_name $ship_title $ship_name);

    # time of submission
    use vars qw($sub_yr $sub_mo $sub_day $sub_hr $sub_min);

    # security information
    use vars qw($clas_type $cls_sel $cls_cvt $cls_ath $cls_rsn $cls_doc
         $dcls_sel $dcls_yr $dcls_mon $dcls_day $dcls_tday $dcls_txt);

    # values that are determined internally and sent to web page
    use vars qw($server_send_time $client_receive_time $client_send_time $submit_type $accept_location);

    # values that are determined internally
    use vars qw($sec_s $min_s $hour_s $mday_s $mon_s $year_s $wday_s $yday_s $isdat_s
         $remote_id $clas
         $q $fh
         $sub_dtg
         $dcls_sec $dcls_min $dcls_hr $dcls_wday $dcls_yday $dcls_isdat $dcls_inst
         $server_receive_time
         $obs_yr $obs_mo $obs_day $obs_hr $obs_min
         $actl_ob_hr $actl_ob_min
         $dps_hdr $send_dtg
         $sub_time
         $lat $lon
         $oct $Q $quad $stn_ht $LaLaLa $LoLoLo $group $section_m);

    use vars qw($OUTPUT);

    use vars qw($ERROR);

    use vars qw($lat_sign $lon_sign);

    use vars qw($shp_loc_file);

    return();

}#End initialize

sub cleanup
{
  my $id_num;
  ( $id_num = $q->param("id_num") ) =~ s/[^0-9]//g;

  if( $id_num =~ /^([-\@\w.]+)$/ )
  {
    $id_num = $1; # $data now untainted
  }
  else
  {
    die "Bad data in '$id_num'"; # log this somewhere
  }

  if( -e "../dynamic/temp/location_check_plot_${id_num}.png" )
  {
      unlink( "../dynamic/temp/location_check_plot_${id_num}.png" ) or warn "Failed to delete '../dynamic/temp/location_check_plot_${id_num}.png': $!";
  }

  return();

}#End cleanup



sub generate_html
{
    #
    # Create the html file and send to client
    #
    use lib ".";
    use sys_info qw(getDevLevel getHostClass getAppName);
    use web_routines qw(getClasBnr getClas);

    #
    # Create the html file and send to client
    #
    print "Content-type: text/html; charset=utf-8\n\n";

    open( my $IN, "<", "../html/shp_loc_form.html_template") or die "Can't open ../html/shp_loc_form.html_template: $!";

    #
    # Need to parse the including file and set the value of server_send_time to a
    # unique value. This could be YYYYMMDDHHMMSS.  This value would be saved
    # in ain id  log file along with the ship's call sign and possibly the obs time.
    # To guard against diplicate resubission through the use of the browser's
    # refresh, the log file would be checked.
    #
    ( my $sec, my $min, my $hour, my $mday, my $mon, my $year, my $wday, my $yday, my $isdat ) = gmtime;

    use vars qw($form_intro);
    use vars qw($clas_banner);

    $year = $year + 1900;
    $mon  = $mon +1;

    my $date_time = join ("_",$year, $mon, $mday, $hour, $min, $sec);

    $form_intro="Submit ship location";

    $clas_banner = getClasBnr();

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
      s/#DATA_TYPE#/$data_type/g;
      s/#FORM_INTRO#/$form_intro/g;
      s/#FORM_STAT#/$date_time/g;
      s/#SUBMIT_TYPE#/loc/g;
      s/#CLAS_BANNER#/$clas_banner/g;

      if( getHostClass() eq "secret" )
      {
        s/#CLAS_LABEL#/clas/g;
      }
      else
      {
        s/#CLAS_LABEL#/unclas/g;
      }

      if( index( $_,"#COL_INSERT#" ) >= 0 )
      {
         open( my $INS, "<", "../html/color_insert.html_template" ) or die "Can't opne ../html/color_insert.html_template: $!";

         while( <$INS> )
         {
           if(index($_,'//') == 0)
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
        open( my $INS, "<", "../html/time_insert.html_template" ) or die "Can't open ../html/time_insert.html_template: $!";

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
      elsif( index( $_, "#LOC_INSERT#" ) >= 0 )
      {
        open( my $INS, "<", "../html/location_insert.html_template" ) or die "../html/location_insert.html_template: $!";

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
            # CDM use following for testing on NIPR side
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
  # Create activity log if it isn't there.
  #
  if( ! -e "../dynamic/activity_logs/${data_type}_activity.log" )
  {
    open( my $USERS, ">", "../dynamic/activity_logs/${data_type}_activity.log" ) || die "Can't open ${data_type}_activity.log: $!";
    close( $USERS );
    chmod( 0664, "../dynamic/activity_logs/${data_type}_activity.log" );
  }

  #
  # Check if this is an accidental resubmital from a browser refresh
  #
  open( my $USERS, "<",  "../dynamic/activity_logs/${data_type}_activity.log" ) || die "Can't open ${data_type}_activity.log: $!";

  my @users = <$USERS>;
  close( $USERS );
  chmod( 0664, "../dynamic/activity_logs/${data_type}_activity.log" );
  my $new_user = "$csgn_name $remote_id ob_time $sub_time";

  foreach my $user (@users)
  {
    chomp $user;
    if( $new_user eq $user )
    {
      print "Content-type: text/html; charset=utf-8\n\n";
      print "<!DOCTYPE html><html><head><title>accident</title></head><body>\n";
      print "<h1 style='text-align:center;'>";
      print "A REPORT WITH SAME OBS TIME HAS BEEN ACCIDENTLY SUBMITTED";
      print "</h1>";
      print "</body></html>";
      exit;
    }
  }


  #
  # Add new log entry
  #
  # Should wait until another application unlocks activity log
  #
  ( $sec_s, $min_s, $hour_s, $mday_s, $mon_s, $year_s, $wday_s, $yday_s, $isdat_s ) = gmtime;

  $year_s = $year_s + 1900;
  $mon_s  = $mon_s + 1;
  $yday_s  = $yday_s + 1;
  $server_receive_time = join("_", $year_s, $mon_s, $mday_s, $hour_s, $min_s, $sec_s);
  $send_dtg = sprintf("%4d%02d%02d%02d%02d%02d",$year_s, $mon_s,$mday_s, $hour_s, $min_s, $sec_s);

  my $log_filename = "${data_type}_activity.log";
  my $log_file = "../dynamic/activity_logs/$log_filename";

  open( $USERS, ">>",  $log_file ) || die "Can't open $log_file: $!";
  flock $USERS, 2;
  print $USERS "$csgn_name $remote_id svr_snd $server_send_time\n";
  print $USERS "$csgn_name $remote_id clt_rcv $client_receive_time\n";
  print $USERS "$csgn_name $remote_id clt_snd $client_send_time\n";
  print $USERS "$csgn_name $remote_id svr_rcv $server_receive_time\n";
  print $USERS "$csgn_name $remote_id sb_time $sub_time\n";
  print $USERS "--------------------------------------------------\n";
  close( $USERS );
  chmod( 0664, "../dynamic/activity_logs/${data_type}_activity.log" );

  return();

}#End activity_file

sub form_input
{
  #
  # Assign web page form input to variables
  #

  my % month_name = (
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
  ($observer       = $q->param("observer")) =~ s/[^a-zA-Z ]//g;
  ($observer_title = $q->param("observer_title")) =~ s/[^a-zA-Z0-9. ]//g;
  # webservices 8 Fast and flexible email validation
  my $expr;
  #$expr = '^(([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?))$';
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
  ($ship_name      = $q->param("ship_name")) =~ s/[^a-zA-Z ]//g;
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

  # ship location
  ($lat               = $q->param("lat")) =~ s/[^0-9.-]//g;
  ($lon               = $q->param("lon")) =~ s/[^0-9.-]//g;
  ($lat_sign          = $q->param("lat_sign")) =~ s/[^NS]//g;
  ($lon_sign          = $q->param("lon_sign")) =~ s/[^EW]//g;
  if(index($lat,'.') == -1)
  {
    $lat = "$lat.";
  }
  if(index($lon,'.') == -1)
  {
    $lon = "$lon.";
  }
  if($lat_sign eq "S")
  {
    $lat = "-$lat";
  } 
  if($lon_sign eq "W")
  {
    $lon = "-$lon";
  } 

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

  # time of submittal
  my $sub_sec;
  my $sub_wday;
  my $sub_yday;
  my $sub_isdat;
  ($sub_sec, $sub_min, $sub_hr, $sub_day, $sub_mo, $sub_yr, $sub_wday, $sub_yday, $sub_isdat) = gmtime;
  $sub_mo = $sub_mo +1;
  $sub_yr = $sub_yr +1900;
  $sub_time    = "${sub_yr}_${sub_mo}_${sub_day}_${sub_hr}_${sub_min}";

  return();

}#End form_input

sub redo_location_mess
{
  print "Content-type: text/html; charset=utf-8\n\n";
  print "<!DOCTYPE html><html><head><title>resubmit</title></head><body>\n";
  print "<h1 style='text-align:center;'>";
  print "<br> PLEASE CHANGE LOCATION";
  print "<br> <a href=\"javascript:window.open('','_self').close();\">close window</a>";
  print "</h1>";
  print "</body></html>";

  return();

}#End redo_location_mess

sub resubmit_output
{
  print "Content-type: text/html; charset=utf-8\n\n";
  print "<!DOCTYPE html><html><head><title>resubmit</title></head><body>\n";
  print "<h1 style='text-align:center;'>>";
  print "<br> PLEASE RESUBMIT OBSERVATION";
  print "<br> <a href=\"javascript:window.open('','_self').close();\">close window</a>";
  print "</h1>";
  print "</body></html>";

  return();

}#End resubmit_output

sub check_location
{
  use lib ".";
  use sys_info qw(getDevLevel getHostClass getAppName);

  #
  # Return diagnostic display of input after submission
  #

  print "Content-type: text/html; charset=utf-8\n\n";

  #
  # -------------------------
  #

    open( my $FILE, ">", "../dynamic/temp/location_$$.list" ) or die "../dynamic/temp/location_$$.list: $!";
    printf( $FILE "%-6s %-7s %s\n", $csgn_name, $lat, $lon );
    close( $FILE );

  #
  # -------------------------
  # draw map with location

    open( $FILE, ">", "../dynamic/temp/coverage_plot_$$.in" ) or die "../dynamic/temp/coverage_plot_$$.in: $!";
    printf( $FILE "%s\n", "TITLE1=Location Check" );
    printf( $FILE "%s\n", "IMAGE_FILE=../dynamic/temp/location_check_plot_$$.png" );
    if( $clas_type eq "U" )
    {
      printf( $FILE "%s\n", "IMAGE_BG=/fnmoc/u/curr/etc/static/app/cov_plots2/images/basic_white_unclassified.png" );
    }
    elsif( $clas_type eq "C" )
    {
      printf( $FILE "%s\n", "IMAGE_BG=/fnmoc/u/curr/etc/static/app/cov_plots2/images/basic_white_confidential.png" );
    }
    elsif( $clas_type eq "S" )
    {
      printf( $FILE "%s\n", "IMAGE_BG=/fnmoc/u/curr/etc/static/app/cov_plots2/images/basic_white_secret.png" );
    }
    else
    {
      printf( $FILE "%s\n", "IMAGE_BG=/fnmoc/u/curr/etc/static/app/cov_plots2/images/basic_white.png" );
    }
    printf( $FILE "%s\n", "NAME_LENGTH=4" );
    printf( $FILE "%s\n", "NAME_START=1" );
    printf( $FILE "%s\n", "LATITUDE_LENGTH=6" );
    printf( $FILE "%s\n", "LATITUDE_START=7" );
    printf( $FILE "%s\n", "LONGITUDE_LENGTH=7" );
    printf( $FILE "%s\n", "LONGITUDE_START=14" );
    printf( $FILE "%s\n", "#" );
    printf( $FILE "%s\n", "CAPTION1=Ship call sign $csgn_name" );
    printf( $FILE "%s\n", "COLOR=red" );
    printf( $FILE "%s\n", "SYMBOL=x" );
    printf( $FILE "%s\n", "SYMBOL_SIZE=vbig" );
    printf( $FILE "%s\n", "LOCATION_FILE=../dynamic/temp/location_$$.list" );
    close( $FILE );


    # CDM change following when promoting
    my $INPUT = `/fnmoc/u/curr/bin/coverage_plot ../dynamic/temp/coverage_plot_$$.in 2>&1`;

    if( -e "../dynamic/temp/location_$$.list" )
    {
        unlink( "../dynamic/temp/location_$$.list" ) or warn "Failed to delete '../dynamic/temp/location_$$.list': $!";
    }

    if( -e "../dynamic/temp/coverage_plot_$$.in" )
    {
        unlink( "../dynamic/temp/coverage_plot_$$.in" ) or warn  "Failed to delete '../dynamic/temp/coverage_plot_$$.in': $!";
    }

#
# -------------------------
#

    print <<EOF;
<!DOCTYPE html>
<html>
<head>
<title>location check</title>
</head> 
<body>

<script src="../js/functions.js" language="JavaScript" type="text/javascript"></script>

<form
action="../cgi-bin/shp_loc.cgi \n"
onsubmit="return check_accept_location()"
method="post"
target="loc_target"
enctype="multipart/form-data">

<input type="hidden" name="server_send_time" value="$server_send_time">
<input type="hidden" name="client_receive_time" value="$client_receive_time">
<input type="hidden" name="client_send_time" value="$client_send_time">
<input type="hidden" name="sub_yr" value="$sub_yr">
<input type="hidden" name="sub_mo" value="$sub_mo">
<input type="hidden" name="sub_day" value="$sub_day">
<input type="hidden" name="sub_hr" value="$sub_hr">
<input type="hidden" name="sub_min" value="$sub_min">
<input type="hidden" name="sub_time" value="$sub_time">
<input type="hidden" name="submit_type" value="">
<input type="hidden" name="title" value="">
EOF
  print <<EOF;
<!--# Submitter information -->
<input type="hidden" name="observer" value="$observer">
<input type="hidden" name="observer_title" value="$observer_title">
<input type="hidden" name="email" value="$email">
EOF
  print <<EOF;
<!--# ship information-->
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
<!--!# ship location-->
<input type="hidden" name="lat" value="$lat">
<input type="hidden" name="lon" value="$lon">
EOF
  print <<EOF;
<!--# security-->
<input type="hidden" name="clas_type" value="$clas_type">
<input type="hidden" name="clas" value="$clas">
<input type="hidden" name="cls_sel" value="$cls_sel">
<input type="hidden" name="cls_doc" value="$cls_doc">
<input type="hidden" name="cls_ath" value="$cls_ath">
<input type="hidden" name="cls_rsn" value="$cls_rsn">
<input type="hidden" name="dcls_sel" value="$dcls_sel">
<input type="hidden" name="dcls_tday" value="$dcls_tday">
<input type="hidden" name="dcls_yr" value="$dcls_yr">
<input type="hidden" name="dcls_mon" value="$dcls_mon">
<input type="hidden" name="dcls_day" value="$dcls_day">
<input type="hidden" name="dcls_txt" value="$dcls_txt">
<input type="hidden" name="cls_cvt" value="$cls_cvt">
EOF

  print <<EOF;
<!--#input source -->
<input type="hidden" name="shp_loc_file" value="../dynamic/temp/shp_loc_file_$$">
<input type="hidden" name="id_num" value="$$">
EOF
  print <<EOF;

<table style="margin:auto; text-align:center;">
<tr>
<td style='text-align:center;'>
<br>
<a href="javascript:window.open('','_self').close();">close window</a>
</td>
</tr>
<tr>
<td style='text-align:center;'>
<img src="../dynamic/temp/location_check_plot_$$.png" alt="map display with location">
<br>
Is this location acceptable?
<input type="radio" id="accept_location" name="accept_location" value="yes" /> YES
<input type="radio" id="accept_location" name="accept_location" value="no" /> NO
<br>
<input type="submit" value="Process">
</td>
</tr>
</table>
</form>
</body>
</html>
EOF

  return();

}#End check_location

sub diag_output
{
  use lib ".";
  use sys_info qw(getDevLevel getHostClass getAppName);

  #
  # Return diagnostic display of input after submission
  #

  #
  # Set variables needed by decoders
  #

  $ERROR = "NO";
  #my $OUTPUT;
  my $KEY_WORD;
  my $ETC_DIR = "/fnmoc/u/curr/etc/static/app/j-obs_batch";
  my $PROGBIN = "/fnmoc/u/curr/bin";

  $ENV{'GEMTBL'} = "$ETC_DIR/tables";
  $ENV{'GEMERR'} = "$ETC_DIR/error";
  $ENV{'GEMHLP'} = "$ETC_DIR/help";


  print "Content-type: text/html; charset=utf-8\n\n";


#
# -------------------------
#
    print <<EOF;
<!DOCTYPE html><html> <head> <title>report submission</title> </head> <body>
<table>
<tr>
<td style='text-align:center;'>
<br> <a href=\"javascript:window.open('','_self').close();window.open('','wmo_form').close()\">close windows</a>
EOF
    if( $KEY_WORD eq "ERROR" )
    {
    print <<EOF;
<h1>
$title ERROR --- RESUBMIT
<br>
EOF
    }
    else
    {
    print <<EOF;
<h1>
$title --- Submission Complete
<br>
EOF
    }

    print scalar (gmtime);
    print "<br> remote id: $remote_id";
    print "<br> web browser type: $browser_type";
    print "</h1>";
    print <<EOF;
<table style="margin:auto; text-align:center;">
<tr>
<td style='text-align:left; padding:5px; border:1px solid black'>
<pre>
EOF

    printf("%s",$OUTPUT);

    if ($KEY_WORD eq "ERROR")
    {
      $ERROR = "YES";
    }

    print <<EOF;
</pre>
</td>
</tr>
</table>
</td>
</tr>
</table>
</body>
</html>
EOF

  return();

}#End diag_output

sub process_data
{
  #
  # Assign web page form input to variables
  #

  my % month_name = (
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

  my $unq_num;
  $unq_num = $$;
  $unq_num = sprintf( "%010d", $unq_num );

  $sub_dtg = sprintf( "%4d%02d%02d%02d%02d%02d", $sub_yr, $sub_mo, $sub_day, $sub_hr, $sub_min, 00 );

  #
  # write out values into a diagnostic file
  #
  my $tri_name = substr($csgn_name,1,3);
  my $file_name = sprintf("Ship%s%04d-%02d-%02dT%02d:%02d:00Z.txt",$tri_name,$obs_yr,$obs_mo,$obs_day,$obs_hr,$obs_min) =~ /^([\w.:-]+)$/;;
  #my $file_name = "Ship${tri_name}${obs_yr}-${obs_mo}-${obs_day}T${obs_hr}:${obs_min}:00Z.txt" =~ /^([\w.:-]+)$/;
  $file_name = $1;
  my $output_file_name  = "../dynamic/shp_loc/$clas/$file_name";

  open( my $DIAG, ">", $output_file_name ) or die "Can't open diagnostic file, $output_file_name: $!";

  #
  # Set up an enocded file to go in the shp_loc subdirectory
  #
  my $sec_pre;
  $sec_pre = "j";

  my $yday_3 = sprintf( "%03d", $yday_s ); 
  my $encode_file_name = "${sec_pre}${yday_3}co${unq_num}r";

  my $product_name = "US058OMET-TXTsl1";
  $product_name = join( ".", $product_name, $send_dtg );
  $product_name = join( "_", $product_name, $encode_file_name );

  my $encode_out;
  $encode_out = sprintf( "%04d-%02d-%02dT%02d:%02d:00.000+0000  %7.5f  %7.5f", $obs_yr, $obs_mo, $obs_day, $obs_hr, $obs_min, $lon, $lat );
  #$encode_out = "${obs_yr}-${obs_mo}-${obs_day}T${obs_hr}:${obs_min}:00.000+0000  $lat  $lon";
  print( $DIAG "$encode_out" );
  close( $DIAG );
  chmod( 0664, "$output_file_name" );

  return();

}#End process_data

sub form_output
{
  #
  # Place input data into a file for archiving
  #

  my $unq_num;
  $unq_num = $$;
  $unq_num = sprintf( "%010d", $unq_num );

  my $file_name = "raw_${data_type}.$csgn_name.$sub_dtg.$unq_num" =~ /^([\w.]+)$/;
  $file_name = $1;
  my $output_file_name  = "../dynamic/shp_loc/$clas/$file_name";

  open( my $FILE, ">", $output_file_name ) or die "Can't open $output_file_name: $!";

  print $FILE "--- Hidden Information ---\n";
  print $FILE "server_send_time      $server_send_time\n";
  print $FILE "client_receive_time   $client_receive_time\n";
  print $FILE "client_send_time      $client_send_time\n";
  print $FILE "submit type           $submit_type\n";
  print $FILE "---- Point of Origin -----\n";
  print $FILE "observer_title        $observer_title\n";
  print $FILE "observer              $observer\n";
  print $FILE "email                 $email\n";
  print $FILE "csgn_name             $csgn_name\n";
  print $FILE "ship_title            $ship_title\n";
  print $FILE "ship_name             $ship_name\n";
  print $FILE "latitude              $lat\n";
  print $FILE "longitude             $lon\n";
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
  print $FILE "\n------- Security ----------\n";
  print $FILE "clas_type             $clas_type\n";
  print $FILE "cls_ath               $cls_ath\n";
  print $FILE "cls_rsn               $cls_rsn\n";
  print $FILE "cls_doc               $cls_doc\n";
  print $FILE "dcls_tday             $dcls_tday\n";
  print $FILE "dcls_yr               $dcls_yr\n";
  print $FILE "dcls_mon              $dcls_mon\n";
  print $FILE "dcls_day              $dcls_day\n";
  print $FILE "\n------Transmission --------\n";
  print $FILE "server_send_time      $server_send_time\n";
  print $FILE "client_receive_time   $client_receive_time\n";
  print $FILE "client_send_time      $client_send_time\n";
  print $FILE "server_receive_time   $server_receive_time\n";
  print $FILE "\n----- Browser Type ---------\n";
  print $FILE "$browser_type\n";
  close( $FILE );
  chmod( 0664, "$output_file_name" );
 
  return();

}#End form_output

sub main
{

    # access subroutine arguments
    ($title, $data_type) = @_;

    $title =~ s/[^a-zA-Z' ]//g;
    $data_type =~ s/[^a-zA-Z_]//g;

    # setup web directory.
    my @str_array=split("\/", $ENV{SCRIPT_NAME});
    $sub_dir = $str_array[1];
    $web_dir="$ENV{SERVER_NAME}/$sub_dir";

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

    #
    # ===================== Begin main script =========================
    #

    if( $q->param() )
    {

      ( $accept_location = $q->param( "accept_location" ) ) =~ s/[^a-zA-Z_]//g;

    #
    # Process form output if present
    #
      if( $accept_location eq "no" )
      {
        &redo_location_mess();
        &cleanup();
        exit;
      }

      ( $server_send_time = $q->param("server_send_time") ) =~ s/[^0-9_]//g;
      ( $client_receive_time = $q->param("client_receive_time") ) =~ s/[^0-9_]//g;
      ( $client_send_time = $q->param("client_send_time") ) =~ s/[^0-9_]//g;
      ( $submit_type = $q->param("submit_type") ) =~ s/[^a-zA-Z_]//g;

      &form_input();
      if( $accept_location eq "unk" )
      {
        &check_location();
      }  
      elsif( $accept_location eq "yes" )
      {
        &activity_file();
        &diag_output();
        if( $ERROR eq "NO" )
        {
          &process_data();
          &form_output();
        }
        else
        {
          &cleanup();
          exit;
        }  
        &cleanup();
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
