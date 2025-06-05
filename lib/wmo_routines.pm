#!/usr/bin/perl -w

package wmo_routines;

use warnings;
use strict;
use lib qw( /fnmoc/web/webservices/apache/app/common/lib /fnmoc/u/curr/lib/perllib );
use POSIX qw( uname );
use CGI;

use vars qw
( $ERROR                   $LaLaLa                  $LoLoLo                  
  $OUTPUT                  $Q                       $accept_location         
  $actl_ob_hr              $actl_ob_min             $browser_type            
  $clas                    $clas_type               $client_receive_time     
  $client_send_time        $cls_ath                 $cls_cvt                 
  $cls_doc                 $cls_rsn                 $cls_sel                 
  $csgn_name               $data_type               $dcls_day                
  $dcls_hr                 $dcls_inst               $dcls_isdat              
  $dcls_min                $dcls_mon                $dcls_sec                
  $dcls_sel                $dcls_tday               $dcls_txt                
  $dcls_wday               $dcls_yday               $dcls_yr                 
  $dps_hdr                 $email                   $fh                      
  $group                   $hour_s                  $isdat_s                 
  $lat                     $lat_sign                $lon                     
  $lon_sign                $mday_s                  $min_s                   
  $mon_s                   $observer                $observer_title          
  $oct                     $q                       $quad                    
  $remote_id               $results                 $rpt_id                  
  $sec_s                   $section_m               $send_dtg                
  $server_receive_time     $server_send_time        $ship_name               
  $ship_title              $static_msl_dir          $stn_ht
  $stn_id                  $stn_name                $sub_day
  $sub_dir                 $sub_dtg                 $sub_hr                  
  $sub_min                 $sub_mo                  $sub_time                
  $sub_yr                  $submit_type             $title                   
  $upload_wmo_file         $upload_wmo_file_out     $upload_wmo_text         
  $upload_wmo_text_mobtaf  $wday_s                  $web_dir                 
  $wmo_file                $yday_s                  $year_s  
);

$static_msl_dir = "/fnmoc/u/curr/etc/static/app/msl";

sub cleanup
{
  my $id_num;
  ( $id_num = $q->param("id_num") ) =~ s/[^0-9]//g;

  if( $id_num =~ /^([-\@\w.]+)$/ )
  {
    $id_num = $1;                     # $data now untainted
  }
  else
  {
    die "Bad data in '$id_num'";      # log this somewhere
  }

  if( -e "../dynamic/temp/location_check_plot_${id_num}.png" )
  {
      unlink( "../dynamic/temp/location_check_plot_${id_num}.png" ) or warn  "Failed to delete '../dynamic/temp/location_check_plot_${id_num}.png'\n$!\n";
  }

  if( -e "../dynamic/temp/wmo_file_${id_num}" )
  {
      unlink( "../dynamic/temp/wmo_file_${id_num}" ) or warn  "Failed to delete '../dynamic/temp/wmo_file_${id_num}'\n$!\n";
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
    my $IN;
#
# Create the html file and send to client
#
    print "Content-type: text/html; charset=utf-8\n\n";

    if ($data_type eq "ship_taf" || $data_type eq "mob_taf" )
    {
      open( $IN, "<", "../html/wmo_form_taf.html_template" ) or die "Can't open ../html/wmo_form_taf.html_template\n$!\n";
    }
    else
    {
      open( $IN, "<", "../html/wmo_form.html_template" ) or die "Can't open ../html/wmo_form.html_template\n$!\n";
    }

#
# Need to parse the including file and set the value of server_send_time to a
# unique value. This could be YYYYMMDDHHMMSS.  This value would be saved
# in an id log file along with the ship's call sign and possibly the obs time.
# To guard against diplicate resubission through the use of the browser's
# refresh, the log file would be checked.
#
  ( my $sec, my $min, my $hour, my $mday, my $mon, my $year, my $wday, my $yday, my $isdat ) = gmtime;

  use vars qw($form_intro);
  use vars qw($clas_banner);

  $year = $year + 1900;
  $mon  = $mon +1;

  my $date_time = join( "_", $year, $mon, $mday, $hour, $min, $sec );

#
# select data type
#
  if( $data_type eq "ship_sfc" )
  {
    $form_intro="<br>All ships MUST use COMNAVMETOCCOM Form 3141/3 to record observations
<br>Original observations are required to be archived onboard for a minimum of 6 months
<br>
<br>Synoptic Hours - 0000Z, 0600Z, 1200Z, 1800Z
<br>Asynoptic Hours - 0300Z, 0900Z, 1500Z, 2100Z";
  }
  elsif( $data_type eq "tesac" )
  {
    $form_intro="TEmperature SAlinity Current";
  }
  elsif( $data_type eq "ship_taf" || $data_type eq "mob_taf" )
  {
    $form_intro="Terminal Aerodrome Forecast";
  }
  elsif( $data_type eq "acft_amdar" )
  {
    $form_intro="Aircraft Meteorological Data Relay";
  }
  else
  {
    $form_intro="";
  }

  $clas_banner = getClasBnr();

  while( <$IN> )
  {
    #   
    # skip line
    # 
    if( index( $_,'//' ) == 0 )
    {
      next;
    }
    s/#WEB_DIR#/$web_dir/g;
    s/#TITLE#/$title/g;
    s/#DATA_TYPE#/$data_type/g;
    s/#FORM_INTRO#/$form_intro/g;
    s/#FORM_STAT#/$date_time/g;
    s/#SUBMIT_TYPE#/wmo/g;
    s/#WMO_ID#/$rpt_id/g;
    s/#CLAS_BANNER#/$clas_banner/g;

    if( getHostClass() eq "secret" )
    { 
        if( $data_type eq "xbt" )
        {
            s/#LIST_CLAS_LABEL#/xbt_clas_lists\.js/g;
        }
        elsif( $data_type eq "ship_taf" )
        {
            s/#LIST_CLAS_LABEL#/basic_lists_clas_taf\.js/g;
        }
        else
        {
            s/#LIST_CLAS_LABEL#/basic_lists_clas\.js/g;
        }
    }
    else
    {
        if( $data_type eq "xbt" )
        {
            s/#LIST_CLAS_LABEL#/xbt_unclas_lists\.js/g;
        }
        elsif( $data_type eq "ship_taf" )
        {
            s/#LIST_CLAS_LABEL#/basic_lists_unclas_taf\.js/g;
        }
        else
        {
            s/#LIST_CLAS_LABEL#/basic_lists_unclas\.js/g;
        }
    }

    if( index( $_, "#COL_INSERT#" ) >= 0 )
    {
       open( my $INS, "<", "../html/color_insert.html_template" ) or die "Can't open ../html/color_insert.html_template\n$!\n";
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

        if( $data_type eq "xbt" )
        {
            system( "../cgi-bin/origin_lnd_insert.cgi", $mail, "Flight_ID" );
        }
        else
        {
            system( "../cgi-bin/origin_insert.cgi", $mail );
        }

    }
    elsif( index( $_, "#LOC_INSERT#" ) >= 0 )
    {
      if( $data_type eq "ship_taf" || $data_type eq "mob_taf" )
      {
        open( my $INS, "<", "../html/location_insert.html_template" ) or die "../html/location_insert.html_template\n$!\n";
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
    }
    elsif( index( $_, "#SEC_INSERT#" ) >= 0 )
    {
      my $INS;

      if( getHostClass() eq "unclas" )
      {
        open( $INS, "<", "../html/security_unclas_insert.html_template" ) or die "../html/security_insert.html_template\n$!\n";
      }
      else
      {
        open( $INS, "<", "../html/security_insert.html_template" ) or die "../html/security_insert.html_template\n$!\n";
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
    elsif( index( $_, "#WMO_INSERT#" ) >= 0 )
    {
       my $INS;

       if( $data_type eq "ship_taf" || $data_type eq "mob_taf" )
       {
         open( $INS, "<", "../html/wmo_taf_insert.html_template" ) or die "../html/wmo_taf_insert.html_template\n$!\n";
       }
       else
       {
         open( $INS, "<", "../html/wmo_insert.html_template" ) or die "../html/wmo_insert.html_template\n$!\n";
       }

       while( <$INS> )
       {
         if( index( $_, '//' ) == 0 )
         {
           next;
         }
         s/#RPT_TYPE#/${rpt_id}/g;
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
  my $USERS;

  if( ! -e "../dynamic/activity_logs/${data_type}_activity.log" )
  {
    open( $USERS, ">", "../dynamic/activity_logs/${data_type}_activity.log" ) || die "Can't open ${data_type}_activity.log\n$!\n";
    close( $USERS );
    chmod (0664, "../dynamic/activity_logs/${data_type}_activity.log");
  }

  #
  # Check if this is an accidental resubmital from a browser refresh
  # 
  open( $USERS, "<", "../dynamic/activity_logs/${data_type}_activity.log" ) || die "Can't open ${data_type}_activity.log\n$!\n";

  my @users    = <$USERS>;
  close( $USERS );
  chmod (0664, "../dynamic/activity_logs/${data_type}_activity.log");
  my $new_user = "$csgn_name $remote_id ob_time $sub_time";

  foreach my $user (@users)
  {
    chomp $user;
    if ($new_user eq $user)
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
  $send_dtg = sprintf( "%4d%02d%02d%02d%02d%02d", $year_s, $mon_s,$mday_s, $hour_s, $min_s, $sec_s );

  my $log_filename = "${data_type}_activity.log";
  my $log_file = "../dynamic/activity_logs/${log_filename}";

  open( $USERS, ">>", $log_file ) || die "Can't open $log_file\n$!\n";
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
  ( $observer = $q->param("observer") ) =~ s/[^a-zA-Z ]//g;
  if( $data_type eq "xbt" )
  {
      $observer_title = "OTHER";
  }
  else
  {
      ( $observer_title = $q->param("observer_title") ) =~ s/[^a-zA-Z0-9. ]//g;
  }
  # webservices 8 Fast and flexible email validation
  # $expr = '^(([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?))$';
  # webservices 9 Email validation which complies with RFC 2822
  my $expr = '^(((\"[^\"\f\n\r\t\b]+\")|([\w\!\#\$\%\&\'\*\+\-\~\/\^\`\|\{\}]+(\.[\w\!\#\$\%\&\'\*\+\-\~\/\^\`\|\{\}]+)*))@((\[(((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9])))\])|(((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9])))|((([A-Za-z0-9\-])+\.)+[A-Za-z\-]+)))$';

  my $temp_var = $q->param("email") =~ /$expr/;
  if( ! defined ($temp_var) )
  {
    $email = "not valid";
  }
  else
  {
    $email = $q->param("email");
  }

  # ship information
  if( $data_type eq "xbt" )
  {
      ( $csgn_name  =  $q->param("stn_id") ) =~ s/[^a-zA-Z0-9]//g;
        $csgn_name  =~ tr/a-z/A-Z/;               # all characters to uppercase
      ( $ship_name  =  $q->param("stn_name") ) =~ s/[^a-zA-Z ]//g;
        $ship_name  =~ tr/a-z/A-Z/;               # all characters to uppercase
        $ship_title =  "USS";
  }
  else
  {
      ( $csgn_name  = $q->param("csgn_name") ) =~ s/[^a-zA-Z]//g;
        $csgn_name  =~ tr/a-z/A-Z/;               # all characters to uppercase
      ( $ship_name  = $q->param("ship_name") ) =~ s/[^a-zA-Z ]//g;
        $ship_name  =~ tr/a-z/A-Z/;               # all characters to uppercase
      ( $ship_title = $q->param("ship_title") ) =~ s/[^a-zA-Z]//g;
        $ship_title =~ tr/a-z/A-Z/;               # all characters to uppercase
  }

=head1

  # ship location (for TAF only)
  if( $data_type eq "ship_taf" )
  {
    ( $lat      = $q->param("lat") ) =~ s/[^0-9.]//g;
    ( $lon      = $q->param("lon") ) =~ s/[^0-9.]//g;
    ( $lat_sign = $q->param("lat_sign") ) =~ s/[^NS]//g;
    ( $lon_sign = $q->param("lon_sign") ) =~ s/[^EW]//g;

    if( index( $lat, '.' ) == -1 )
    {
      $lat = "$lat.";
    }

    if( index( $lon,'.' ) == -1 )
    {
      $lon = "$lon.";
    }

    if( $lat_sign eq "S" )
    {
      $lat = "-$lat";
    } 

    if( $lon_sign eq "W" )
    {
      $lon = "-$lon";
    } 

  }#End ship_taf

=cut


  if( $data_type eq "ship_taf" || $data_type eq "mob_taf" )
  {
    ( $lat      = $q->param("lat") ) =~ s/[^0-9.]//g;
    ( $lon      = $q->param("lon") ) =~ s/[^0-9.]//g;
    ( $lat_sign = $q->param("lat_sign") ) =~ s/[^NS]//g;
    ( $lon_sign = $q->param("lon_sign") ) =~ s/[^EW]//g;

    if( $lat_sign eq "N" && $lon_sign eq "E" )
    {
      $quad = "1";
      if( $lon >= 90 )
      { 
        $oct = "2";
      }
      else
      { 
        $oct = "3";
      }
    }

    if( $lat_sign eq "N" && $lon_sign eq "W" )
    {
      $quad = "7";
      if( $lon >= 90 )
      {
        $oct = "1";
      }
      else
      {
        $oct = "0";
      }
    }

    if( $lat_sign eq "S" && $lon_sign eq "W" )
    {
      $quad = "5";
      if( $lon >= 90 )
      {
        $oct = "6";
      }
      else
      {
        $oct = "5";     
      } 
    }

    if( $lat_sign eq "S" && $lon_sign eq "E" )
    {
      $quad = "3";
      if( $lon >= 90 )
      {
        $oct = "7";
      }
      else
      { 
        $oct = "8";
      }
    } 


    # MOBTAF
    $Q = $oct;
    $group = join( "", "MOBTAF", $Q );
    $section_m = $group;

    # TAF
    $section_m = join( " ", $section_m, "TAF" );

    # CCCC
    my $CCCC = sprintf( "%4s", $csgn_name );
    $section_m = join( " ", $section_m, $CCCC );

    # imimHHH
    my $imim = "//";
    my $HHH = sprintf( "%03.0f", $stn_ht / 10 );
    $group = join( "", $imim, $HHH );
    $section_m = join( " ", $section_m, $group );

    # LaLaLaLoLoLo
    $LaLaLa = sprintf( "%03.0f", $lat * 10 );
    my $LoLoLo;
    if( $lon < 100 )
    {
      $LoLoLo = sprintf( "%03.0f", $lon * 10 );
    }
    else
    {
      $LoLoLo = sprintf( "%03.0f", ( $lon - 100 ) * 10 );
    }
    $group = join( "", $LaLaLa, $LoLoLo );
    $section_m = join( " ", $section_m, $group );

  }#End MOBTAF
  else
  {
      $lat = $q->param("lat");
      if( $lat )
      {
          $lat =~ s/[^0-9.]//g;
      }
      
      $lon = $q->param("lon");
      if( $lon )
      {
          $lon =~ s/[^0-9.]//g;
      }
  }

  # security
  ( $clas_type = $q->param("clas_type") ) =~ s/[^UCS]//g;

  if( $clas_type eq "S" )
  {
    $clas = "secret";
  }
  elsif( $clas_type eq "C" )
  {
    $clas = "confid";
  }
  else
  {
    $clas = "unclas";
  }

  if( $clas_type eq "S" || $clas_type eq "C" )
  {
    ( $cls_sel = $q->param("cls_sel") ) =~ s/[^123]//g;

    if( $cls_sel eq "1" )
    {
      ( $cls_doc = $q->param("cls_doc") ) =~ s/[^a-zA-Z0-9.-_:]//g;
      $cls_ath   = "";
      $cls_rsn   = "";
    }
    elsif( $cls_sel eq "2" )
    {
      $cls_doc   = "";
      ( $cls_ath = $q->param("cls_ath") ) =~ s/[^a-zA-Z0-9.-_:]//g;
      ( $cls_rsn = $q->param("cls_rsn") ) =~ s/[^a-zA-Z0-9.-_:]//g;
    }

    ( $dcls_sel = $q->param("dcls_sel") ) =~ s/[^a-zA-Z0-9.-_:]//g;

    if( $dcls_sel eq "1" )
    {
      ( $dcls_tday = $q->param("dcls_tday") ) =~ s/[^0-9]//g;
      $dcls_yr     = "";
      $dcls_mon    = "";
      $dcls_day    = "";
      $dcls_txt    = "";
    }
    elsif( $dcls_sel eq "2" )
    {
      $dcls_tday  = "";
      ( $dcls_yr  = $q->param("dcls_yr") ) =~ s/[^0-9]//g;
      ( $dcls_mon = $q->param("dcls_mon") ) =~ s/[^0-9]//g;
      ( $dcls_day = $q->param("dcls_day") ) =~ s/[^0-9]//g;
      $dcls_txt   = "";
    }
    elsif( $dcls_sel eq "3" )
    {
      $dcls_tday  = "";
      $dcls_yr    = "";
      $dcls_mon   = "";
      $dcls_day   = "";
      ( $dcls_txt = $q->param("dcls_txt") ) =~ s/[^a-zA-Z0-9.-_:]//g;
    }

    ( $cls_cvt = $q->param("cls_cvt") ) =~ s/[^a-zA-Z0-9.-_:]//g;

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
  if( $dcls_sel eq "1" )
  {
    if( $dcls_tday ne "" )
    {
      my $time_s = time + $dcls_tday * 86400;

      ( $dcls_sec, $dcls_min, $dcls_hr, $dcls_day, $dcls_mon, $dcls_yr, $dcls_wday, $dcls_yday, $dcls_isdat ) = gmtime($time_s);
      $dcls_mon = $dcls_mon + 1;
      $dcls_yr  = $dcls_yr + 1900;
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

  ( $sub_sec, $sub_min, $sub_hr, $sub_day, $sub_mo, $sub_yr, $sub_wday, $sub_yday, $sub_isdat ) = gmtime;
  $sub_mo   = $sub_mo +1;
  $sub_yr   = $sub_yr +1900;
  $sub_time = "${sub_yr}_${sub_mo}_${sub_day}_${sub_hr}_${sub_min}";


  # wmo message
  $upload_wmo_text =  $q->param("upload_wmo_text");
  if( defined( $upload_wmo_text ) )
  {
    $upload_wmo_text =~ tr/\n//d;                    # remove carriage return
    $upload_wmo_text =~ tr/0-9A-Za-z\/\r\040,+-//dc; # allow only a-z, A-Z, 0-9, /,
                                                     # new line characters
                                                     # and blanks
    $upload_wmo_text =~ tr/\r/\n/;                   # switch new line characters
                                                     # with carriage returns
    $upload_wmo_text =~ s/^\s+//;                    # remove leading whitespce
    $upload_wmo_text =~ s/\s+$//;                    # remove trailing whitespce
    $upload_wmo_text =~ s/ +/ /g;                    # shrink blanks to one blank
    $upload_wmo_text =~ s/ \n/\n/g ;                 # remove last blank at end of line
    $upload_wmo_text =~ s/\s+\n/\n/g;                # remove blank lines
    #chomp($upload_wmo_text);                         # remove the trailing carriage return
    $upload_wmo_text =~ tr/a-z/A-Z/;                 # all characters to uppercase

    if( $upload_wmo_text ne "" )
    {
      my @rpt_id_list = split( ",", $rpt_id );
      my $rpt_id_cnt = @rpt_id_list;
      my $count = 0;
      my $one_line = $upload_wmo_text;
      $one_line =~ s/\n/ /g;   # create one line
      my @file_words = split( " ", $one_line );

      # check if any rpt_id exists in upload_wmo_text
      for( my $cnt = 0; $cnt < $rpt_id_cnt; $cnt++ )
      {
          $count = grep /$rpt_id_list[$cnt]/i , $upload_wmo_text;
          if( $count ){ last; }
      }

      if( $count == 0 )
      {
        print "Content-type: text/html; charset=utf-8\n\n";
        print "<!DOCTYPE html><html><head><title>missing report id</title></head><body>\n";
        print "<h1 style='text-align:center;'>";
        print "WMO TEXT MESSAGE IS MISSING $rpt_id <br>";
        print "PLEASE RESUBMIT <br>";
        print "$upload_wmo_text <br>";
        print "</h1>";
        print "</body></html>";

        exit;
      }

      # Check rpt_id is the first group of report
      $count = 0;

      for( my $cnt = 0; $cnt < $rpt_id_cnt; $cnt++ )
      {
        if( $rpt_id_list[$cnt] eq $file_words[0] )
        {
          $count = 1;
          last;
        }

      }

      if( $count == 0 )
      {
        print "Content-type: text/html; charset=utf-8\n\n";
        print "<!DOCTYPE html><html><head><title>missing id</title></head><body>\n";
        print "<h1 style='text-align:center;'>";
        print "WMO TEXT MESSAGE FILE DOES NOT HAVE $rpt_id AT BEGINNING<br>";
        print "PLEASE RESUBMIT <br>";
        print "$upload_wmo_text <br>";
        print "</h1>";
        print "</body></html>";

        exit;
      }

      # check for call sign with message
      $csgn_name =~ tr/a-z/A-Z/;
      $count = 0;

      $count = grep /$csgn_name/i, $upload_wmo_text;

      # Look for 99999 in lieu of call sign for KKYY (TESAC) and JJVV (BATHY)
      if( $count == 0 && ( $rpt_id eq "KKYY" || $rpt_id eq "JJVV" ) )
      {
          $count = grep /99999/i ,$upload_wmo_text;
      }

      if( $count == 0 )
      {
        print "Content-type: text/html; charset=utf-8\n\n";
        print "<!DOCTYPE html><html><head><title>missing call sign</title></head><body>\n";
        print "<h1 style='text-align:center;'>";
        print "WMO TEXT MESSAGE IS MISSING CALL SIGN: $csgn_name <br>";
        print "PLEASE RESUBMIT <br>";
        print "$upload_wmo_text <br>";
        print "</h1>";
        print "</body></html>";

        exit;
      }

=head1

      # ship TAF
      if( $data_type eq "ship_taf" )
      {
        $lat = sprintf( "%.4f", $lat );
        $lon = sprintf( "%.4f", $lon );
        $upload_wmo_text =~ s/TAF/TAFSHIP $lat $lon/;
      }

=cut

      # MOBTAF
      if( $data_type eq "ship_taf" || $data_type eq "mob_taf" )
      {
        my @line = split( ' ', $upload_wmo_text );
        shift @line;
        my $SEC_WORD = shift @line;
        if( $SEC_WORD eq "AMD" || $SEC_WORD eq "COR" )
        {
          $section_m =~ s/TAF /TAF $SEC_WORD /;
          shift @line;
          $upload_wmo_text_mobtaf = join( " ", $section_m, @line );
        }
        else
        {
          $upload_wmo_text_mobtaf = join( " ", $section_m, @line );
        }
      }#End mob_taf
    }
    else
    {
      $upload_wmo_text = "";
    }
  }#End upload wmo text

  #upload file
  ( $upload_wmo_file =  $q->param("upload_wmo_file") ) =~ s/[^a-zA-Z0-9.-_\/]//g;

  if( $upload_wmo_file ne "" )
  {
    if( $data_type eq "ship_taf" || $data_type eq "mob_taf" )
    {
      $accept_location = "yes"
    }
    else
    {
      $accept_location = $q->param("accept_location");
    }
    if( $accept_location eq "unk" ||
        $data_type       eq "ship_taf" ||
        $data_type       eq "mob_taf" )
    {
      my $buffer = "";
      $upload_wmo_file_out = "";
      $fh = $q->upload( "upload_wmo_file" );
      while ( read( $fh, $buffer, 1024 ) )
      {
        #$buffer =~ tr/\n//d;                   # remove new line charaters
        #$buffer =~ tr/0-9A-Za-z\/\r\040//dc;   # allow only a-z, A-Z, 0-9,
        #                                       # carriage returns and blanks
        $buffer =~ tr/0-9A-Za-z\/\n\040,+-//dc; # allow only a-z, A-Z, 0-9,
                                               # new line characters and blanks
        $upload_wmo_file_out = join( "", $upload_wmo_file_out, $buffer );
      }
    } 
    else
    {
      my $wmo_file =  $q->param("wmo_file"); #../dynamic/temp/wmo_file_$$
      my $buffer = "";
      my $FILE;
      $upload_wmo_file_out = "";

      open( $FILE, "<", $wmo_file ) or die   "Content-type: text/html; charset=utf-8\n\n",
                                             "<!DOCTYPE html><html><head><title>stale message file</title></head><body>\n",
                                             "<h1 style='text-align:center;'>",
                                             "UPLOADED WMO MESSAGE FILE IS STALE $wmo_file <br>",
                                             "PLEASE CLOSE LOCATION CHECK WINDOW AND RESUBMIT",
                                             "</h1>",
                                             "</body></html>";

      while( $buffer = <$FILE> )
      {
        #$buffer =~ tr/\n//d;                   # remove new line charaters
        #$buffer =~ tr/0-9A-Za-z\/\r\040//dc;   # allow only a-z, A-Z, 0-9,
        #                                       # carriage returns and blanks
        $buffer =~ tr/0-9A-Za-z\/\n\040,+-//dc; # allow only a-z, A-Z, 0-9,
                                                # new line characters and blanks

        $upload_wmo_file_out = join( "", $upload_wmo_file_out, $buffer );
      }
      close( $FILE );
    }

    #$upload_wmo_file_out =~ tr/\r/\n/;       # switch carriage returns
                                              # with new line characters
    $upload_wmo_file_out =~ s/^\s+//;        # remove leading whitespce
    $upload_wmo_file_out =~ s/\s+$//;        # remove trailing whitespce
    $upload_wmo_file_out =~ s/ +/ /g;        # shrink blanks to one blank
    $upload_wmo_file_out =~ s/ \n/\n/g ;     # remove last blank at end of line
    $upload_wmo_file_out =~ s/\s+\n/\n/g;    # remove blank lines
    #chomp($upload_wmo_file_out);             # remove trailing new line character
    $upload_wmo_file_out =~ tr/a-z/A-Z/;     # all characters to uppercase

    my @rpt_id_list = split( ",", $rpt_id );
    my $rpt_id_cnt = @rpt_id_list;
    my $count = 0;

    for( my $cnt = 0; $cnt < $rpt_id_cnt; $cnt++ )
    {
        $count = grep /$rpt_id_list[$cnt]/i, $upload_wmo_file_out;
        if( $count ){ last; }
    }

    if( $count == 0 )
    {
      print "Content-type: text/html; charset=utf-8\n\n";
      print "<!DOCTYPE html><html><head><title>missing report id</title></head><body>\n";
      print "<h1 style='text-align:center;'>";
      print "UPLOADED WMO MESSAGE FILE IS MISSING $rpt_id <br>";
      print "PLEASE RESUBMIT <br> ";
      print "$upload_wmo_file_out <br>";
      print "</h1>";
      print "</body></html>";

      exit;
    }

    my $one_line = $upload_wmo_file_out;
    $one_line =~ s/\n/ /g;   # create one line
    my @file_words = split( " ", $one_line );
    $count = 0;

    for( my $cnt = 0; $cnt < $rpt_id_cnt; $cnt++ )
    {
      if( $rpt_id_list[$cnt] eq $file_words[0] )
      {
        $count = 1;
        last;
      }
    }

    if( $count == 0 )
    {
      print "Content-type: text/html; charset=utf-8\n\n";
      print "<!DOCTYPE html><html><head><title>missing id at begining</title></head><body>\n";
      print "<h1 style='text-align:center;'>";
      print "UPLOADED WMO MESSAGE FILE DOES NOT HAVE $rpt_id AT BEGINNING<br>";
      print "PLEASE RESUBMIT <br>";
      print "$upload_wmo_file_out <br>";
      print "</h1>";
      print "</body></html>";

      exit;
    }

    # check for call sign with message
    $count = 0;
    $csgn_name =~ tr/a-z/A-Z/;
    $count = grep /$csgn_name/i , $upload_wmo_file_out;

    # Look for 99999 in lieu of call sign for KKYY (TESAC) and JJVV (BATHY)
    if( $count == 0 && ( $rpt_id eq "KKYY" || $rpt_id eq "JJVV" ) )
    {
        $count = grep /99999/i , $upload_wmo_file_out;
    }

    if( $count == 0 )
    {
      print "Content-type: text/html; charset=utf-8\n\n";
      print "<!DOCTYPE html><html><head><title>missing call sign</title></head><body>\n";
      print "<h1 style='text-align:center;'>";
      print "UPLOADED WMO MESSAGE FILE IS MISSING CALL SIGN: $csgn_name <br>";
      print "PLEASE RESUBMIT <br>";
      print "$upload_wmo_file_out <br>";
      print "</h1>";
      print "</body></html>";

      exit;
    }

=head1

    # ship TAF
    if( $data_type eq "ship_taf" )
    {
      $lat = sprintf( "%.4f", $lat );
      $lon = sprintf( "%.4f", $lon );
      $upload_wmo_file_out =~ s/TAF/TAFSHIP $lat $lon/;
      $rpt_id = "TAFSHIP";
    }

=cut

    # MOBTAF
    if( $data_type eq "ship_taf" || $data_type eq "mob_taf" )
    {
      my @line = split( ' ', $upload_wmo_file_out );
      shift @line;
      my $SEC_WORD = shift @line;

      if( $SEC_WORD eq "AMD" || $SEC_WORD eq "COR" )
      {
        $section_m =~ s/TAF /TAF $SEC_WORD /;
        shift @line;
        $upload_wmo_text_mobtaf = join( " ", $section_m, @line );
      }
      else
      {
        $upload_wmo_text_mobtaf = join( " ", $section_m, @line );
      }
      $rpt_id = "MOBTAF";
    }

  }#End if updload_file ne ""

  return();

}#End form_input

sub redo_location_mess
{
  print "Content-type: text/html; charset=utf-8\n\n";
  print "<!DOCTYPE html><html><head><title>redo location mess</title></head><body>\n";
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
  print "<!DOCTYPE html><html><head><title>resubmit observation</title></head><body>\n";
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

  #
  # Set variables needed by decoders
  #  

  $ERROR = "NO";

  my $CSGN;
  my $DATA_TYPE;
  my $KEY_WORD;
  my $ETC_DIR = "/fnmoc/u/curr/etc/static/app/j-obs_batch";
  my $PROGBIN = "/fnmoc/u/curr/bin";

  # untaint $DATA_TYPE
  ( $DATA_TYPE ) = $data_type =~ /^(\w+)$/;

  $ENV{'GEMTBL'} = "$ETC_DIR/tables";
  $ENV{'GEMERR'} = "$ETC_DIR/error";
  $ENV{'GEMHLP'} = "$ETC_DIR/help";


  print "Content-type: text/html; charset=utf-8\n\n";

  #
  # -------------------------
  # 
  if( $results eq "submit" )
  {
    my $LINE;
    my $OUTPUT_TMP;

    if( $upload_wmo_text ne "" )
    {
      $upload_wmo_file_out = "";

      if( $data_type eq "ship_sfc" )
      {
        open( my $FILE, ">", "../dynamic/temp/wmo_file_$$" ) or die "../dynamic/temp/wmo_file_$$\n$!\n";
        printf( $FILE "%s", $upload_wmo_text );
        close( $FILE );
        $ENV{'WMO_FILE'} = "../dynamic/temp/wmo_file_$$";
        $OUTPUT = `$PROGBIN/dcmsfc_2 -v3 -d ../dynamic/temp/logdcmsfc_$$.out $static_msl_dir/sfc_stn_msl 2>&1`;
        $OUTPUT_TMP = `cat ../dynamic/temp/logdcmsfc_$$.out`;
        system( "/bin/rm ../dynamic/temp/logdcmsfc_$$.out" );
      }
      elsif( $data_type eq "bathy" or 
             $data_type eq "tesac" or
             $data_type eq "xbt" )
      {
        open( my $FILE, ">", "../dynamic/temp/wmo_file_$$" ) or die "../dynamic/temp/wmo_file_$$\n$!\n";
        printf( $FILE "%s", $upload_wmo_text );
        close( $FILE );
        $ENV{'WMO_FILE'} = "../dynamic/temp/wmo_file_$$";
        $OUTPUT = `$PROGBIN/dcbthy_2 -v3 -d ../dynamic/temp/logdcbthy_$$.out dummytbl 2>&1`;
        $OUTPUT_TMP = `cat ../dynamic/temp/logdcbthy_$$.out`;
        system( "/bin/rm ../dynamic/temp/logdcbthy_$$.out" );
      }
      elsif( $data_type eq "ship_raob" )
      {
        open( my $FILE, ">", "../dynamic/temp/wmo_file_$$" ) or die "../dynamic/temp/wmo_file_$$\n$!\n";
        printf( $FILE "%s",$upload_wmo_text );
        close( $FILE );
        $ENV{'WMO_FILE'} = "../dynamic/temp/wmo_file_$$";
        $OUTPUT = `$PROGBIN/dcusnd_2 -v3 -d ../dynamic/temp/logdcusnd_$$.out $static_msl_dir/stns/sfc_stn_msl $static_msl_dir/stns/shp_ref_lib 2>&1`;
        $OUTPUT_TMP = `cat ../dynamic/temp/logdcusnd_$$.out`;
        system( "/bin/rm ../dynamic/temp/logdcusnd_$$.out" );
      }
    }

    if( $upload_wmo_file ne "" )
    {
      $upload_wmo_text = "";

      if( $data_type eq "ship_sfc" )
      {
        open( my $FILE, ">", "../dynamic/temp/wmo_file_$$" ) or die "../dynamic/temp/wmo_file_$$\n$!\n";
        printf( $FILE "%s", $upload_wmo_file_out );
        close( $FILE );
        $ENV{'WMO_FILE'} = "../dynamic/temp/wmo_file_$$";
        $OUTPUT = `$PROGBIN/dcmsfc_2 -v3 -d ../dynamic/temp/logdcmsfc_$$.out $static_msl_dir/stns/sfc_stn_msl 2>&1`;
        $OUTPUT_TMP = `cat ../dynamic/temp/logdcmsfc_$$.out`;
        system( "/bin/rm ../dynamic/temp/logdcmsfc_$$.out" );
      }
      elsif( $data_type eq "bathy" ||
             $data_type eq "tesac" ||
             $data_type eq "xbt" )
      {
        open( my $FILE, ">", "../dynamic/temp/wmo_file_$$" ) or die "../dynamic/temp/wmo_file_$$\n$!\n";
        printf( $FILE "%s",$upload_wmo_file_out );
        close( $FILE );
        $ENV{'WMO_FILE'} = "../dynamic/temp/wmo_file_$$";
        $OUTPUT = `$PROGBIN/dcbthy_2 -v3 -d ../dynamic/temp/logdcbthy_$$.out dummytbl 2>&1`;
        $OUTPUT_TMP = `cat ../dynamic/temp/logdcbthy_$$.out`;
        system( "/bin/rm ../dynamic/temp/logdcbthy_$$.out" );
      }
      elsif( $data_type eq "ship_raob" )
      {
        open( my $FILE, ">", "../dynamic/temp/wmo_file_$$" ) or die "../dynamic/temp/wmo_file_$$\n$!\n";
        printf( $FILE "%s",$upload_wmo_file_out );
        close( $FILE );
        $ENV{'WMO_FILE'} = "../dynamic/temp/wmo_file_$$";
        $OUTPUT = `$PROGBIN/dcusnd_2 -v3 -d ../dynamic/temp/logdcusnd_$$.out $static_msl_dir/stns/sfc_stn_msl $static_msl_dir/stns/shp_ref_lib 2>&1`;
        $OUTPUT_TMP = `cat ../dynamic/temp/logdcusnd_$$.out`;
        system( "/bin/rm ../dynamic/temp/logdcusnd_$$.out" );
      }
      elsif( $data_type eq "ship_taf" || $data_type eq "mob_taf" )
      {
        $OUTPUT = "";
      }
    }# End if upload_wmo_file ne ""

    #
    # Check output file for latitude and longitude
    #   
    my @lines = split( '\n', $OUTPUT );
    my $cnt_critical;
    my $cnt_warning;

    my @station_id;
    my @csgn;
    my @ship_lat;
    my @ship_lon;
    my @lat;
    my @lon;
    my $LAT;
    my $LON;

    if( $data_type eq "ship_raob" )
    {
      @station_id = grep{ /Ship\/mobil ID/ } @lines ;
      $cnt_critical = grep{ /Ship\/mobil ID/ } @lines ;
    }
    else
    {
      @station_id = grep{ /Station ID/ } @lines;
      $cnt_critical = grep{ /Station ID/ } @lines;
    }

    if( $cnt_critical )
    {
      @csgn = split( /\s+/, $station_id[0] );
      # untaint $CSGN
      ( $CSGN = $csgn[2] ) =~ /^(\w+)$/;
    }
    else
    {
      $CSGN = "UNKN";
    }

    if( $data_type eq "ship_sfc" )
    {
      @ship_lat = grep{ /Ship latitude/ } @lines;
      $cnt_critical = grep{ /Ship latitude/ } @lines;
      @ship_lon = grep{ /Ship longitude/ } @lines;
    }
    else
    {
      @ship_lat = grep{ /Latitude/ } @lines;
      $cnt_critical = grep{ /Latitude/ } @lines;
      @ship_lon = grep{ /Longitude/ } @lines;
    }

    if( $cnt_critical )
    {
      @lat = split( /\s+/, $ship_lat[0] );
      @lon = split( /\s+/, $ship_lon[0] );

      if( $data_type eq "ship_sfc" )
      {
        $LAT = $lat[2];
        $LON = $lon[2];
      }
      else
      {
        $LAT = $lat[1];
        $LON = $lon[1];
      }
    }
    else
    {
      $LAT = "UNKN";
      $LON = "UNKN";
    }

    $lat = $LAT;
    $lon = $LON;

    open( my $FILE, ">", "../dynamic/temp/location_$$.list" ) or die "../dynamic/temp/location_$$.list\n$!\n";
    printf( $FILE "%-6s %-7s %s\n", $CSGN, $LAT, $LON );
    close( $FILE );

    $cnt_warning = grep{ /WARNING/ } @lines ;
    $cnt_critical = grep{ /ERROR/ } @lines ;

    if( $cnt_critical )
    {
      $KEY_WORD = "ERROR";
    }
    elsif( $cnt_warning )
    {
      $KEY_WORD = "WARNING";
    }
    else
    {
      $KEY_WORD = "NO PROBLEMS";
    }

    my $OUTPUT_TMP_2;

    if( $KEY_WORD eq "ERROR" )
    {
      $OUTPUT_TMP_2 = "\nERROR --- Please check for coding errors and bad groups\n\n";
    }
    elsif( $KEY_WORD eq "WARNING" )
    {
      $OUTPUT_TMP_2 = "\nWARNING --- Please check for warnings\n\n";
    }
    else
    {
      $OUTPUT_TMP_2 = "NO ENCODING PROBLEMS";
    }

    $OUTPUT = join( "\n", $OUTPUT,"+++++++++++++++++" );
    $OUTPUT = join( "\n", $OUTPUT, @ship_lat );
    $OUTPUT = join( "\n", $OUTPUT, @ship_lon );
    $OUTPUT = join( "\n", $OUTPUT, "+++++++++++++++++" );
    $OUTPUT = join( "\n", $OUTPUT, $OUTPUT_TMP_2 );
    $OUTPUT_TMP_2 = "=========================== DIAGMOSTIC OUTPUT =========================";
    $OUTPUT = join( "\n", $OUTPUT, $OUTPUT_TMP_2 );
    $OUTPUT = join( "\n", $OUTPUT, $OUTPUT_TMP );

    #
    # -------------------------
    # draw map with location

    open( $FILE, ">", "../dynamic/temp/coverage_plot_$$.in" ) or die "../dynamic/temp/coverage_plot_$$.in\n$!\n";
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
    elsif( $clas_type eq "C" )
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
    printf( $FILE "%s\n", "CAPTION1=Ship call sign $CSGN" );
    printf( $FILE "%s\n", "COLOR=red" );
    printf( $FILE "%s\n", "SYMBOL=x" );
    printf( $FILE "%s\n", "SYMBOL_SIZE=vbig" );
    printf( $FILE "%s\n", "LOCATION_FILE=../dynamic/temp/location_$$.list" );
    close( $FILE );

    # CDM diagnostic
    #   printf ("%-5s %-5s %s\n",$CSGN,$LAT,$LON);
    #   print "../dynamic/temp/location_$$.list\n";
    #   my $INPUT = `ls -l ../dynamic/temp/location_$$.list`;
    #   print "$INPUT\n";
    #   print "***** LOC INPUT ****\n";
    #   my $INPUT = `cat ../dynamic/temp/location_$$.list`;
    #   print "$INPUT\n";
    #   print "********************\n";
    #   my $INPUT = `cp ../dynamic/temp/location_$$.list /fnmoc/web/webservices/apache/app/j-obs_testing/dynamic/temp/. 2>&1`;
    #   print "$INPUT\n";
    #   my $INPUT = `ls -l /fnmoc/web/webservices/apache/app/j-obs_testing/dynamic/temp/location_$$.list 2>&1`;
    #   print "$INPUT\n";
    #   print "**** PLOT INPUT ****\n";
    #   $INPUT = `cat ../dynamic/temp/coverage_plot_$$.in`;
    #   print "$INPUT\n";
    #   print "********************\n";
    #   $INPUT = `cp ../dynamic/temp/coverage_plot_$$.in /fnmoc/web/webservices/apache/app/j-obs_testing/dynamic/temp/. 2>&1`;
    #   print "$INPUT\n";
    #   my $INPUT = `ls -l /fnmoc/web/webservices/apache/app/j-obs_testing/dynamic/temp/coverage_plot_$$.in 2>&1`;
    #   print "$INPUT\n";
    #   print "***** COV_PLOT ******\n";

    # CDM change following when promoting
    my $INPUT;

    $INPUT = `/fnmoc/u/curr/bin/coverage_plot ../dynamic/temp/coverage_plot_$$.in 2>&1`;

    if( -e "../dynamic/temp/location_$$.list" )
    {
        unlink( "../dynamic/temp/location_$$.list" ) or warn  "Failed to delete '../dynamic/temp/location_$$.list'\n$!\n";
    }

    if( -e "../dynamic/temp/coverage_plot_$$.in" )
    {
        unlink( "../dynamic/temp/coverage_plot_$$.in" ) or warn  "Failed to delete '../dynamic/temp/coverage_plot_$$.in':  $!";
    }

    # CDM diagnostic
    #   print "$INPUT\n";
    #   print "********************\n";
    #   $INPUT = `ls -l ../dynamic/temp/location_check_plot_$$.png 2>&1`;
    #   print "$INPUT\n";
    #   $INPUT = `mv ../dynamic/temp/location_check_plot_$$.png ../dynamic/location_check_plot_$CSGN.png 2>&1`;
    #   system("mv ../dynamic/temp/location_check_plot_$$.png ../dynamic/location_check_plot_${DATA_TYPE}_$CSGN.png 2>&1");

    #   system("mv ../dynamic/temp/location_check_plot_$$.png ../dynamic/temp/location_check_plot_$$.png 2>&1");
    #   $location_plot = "../dynamic/temp/location_check_plot_$$.png";
    #   $location_plot =~ s/[^a-zA-Z0-9.-_\/]//g;

    # CDM diagnostic
    #   $INPUT = `ls -l /fnmoc/web/webservices/apache/app/j-obs_testing/dynamic/temp/location_check_plot_$$.png 2>&1`;
    #   print "$INPUT\n";
    #   print "********************\n";
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
EOF
  if($data_type eq "ship_sfc")
  {
    print('action="../cgi-bin/ship_sfc.cgi"');
    print("\n");
  }
  elsif($data_type eq "ship_raob")
  {
    print('action="../cgi-bin/ship_raob.cgi"');
    print("\n");
  }
  elsif($data_type eq "bathy")
  {
    print('action="../cgi-bin/bathy.cgi"');
    print("\n");
  }
  elsif($data_type eq "xbt")
  {
    print('action="../cgi-bin/xbt.cgi"');
    print("\n");
  }
  elsif($data_type eq "tesac")
  {
    print('action="../cgi-bin/tesac.cgi"');
    print("\n");
  }

  print <<EOF;
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
<input type="hidden" name="rpt_id" value="">
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
<input type="hidden" name="stn_id" value="$csgn_name">
<input type="hidden" name="ship_name" value="$ship_name">
<input type="hidden" name="stn_name" value="$ship_name">
<input type="hidden" name="ship_title" value="$ship_title">
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

if(!defined($upload_wmo_text))
{
  $upload_wmo_text="";
}

if( ! defined( $upload_wmo_file ) )
{
  $upload_wmo_file="";
}

if( ! defined( $upload_wmo_file_out ) )
{
  $upload_wmo_file_out="";
}

  print <<EOF;
<!--#input source -->
<input type="hidden" name="upload_wmo_text" value="$upload_wmo_text">
<input type="hidden" name="upload_wmo_file" value="$upload_wmo_file">
<input type="hidden" name="upload_wmo_file_out" value="$upload_wmo_file_out">
<input type="hidden" name="wmo_file" value="../dynamic/temp/wmo_file_$$">
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
<input type="hidden" name="results" value="submit">
</td>
</tr>
</table>
</form>
</body>
</html>
EOF

  }

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
  if( $results eq "full" )
  {
    print <<EOF;
<!DOCTYPE html><html> <head> <title>report displayed</title> </head> <body>
<table style="margin:auto; text-align:center;">
<tr>
<td style='text-align:center;'>
<br>
<a href="javascript:window.open('','_self').close();">close window</a>
<h1>
$title --- Full Display
</h1>
<br>
<table style="margin:auto; text-align:center;">
<tr>
<td style='text-align:left; padding:5px; border:1px solid black'>
EOF

#   printf ("%-20s <I>%s</I><br>",'server_send_time',$server_send_time);

    print "<div style='text-align:left'>";
    print "<pre>\n";
    print "<b>Point of Origin</b>\n";
    printf( "%-20s <I>%-13s</I>\n", 'observer title', $observer_title );
    printf( "%-20s <I>%-13s</I>\n", 'observer', $observer );
    printf( "%-20s <I>%-13s</I>\n", 'email', $email );
    printf( "%-20s <I>%-13s</I>\n", 'call sign', $csgn_name );
    printf( "%-20s <I>%-13s</I>\n", 'ship title', $ship_title );
    printf( "%-20s <I>%-13s</I>\n", 'ship name' ,$ship_name );
    if( $lat )
    {
      print "latitude              $lat\n";
      print "Longitude             $lon\n";
    }

    print "<b>Time of Submission</b>\n";
    printf( "%-20s <I>%-13s</I>\n", 'year', $sub_yr );
    printf( "%-20s <I>%-13s</I>\n", 'month', $sub_mo );
    printf( "%-20s <I>%-13s</I>\n", 'day', $sub_day );
    printf( "%-20s <I>%-13s</I>\n", 'hour', $sub_hr );
    printf( "%-20s <I>%-13s</I>\n", 'minute', $sub_min );

    print "<b>Security Information</b>\n";
    printf( "%-20s <I>%-40s</I>\n", 'classification type', $clas_type );
    printf( "%-20s <I>%-40s</I>\n", 'class authority', $cls_ath );
    printf( "%-20s <I>%-40s</I>\n", 'reason', $cls_rsn );
    printf( "%-20s <I>%-40s</I>\n", 'derived from', $cls_doc );
    printf( "%-20s <I>%-40s</I>\n", 'caveats', $cls_cvt );
    printf( "%-20s <I>%-40s</I>\n", 'clas select', $cls_sel );
    printf( "%-20s <I>%-40s</I>\n", 'declas select', $dcls_sel );
    printf( "%-20s <I>%-40s</I>\n", 'declas days', $dcls_tday );
    printf( "%-20s <I>%-40s</I>\n", 'declas year', $dcls_yr );
    printf( "%-20s <I>%-40s</I>\n", 'declas month', $dcls_mon );
    printf( "%-20s <I>%-40s</I>\n", 'declas day', $dcls_day );
    print "</pre>\n";
    print "</div>\n";

    print <<EOF;
</td>
</tr>
</table>
<br>
<table style="margin:auto; text-align:center;">
<tr>
<td style='text-align:left; padding:5px; border:1px solid black'>
<div style='text-align:left'>
<pre>
EOF

    if( $data_type eq "ship_taf" || $data_type eq "mob_taf" )
    {
      printf( "<b>%-20s</b>\n%s\n", 'upload_mobtaf', $upload_wmo_text_mobtaf );
    }

    if( $upload_wmo_text ne "" )
    {
      printf( "<b>%-20s</b>\n%s\n", 'upload_wmo_text', $upload_wmo_text );
    }

    if( $upload_wmo_file ne "" )
    {
      printf( "<b>%-20s</b>\n", 'upload_wmo_file' );
      printf( "%s", $upload_wmo_file_out );
    }

  print <<EOF;
</pre>
</div>
</td>
</tr>
</table>
</td>
</tr>
</table>
</body>
</html>
EOF

  }# End if results = full


   #
   # -------------------------
   #
  if( $results eq "message" || $results eq "submit" )
  {

    my $LINE;
    my $OUTPUT_TMP;
    if( $upload_wmo_text ne "" )
    {
      if( $data_type eq "ship_sfc" )
      {
        open( my $FILE, ">", "../dynamic/temp/wmo_file_$$" ) or die "../dynamic/temp/wmo_file_$$\n$!\n";
        printf( $FILE "%s", $upload_wmo_text );
        close( $FILE );

        $ENV{'WMO_FILE'} = "../dynamic/temp/wmo_file_$$";
        $OUTPUT = `$PROGBIN/dcmsfc_2 -v3 -d ../dynamic/temp/logdcmsfc_$$.out $static_msl_dir/sfc_stn_msl 2>&1`;
        $OUTPUT_TMP = `cat ../dynamic/temp/logdcmsfc_$$.out`;

        if( -e "../dynamic/temp/logdcmsfc_$$.out" )
        {
            unlink( "../dynamic/temp/logdcmsfc_$$.out" ) or warn  "Failed to delete '../dynamic/temp/logdcmsfc_$$.out'\n$!\n";
        }

        if( -e "../dynamic/temp/wmo_file_$$" )
        {
            unlink( "../dynamic/temp/wmo_file_$$" ) or warn  "Failed to delete '../dynamic/temp/wmo_file_$$'\n$!\n";
        }

      }
      elsif( $data_type eq "bathy" or 
             $data_type eq "tesac" or
             $data_type eq "xbt" )
      {
        open( my $FILE, ">", "../dynamic/temp/wmo_file_$$" ) or die "../dynamic/temp/wmo_file_$$\n$!\n";
        printf( $FILE "%s", $upload_wmo_text );
        close( $FILE );

        $ENV{'WMO_FILE'} = "../dynamic/temp/wmo_file_$$";
        $OUTPUT = `$PROGBIN/dcbthy_2 -v3 -d ../dynamic/temp/logdcbthy_$$.out dummytbl 2>&1`;
        $OUTPUT_TMP = `cat ../dynamic/temp/logdcbthy_$$.out`;

        system( "/bin/rm ../dynamic/temp/logdcbthy_$$.out" );
        system( "/bin/rm ../dynamic/temp/wmo_file_$$" );
      }
      elsif( $data_type eq "ship_raob" )
      {
        open( my $FILE, ">", "../dynamic/temp/wmo_file_$$" ) or die "../dynamic/temp/wmo_file_$$\n$!\n";
        printf( $FILE "%s", $upload_wmo_text );
        close( $FILE );

        $ENV{'WMO_FILE'} = "../dynamic/temp/wmo_file_$$";
        $OUTPUT = `$PROGBIN/dcusnd_2 -v3 -d ../dynamic/temp/logdcusnd_$$.out $static_msl_dir/sfc_stn_msl $static_msl_dir/shp_ref_lib 2>&1`;
        $OUTPUT_TMP = `cat ../dynamic/temp/logdcusnd_$$.out`;

        system( "/bin/rm ../dynamic/temp/logdcusnd_$$.out" );
        system( "/bin/rm ../dynamic/temp/wmo_file_$$" );
      }
    }

    if( $upload_wmo_file ne "" )
    {
      if( $data_type eq "ship_sfc" )
      {
        open( my $FILE, ">", "../dynamic/temp/wmo_file_$$" ) or die "../dynamic/temp/wmo_file_$$\n$!\n";
        printf( $FILE "%s", $upload_wmo_file_out );
        close( $FILE );

        $ENV{'WMO_FILE'} = "../dynamic/temp/wmo_file_$$";
        $OUTPUT = `$PROGBIN/dcmsfc_2 -v3 -d ../dynamic/temp/logdcmsfc_$$.out $static_msl_dir/sfc_stn_msl 2>&1`;
        $OUTPUT_TMP = `cat ../dynamic/temp/logdcmsfc_$$.out`;

        if( -e "../dynamic/temp/logdcmsfc_$$.out" )
        {
            unlink( "../dynamic/temp/logdcmsfc_$$.out" ) or warn  "Failed to delete '../dynamic/temp/logdcmsfc_$$.out'\n$!\n"
        }

        if( -e "../dynamic/temp/wmo_file_$$" )
        {
            unlink( "../dynamic/temp/wmo_file_$$" ) or warn  "Failed to delete '../dynamic/temp/wmo_file_$$'\n$!\n";
        }

      }
      elsif( $data_type eq "bathy" or 
             $data_type eq "tesac" or
             $data_type eq "xbt" )
      {
        open( my $FILE, ">", "../dynamic/temp/wmo_file_$$" ) or die "../dynamic/temp/wmo_file_$$\n$!\n";
        printf( $FILE "%s", $upload_wmo_file_out );
        close( $FILE );

        $ENV{'WMO_FILE'} = "../dynamic/temp/wmo_file_$$";
        $OUTPUT = `$PROGBIN/dcbthy_2 -v3 -d ../dynamic/temp/logdcbthy_$$.out dummytbl 2>&1`;
        $OUTPUT_TMP = `cat ../dynamic/temp/logdcbthy_$$.out`;

        system( "/bin/rm ../dynamic/temp/logdcbthy_$$.out" );
        system( "/bin/rm ../dynamic/temp/wmo_file_$$" );
      }
      elsif( $data_type eq "ship_raob" )
      {
        open( my $FILE, ">", "../dynamic/temp/wmo_file_$$" ) or die "../dynamic/temp/wmo_file_$$\n$!\n";
        printf( $FILE "%s", $upload_wmo_file_out );
        close( $FILE );

        $ENV{'WMO_FILE'} = "../dynamic/temp/wmo_file_$$";
        $OUTPUT = `$PROGBIN/dcusnd_2 -v3 -d ../dynamic/temp/logdcusnd_$$.out $static_msl_dir/sfc_stn_msl $static_msl_dir/shp_ref_lib 2>&1`;
        $OUTPUT_TMP = `cat ../dynamic/temp/logdcusnd_$$.out`;

        system( "/bin/rm ../dynamic/temp/logdcusnd_$$.out" );
        system( "/bin/rm ../dynamic/temp/wmo_file_$$" );
      }
      elsif( $data_type eq "ship_taf" || $data_type eq "mob_taf" )
      {
        $OUTPUT = "";
        $OUTPUT_TMP = "";
      }

    }#End $upload_wmo_file ne ""

    #
    # Check diagnostic output file for errors and wanrings
    #
    if($data_type eq "ship_taf" || $data_type eq "mob_taf")
    {
      $OUTPUT = "";
      $OUTPUT_TMP = "";
    }
    my @lines = split('\n',$OUTPUT);
    my $cnt_critical;
    my $cnt_warning;

    #my @station_id = grep( /Station ID/, @lines);
    #my @csgn = split(/\s+/,@station_id[0]);
    #my $CSGN = @csgn[2];
    #
    #my @ship_lat = grep( /Ship latitude/, @lines);
    #my @lat = split(/\s+/,@ship_lat[0]);
    #my $LAT = @lat[2];
    #
    #my @ship_lon = grep( /Ship longitude/, @lines);
    #my @lon = split(/\s+/,@ship_lon[0]);
    #my $LON= @lon[2];

    $cnt_warning = grep{ /WARNING/ } @lines;
    $cnt_critical = grep{ /ERROR/ } @lines;
    if( $cnt_critical )
    {
      $KEY_WORD = "ERROR";
    }
    elsif( $cnt_warning )
    {
      $KEY_WORD = "WARNING";
    }
    else
    {
      $KEY_WORD = "NO PROBLEMS";
    }

    my $OUTPUT_TMP_2;
    if( $KEY_WORD eq "ERROR" )
    {
      $OUTPUT_TMP_2="\nERROR --- Please check for coding errors and bad groups\n\n";
    }
    elsif( $KEY_WORD eq "WARNING" )
    {
      $OUTPUT_TMP_2 = "\nWARNING --- Please check for warnings\n\n";
    }
    else
    {
      $OUTPUT_TMP_2 = "NO ENCODING PROBLEMS";
    }

    if( $data_type ne "ship_taf" && $data_type ne "mob_taf" )
    {
      $OUTPUT_TMP_2="=========================== DIAGMOSTIC OUTPUT =========================";
      $OUTPUT = join("\n",$OUTPUT,$OUTPUT_TMP_2);
      $OUTPUT = join("\n",$OUTPUT,$OUTPUT_TMP);
    }
  }# End if results = message and submit

  #
  # -------------------------
  #
  if( $results eq "message" )
  {
    print <<EOF;
<!DOCTYPE html><html> <head> <title>report decoded</title> </head> <body>
<table style="margin:auto; text-align:center;">
<tr>
<td style='text-align:center;'>
<br>
<a href="javascript:window.open('','_self').close();">close window</a>
<h1>
$title --- Decoded
</h1>
<br>
<table>
<tr>
<td style='text-align:left; padding:5px; border:1px solid black'>
<pre>
EOF
    if( $data_type eq "ship_taf" || $data_type eq "mob_taf" )
    {
      if( $upload_wmo_text ne "" )
      {
        printf( "%s",$upload_wmo_text );
      }

      if( $upload_wmo_file ne "" )
      {
        printf( "%s", $upload_wmo_file_out );
      }
    }
    else
    {
      printf( "%s", $OUTPUT );
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
  }# End if results = message

  #
  # -------------------------
  #
  if( $results eq "submit" )
  {
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
    elsif( $KEY_WORD eq "ERROR" && $results eq "submit" )
    {
    print <<EOF;
<h1>
$title ERROR --- CHECK BEFORE RESUBMITING
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

    if( $data_type eq "ship_taf" || $data_type eq "mob_taf" )
    {
      printf( "<b>%-20s</b>\n%s\n", 'upload_mobtaf', $upload_wmo_text_mobtaf );

      if( $upload_wmo_text ne "" )
      {
        printf( "<b>%-20s</b>\n%s\n", 'upload_wmo_text', $upload_wmo_text );
      }

      if( $upload_wmo_file ne "" )
      {
        printf( "<b>%-20s</b>\n%s\n",'upload_wmo_file', $upload_wmo_file_out );
      }
    }
    else
    {
      printf( "%s", $OUTPUT );
    }

    if( $KEY_WORD eq "ERROR" )
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
  }# End if results = submit

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
  my $file_name = "encode_${data_type}.${csgn_name}.${sub_dtg}.${unq_num}" =~ /^([\w.]+)$/;
  $file_name = $1;
  my $output_file_name  = "../dynamic/archive/${clas}/${file_name}";
  open( my $DIAG, ">", $output_file_name ) or die "Can't open diagnostic file, $output_file_name\n$!\n";

#
# Set up an enocded file to go in the encoded and archive subdirectories
#
  my $sec_pre;
  $sec_pre = "j";

  my $yday_3 = sprintf("%03d", $yday_s); 
  my $encode_file_name = "${sec_pre}${yday_3}jo${unq_num}r";
  my $output_encode_file_name  = "../dynamic/encoded/${clas}/${encode_file_name}";
  open( my $ENCODE, ">", $output_encode_file_name ) or die "Can't open diagnostic file, $output_encode_file_name\n$!\n";

  my $product_name = "US058OMET-TXTsl1";
  $product_name = join( ".", $product_name, $send_dtg );
  $product_name = join( "_", $product_name, $encode_file_name );

  $dps_hdr = "BEGIN";
  $dps_hdr = join( "\n", $dps_hdr, $csgn_name );
  $dps_hdr = join( "\n", $dps_hdr, $product_name );
  if( $clas_type eq "U" )
  {
    $dps_hdr = join( "\n", $dps_hdr, "JXOBSU" );
  }
  elsif( $clas_type eq "C" )
  {
    $dps_hdr = join( "\n", $dps_hdr, "JXOBSC" );
  }
  else
  {
    $dps_hdr = join( "\n", $dps_hdr, "JXOBSS" );
  }
  $dps_hdr = join( "\n", $dps_hdr, "R" );
  $dps_hdr = join( "\n", $dps_hdr, $clas_type );
  $dps_hdr = join( "\n", $dps_hdr, "000" );
  $dps_hdr = join( "\n", $dps_hdr, "000" );
  $dps_hdr = join( "\n", $dps_hdr, "0000" );
  $dps_hdr = join( "\n", $dps_hdr, $send_dtg );
  if( $cls_cvt eq "" )
  {
    $dps_hdr = join( "\n", $dps_hdr, "NONE" );
  }
  else
  {
    $dps_hdr = join( "\n", $dps_hdr, $cls_cvt );
  }
 
  if( $clas_type eq "S" || $clas_type eq "C" )
  {
    if( $cls_sel == 1 )
    { 
      $dps_hdr = join( "\n", $dps_hdr, "DERIVED FROM:" );
      $dps_hdr = join( " ", $dps_hdr, $cls_doc );
    }
    else
    {
      $dps_hdr = join( "\n", $dps_hdr, "CLASSIFIED BY:" );
      $dps_hdr = join( " ", $dps_hdr, $cls_ath );
      $dps_hdr = join( "\n", $dps_hdr, "REASON:" );
      $dps_hdr = join( " ", $dps_hdr, $cls_rsn );
    }
    if( $dcls_sel == 3 )
    {
      $dcls_inst = $dcls_txt;
    }
    else
    {
      $dcls_inst = sprintf( "%02d %s %02d", $dcls_day, $month_name{ int("$dcls_mon") }, $dcls_yr-2000 );
#     $dcls_inst = sprintf("%04d-%02d-%02d", $dcls_y, $dcls_mon, $dcls_day);
    }
    $dps_hdr = join( "\n", $dps_hdr, "DECLASSIFY ON:" );
    $dps_hdr = join( " ", $dps_hdr, $dcls_inst );
  }#End if clas = s/c

  $dps_hdr = join( "\n", $dps_hdr, "SHIPNAME:" );
  $dps_hdr = join( " ", $dps_hdr, $ship_name );
  $dps_hdr = join( "\n", $dps_hdr, "END" );

  print( $DIAG "$dps_hdr\n" );
  print( $ENCODE "$dps_hdr\n" );

  if( $upload_wmo_text ne "" )
  {
    my @rpt_id_list = split( ",", $rpt_id );
    my $rpt_id_cnt = @rpt_id_list;
    my $temp_word;
    for( my $cnt = 0; $cnt < $rpt_id_cnt; $cnt++ )
    {
      $temp_word = $rpt_id_list[$cnt];
      $upload_wmo_text =~ s/\n$temp_word/=\n$temp_word/g;
    }

    my $encode_out;
    if( $data_type eq "ship_taf" || $data_type eq "mob_taf" )
    {
      $encode_out = join( "", $upload_wmo_text_mobtaf, "=" );
    }
    else
    {
      $encode_out = join( "", $upload_wmo_text, "=" );
    }

    print( $DIAG "$encode_out" );
    print( $ENCODE "$encode_out" );
  }#End upload_wmo_text
  else
  {
    my @rpt_id_list = split(",",$rpt_id);
    my $rpt_id_cnt = @rpt_id_list;
    my $temp_word;
    for( my $cnt = 0; $cnt < $rpt_id_cnt; $cnt++ )
    {
      $temp_word = $rpt_id_list[$cnt];
      $upload_wmo_file_out =~ s/\n$temp_word/=\n$temp_word/g;
    }

    my $encode_out;
    if( $data_type eq "ship_taf" || $data_type eq "mob_taf" )
    {
      $encode_out = join( "", $upload_wmo_text_mobtaf, "=" );
    }
    else
    {
      $encode_out = join( "", $upload_wmo_file_out, "=" );
    }

    print( $DIAG "$encode_out" );
    print( $ENCODE "$encode_out" );
  }#End else

  close( $DIAG );
  chmod( 0664, "$output_file_name" );
  close( $ENCODE );
  chmod( 0664, "$output_encode_file_name" );

  if( -e "../dynamic/temp/wmo_file_$$" )
  {
      unlink "../dynamic/temp/wmo_file_$$" or warn  "failed to delete ../dynamic/temp/wmo_file_$$\n$!\n";
  }

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

  my $file_name = "raw_${data_type}.${csgn_name}.${sub_dtg}.${unq_num}" =~ /^([\w.]+)$/;
  $file_name = $1;
  my $output_file_name  = "../dynamic/archive/$clas/${file_name}";
  open( my $FILE, ">", $output_file_name ) or die "Can't open $output_file_name\n$!\n";

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

  if( $lat ne "" )
  {
    print $FILE "latitude              $lat\n";
    print $FILE "Longitude             $lon\n";
  }
  
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

  if( ! defined( $upload_wmo_text ) )
  {
    $upload_wmo_text="";
  }

  if( ! defined( $upload_wmo_file ) )
  {
    $upload_wmo_file="";
  }

  if( ! defined( $upload_wmo_file_out ) )
  {
    $upload_wmo_file_out="";
  }

  print $FILE "\n----- WMO Message ----------\n";
  print $FILE "upload_wmo_text\n";
  print $FILE "$upload_wmo_text\n";
  print $FILE "upload_wmo_file\n";
  print $FILE "$upload_wmo_file_out\n";

  close( $FILE );
  chmod( 0664, "$output_file_name" );
 
  return();

}#End form_output

sub main
{

    # access subroutine arguments
    ($title, $data_type, $rpt_id) = @_;

    $title =~ s/[^a-zA-Z' ]//g;
    $data_type =~ s/[^a-zA-Z_]//g;
    $rpt_id =~ s/[^A-Z,]//g;

    # setup web directory.
    my @str_array = split( "\/", $ENV{SCRIPT_NAME} );
    $sub_dir = $str_array[1];
    $web_dir = "$ENV{SERVER_NAME}/$sub_dir";

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
      $results = $q->param("results");

      if ( ! defined( $results ) )
      {
        print "Content-type: text/html; charset=utf-8\n\n";
        print "<!DOCTYPE html><html><head><title>IMPROPER SUBMISSION</title></head><body>\n";
        print "<h1 style='text-align:center;'>";
        print "IMPROPER SUBMISSION";
        print "</h1>";
        print "</body></html>";

        exit;
      }

      $results =~ s/[^a-zA-Z_]//g;

      if( $data_type ne "ship_taf" && $data_type ne "mob_taf" )
      {
        ( $accept_location = $q->param("accept_location") ) =~ s/[^a-zA-Z_]//g;
      }
      else
      {
        #Accept location for now.
        $accept_location = "yes";
      }

      #
      # Process form output if present
      #
      if( $results         eq "submit"   &&
          $accept_location eq "no"       &&
          $data_type       ne "ship_taf" &&
          $data_type       ne "mob_taf" )
      {
        &redo_location_mess();
        &cleanup();
        exit;
      }

      ( $server_send_time    = $q->param("server_send_time") )    =~ s/[^0-9_]//g;
      ( $client_receive_time = $q->param("client_receive_time") ) =~ s/[^0-9_]//g;
      ( $client_send_time    = $q->param("client_send_time") )    =~ s/[^0-9_]//g;
      ( $submit_type         = $q->param("submit_type") )         =~ s/[^a-zA-Z_]//g;

      &form_input();

      if( $results         eq "submit"   && #submit observation
          $accept_location eq "unk"      &&
          $data_type       ne "ship_taf" &&
          $data_type       ne "mob_taf" )
      {
        &check_location();
      }
      elsif( $results         eq "submit"   && #submit observation
             $accept_location eq "yes"      ||
             $data_type       eq "ship_taf" ||
             $data_type       eq "mob_taf" )
      {
        &activity_file();
        &diag_output();

        if( $ERROR eq "NO" )
        {
          &process_data();
          &form_output();

          if( $data_type ne "ship_taf" && $data_type ne "mob_taf" )
          {
            &cleanup();
          }
        }
        else
        {
          &cleanup();
          exit;
        }  
      }# End submit yes
      elsif( $results eq "message" ) #display encode message only
      {
        &diag_output();
      }
      elsif( $results eq "full" ) #display full report
      {
        &diag_output();
      }
      else
      {
       &resubmit_output();
        &cleanup();
      }
    }# End if $q->param();
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

#        print "Content-type: text/html; charset=utf-8\n\n";
#        print "<!DOCTYPE html><html><head><title>missing id</title></head><body>\n";
#        print "<h1 style='text-align:center;'><body><html>";
#        print " <br>";
#        print " <br>";
#        print " <br>";
#        print " <br>";
#        print "</h1>";
#        print "</body></html>";
#
#        exit;
