#!/usr/bin/perl -w

package wmo_lnd_routines;

use warnings;
use strict;
use lib qw(/fnmoc/web/webservices/apache/app/common/lib);
use POSIX qw( uname );

# subroutine arguments
use vars qw($title $data_type $rpt_id);

# bookkeeping variables
use vars qw($sub_dir $web_dir $remote_id $browser_type $q);

# values that are from web form input
    
# Data process method
use vars qw($results);

# point of origin
use vars qw($observer $email $stn_id $stn_name);

# time of submission
use vars qw($sub_yr $sub_mo $sub_day $sub_hr $sub_min);

# security information
use vars qw($clas_type $cls_sel $cls_cvt $cls_ath $cls_rsn $cls_doc
     $dcls_sel $dcls_yr $dcls_mon $dcls_day $dcls_tday $dcls_txt);

# WMO message
use vars qw($upload_wmo_text $upload_wmo_file $upload_wmo_text_mobtaf);

# values that are determined internally and sent to web page
use vars qw($server_send_time $client_receive_time $client_send_time $submit_type);

# values that are determined internally
use vars qw($sec_s $min_s $hour_s $mday_s $mon_s $year_s $wday_s $yday_s $isdat_s
     $remote_id $clas
     $q $fh
     $sub_dtg
     $dcls_sec $dcls_min $dcls_hr $dcls_wday $dcls_yday $dcls_isdat $dcls_inst
     $server_receive_time
     $actl_ob_hr $actl_ob_min
     $dps_hdr $send_dtg
     $sub_time);

use vars qw($upload_wmo_file_out);

use vars qw($ERROR);


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

    #
    # Limit file upload size
    #
    #use constant MAX_FILE_SIZE => 5_000;

    return();

}

#
# ================== initialize_taf =================
#

sub initialize_taf
{
    # land location
    use vars qw($lat $lon $lat_sign $lon_sign
         $oct $Q $quad $stn_ht $LaLaLa $LoLoLo $group $section_m);

    return();

}#End initialize_taf


#
# ==================== Begin Functions ===================
#

sub generate_html
{
  #
  # Create the html file and send to client
  #
  use lib ".";
  use sys_info qw(getDevLevel getHostClass getAppName);
  use web_routines qw(getClasBnr getClas);

  my $IN;
  my $stn_id;

  #
  # Create the html file and send to client
  #
  print "Content-type: text/html; charset=utf-8\n\n";

  if( $data_type eq "mob_taf" )
  {
    open( $IN, "<", "../html/wmo_form_lnd_taf.html_template" ) or die "Can't open ../html/wmo_form__lnd_taf.html_template: $!";
  }
  else
  {
    open( $IN, "<", "../html/wmo_lnd_form.html_template" ) or die "Can't open ../html/wmo_lnd_form.html_template: $!";
  }

  #
  # Need to parse the including file and set the value of server_send_time to a
  # unique value. This could be YYYYMMDDHHMMSS.  This value would be saved
  # in ain id  log file along with the station's name and possibly the obs time.
  # To guard against diplicate resubission through the use of the browser's
  # refresh, the log file would be checked.
  #
  ( my $sec, my $min, my $hour, my $mday, my $mon, my $year, my $wday, my $yday, my $isdat ) = gmtime;

  # use vars qw($form_intro);
  use vars qw($clas_banner);

  $year = $year + 1900;
  $mon  = $mon +1;

  my $date_time = join ( "_", $year, $mon, $mday, $hour, $min, $sec );

  #
  # select data type
  #
  if( $data_type eq "lnd_fx_sfc" || $data_type eq "lnd_fx_raob" )
  {
    $stn_id = "Station number";
  }
  
  if( $data_type eq "lnd_mo_sfc" || $data_type eq "lnd_mo_raob" )
  {
    $stn_id = "Call sign";
  }

  if( $data_type eq "mob_taf" )
  {
    $stn_id = "Call sign";
  }

  if($data_type eq "metar" || $data_type eq "taf")
  {
    $stn_id = "ICAO";
  }

  $clas_banner=getClasBnr();

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
    #s/#FORM_INTRO#/$form_intro/g;
    s/#FORM_STAT#/$date_time/g;
    s/#SUBMIT_TYPE#/wmo/g;
    s/#WMO_ID#/$rpt_id/g;
    s/#CLAS_BANNER#/$clas_banner/g;

    if ( getHostClass() eq "secret" )
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
         if( index( $_,'//' ) == 0 )
         {
           next;
         }
         print;
       }
       close( $INS );
    }
    elsif( index( $_, "#ORG_INSERT#" ) >= 0 )
    {
        my $clas = getHostClass();
        my $mail;

        if( $clas eq "secret" ){ $mail = "check_email_clas"; }
        else                   { $mail = "check_email_unclas"; }

        system( "../cgi-bin/origin_lnd_insert.cgi", $mail, $stn_id );

    }
    elsif( index( $_, "#LOC_INSERT#" ) >= 0 )
    {
      if($data_type eq "mob_taf")
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

       if( $data_type eq "mob_taf" )
       {
         open( $INS, "<", "../html/wmo_taf_insert.html_template" ) or die "../html/wmo_taf_insert.html_template: $!";
       }
       else
       {
         open( $INS, "<", "../html/wmo_insert.html_template" ) or die "../html/wmo_insert.html_template: $!";
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
  if( ! -e "../dynamic/activity_logs/${data_type}_activity.log" )
  {
    open( my $USERS, ">", "../dynamic/activity_logs/${data_type}_activity.log" ) || die "Can't open ${data_type}_activity.log: $!";
    close( $USERS );
    chmod( 0664, "../dynamic/activity_logs/${data_type}_activity.log" );
  }

  #
  # Check if this is an accidental resubmital from a browser refresh
  #
  open( my $USERS, "<", "../dynamic/activity_logs/${data_type}_activity.log" ) || die "Can't open ${data_type}_activity.log: $!";

  my @users = <$USERS>;
  close( $USERS );
  chmod( 0664, "../dynamic/activity_logs/${data_type}_activity.log" );
  my $new_user = "$stn_id $remote_id ob_time $sub_time";

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
  # Should wait until another application unlocks activity log
  #
  ( $sec_s, $min_s, $hour_s, $mday_s, $mon_s, $year_s, $wday_s, $yday_s, $isdat_s ) = gmtime;

  $year_s = $year_s + 1900;
  $mon_s  = $mon_s + 1;
  $yday_s  = $yday_s + 1;
  $server_receive_time = join("_", $year_s, $mon_s, $mday_s, $hour_s, $min_s, $sec_s);
  $send_dtg = sprintf( "%4d%02d%02d%02d%02d%02d", $year_s, $mon_s,$mday_s, $hour_s, $min_s, $sec_s );

  my $log_filename = "${data_type}_activity.log";
  my $log_file = "../dynamic/activity_logs/$log_filename";

  open( $USERS, ">>", $log_file ) || die "Can't open $log_file: $!";
  flock $USERS, 2;
  print $USERS "$stn_id $remote_id svr_snd $server_send_time\n";
  print $USERS "$stn_id $remote_id clt_rcv $client_receive_time\n";
  print $USERS "$stn_id $remote_id clt_snd $client_send_time\n";
  print $USERS "$stn_id $remote_id svr_rcv $server_receive_time\n";
  print $USERS "$stn_id $remote_id sb_time $sub_time\n";
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
  ($observer       = $q->param("observer")) =~ s/[^a-zA-Z]//g;
  # webservices 8 Fast and flexible email validation
  my $expr;
  #$expr = '^(([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?))$';
  # webservices 9 Email validation which complies with RFC 2822
  $expr = '^(((\"[^\"\f\n\r\t\b]+\")|([\w\!\#\$\%\&\'\*\+\-\~\/\^\`\|\{\}]+(\.[\w\!\#\$\%\&\'\*\+\-\~\/\^\`\|\{\}]+)*))@((\[(((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9])))\])|(((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9])))|((([A-Za-z0-9\-])+\.)+[A-Za-z\-]+)))$';

  my $temp_var = $q->param("email") =~ /$expr/;
  if( ! defined( $temp_var ) )
  {
    $email = "not valid";
  }
  else
  {
    $email = $q->param("email");
  } 

  ($stn_id   = $q->param("stn_id")) =~ s/[^a-zA-Z0-9]//g;
  $stn_id    =~ tr/a-z/A-Z/;               # all characters to uppercase 
  ($stn_name = $q->param("stn_name")) =~ s/[^a-zA-Z0-9 ]//g;
  $stn_name  =~ tr/a-z/A-Z/;               # all characters to uppercase

  # land location (for TAF only)

  if( $data_type eq "mob_taf" )
  {
    ($lat      = $q->param("lat")) =~ s/[^0-9.]//g;
    ($lon      = $q->param("lon")) =~ s/[^0-9.]//g;
    ($lat_sign = $q->param("lat_sign")) =~ s/[^NS]//g;
    ($lon_sign = $q->param("lon_sign")) =~ s/[^EW]//g;

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
    $group = join("","MOBTAF", $Q);
    $section_m = $group;

    # TAF
    $section_m = join( " ",$section_m, "TAF" );

    # CCCC
    my $CCCC = sprintf( "%4s",$stn_id );
    $section_m = join( " ", $section_m, $CCCC );

    # imimHHH
    my $imim = "//";
    my $HHH = sprintf( "%03.0f", $stn_ht / 10 );
    $group = join( "", $imim, $HHH );
    $section_m = join( " ", $section_m, $group );

    # LaLaLaLoLoLo
    $LaLaLa = sprintf( "%03.0f",$lat * 10 );
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

  }

   # security
  ($clas_type = $q->param("clas_type")) =~ s/[^UCS]//g;

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
    if($cls_sel eq "1")
    {
      ( $cls_doc = $q->param("cls_doc") ) =~ s/[^a-zA-Z0-9.-_:]//g;
      $cls_ath  = "";
      $cls_rsn  = "";
    }
    elsif( $cls_sel eq "2" )
    {
      $cls_doc  = "";
      ($cls_ath = $q->param("cls_ath")) =~ s/[^a-zA-Z0-9.-_:]//g;
      ($cls_rsn = $q->param("cls_rsn")) =~ s/[^a-zA-Z0-9.-_:]//g;
    }
    ( $dcls_sel = $q->param("dcls_sel") ) =~ s/[^a-zA-Z0-9.-_:]//g;
    if( $dcls_sel eq "1" )
    {
      ( $dcls_tday = $q->param("dcls_tday") ) =~ s/[^0-9]//g;
      $dcls_yr    = "";
      $dcls_mon   = "";
      $dcls_day   = "";
      $dcls_txt   = "";
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
    $dcls_sel  = "";
    $dcls_tday = "";
    $dcls_yr   = "";
    $dcls_mon  = "";
    $dcls_day  = "";
    $dcls_txt  = "";
    $cls_sel   = "";
    $cls_ath   = "";
    $cls_rsn   = "";
    $cls_doc   = "";
    $cls_cvt   = "";
  }

  # initialize
  if( $dcls_sel eq "1" )
  {
    if( $dcls_tday ne "" )
    {
      my $time_s = time + $dcls_tday * 86400;
      ( $dcls_sec, $dcls_min, $dcls_hr, $dcls_day, $dcls_mon, $dcls_yr, $dcls_wday, $dcls_yday, $dcls_isdat ) = gmtime($time_s);
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
  ( $sub_sec, $sub_min, $sub_hr, $sub_day, $sub_mo, $sub_yr, $sub_wday, $sub_yday, $sub_isdat ) = gmtime;
  $sub_mo = $sub_mo +1;
  $sub_yr = $sub_yr +1900;
  $sub_time = "${sub_yr}_${sub_mo}_${sub_day}_${sub_hr}_${sub_min}";

  # station information
  ( $stn_id   = $q->param("stn_id") ) =~ s/[^a-zA-Z0-9]//g;
  ( $stn_name = $q->param("stn_name") ) =~ s/[^a-zA-Z0-9 ]//g;

  # wmo message
  $upload_wmo_text =  $q->param("upload_wmo_text");
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
  #chomp($upload_wmo_text);                        # remove the trailing carriage return
  $upload_wmo_text =~ tr/a-z/A-Z/;                 # all characters to uppercase

  if( $upload_wmo_text ne "" )
  {
      my @rpt_id_list = split( ",", $rpt_id );
      my $rpt_id_cnt = @rpt_id_list;
      my $count = 0;
      my $one_line = $upload_wmo_text;
      $one_line =~ s/\n/ /g;   # create one line
      my @file_words = split( " ", $one_line );

      for( my $cnt = 0; $cnt < $rpt_id_cnt; $cnt++ )
      {
            $count = grep /$rpt_id_list[$cnt]/i , $upload_wmo_text;
            if( $count ){ last; }
      }

      if( $count == 0 )
      {
        print "Content-type: text/html; charset=utf-8\n\n";
        print "<!DOCTYPE html><html><head><title>missing</title></head><body>\n";
        print "<h1 style='text-align:center'>";
        print "WMO TEXT MESSAGE IS MISSING $rpt_id <br>";
        print "PLEASE RESUBMIT >br";
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
      $stn_id =~ tr/a-z/A-Z/;
      $count = 0;

      $count = grep /$stn_id/i, $upload_wmo_text;

      if( $count == 0 )
      {
        print "Content-type: text/html; charset=utf-8\n\n";
        print "<!DOCTYPE html><html><head><title>missing</title></head><body>\n";
        print "<h1 style='text-align:center;'>";
        print "WMO TEXT MESSAGE IS MISSING CALL SIGN: $stn_id <br>";
        print "PLEASE RESUBMIT <br>";
        print "$upload_wmo_text <br>";
        print "</h1>";
        print "</body></html>";

        exit;
      }

      # MOB TAF
      if( $data_type eq "mob_taf" )
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
      }
  }#End upload wmo text

  ( $upload_wmo_file =  $q->param("upload_wmo_file") ) =~ s/[^a-zA-Z0-9.-_+\/]//g;

  if( $upload_wmo_file ne "" )
  {
    my $buffer = "";
    $upload_wmo_file_out = "";
    $fh = $q->upload( "upload_wmo_file" );
    while( read( $fh, $buffer, 1024 ) )
    {
      #$buffer =~ tr/\n//d;                    # remove new line charaters
      #$buffer =~ tr/0-9A-Za-z\/\r\040//dc;    # allow only a-z, A-Z, 0-9,
      #                                        # carriage returns and blanks
      $buffer =~ tr/0-9A-Za-z\/\n\040,+-//dc; # allow only a-z, A-Z, 0-9,
                                              # new line characters and blanks
      $upload_wmo_file_out = join("", $upload_wmo_file_out, $buffer);
    }
    #$upload_wmo_file_out =~ tr/\r/\n/;       # switch carriage returns
    #                                         # with new line characters
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
      print "<!DOCTYPE html><html><head><title>missing id</title></head><body>\n";
      print "<h1 style='text-align:center'>";
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
      print "<!DOCTYPE html><html><head><title>missing id</title></head><body>\n";
      print "<h1 style='text-align:center'>";
      print "UPLOADED WMO MESSAGE FILE DOES NOT HAVE $rpt_id AT BEGINNING<br>";
      print "PLEASE RESUBMIT <br> ";
      print "$upload_wmo_file_out <br>";
      print "</h1>";
      print "</body></html>";

      exit;
    }

    # check for call sign with message
    $count = 0;
    $stn_id =~ tr/a-z/A-Z/;
    $count = grep /$stn_id/i, $upload_wmo_file_out;

    if( $count == 0 )
    {
      print "Content-type: text/html; charset=utf-8\n\n";
      print "<!DOCTYPE html><html><head><title>missing</title></head><body>\n";
      print "<h1 style='text-align:center;'>";
      print "WMO TEXT MESSAGE IS MISSING CALL SIGN: $stn_id <br>";
      print "PLEASE RESUBMIT <br>";
      print "$upload_wmo_file_out <br>";
      print "</h1>";
      print "</body></html>";

      exit;
    }


    # MOB TAF
    if( $data_type eq "mob_taf" )
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
  }

  return();

}#End form_input

sub diag_output
{
  use lib qw(.);
  use sys_info qw(getDevLevel getHostClass);

  #
  # Return diagnostic display of input after submission
  #

  #
  # Set variables needed by decoders
  #

  $ERROR = "NO";
  my $OUTPUT;
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
<h1>
$title --- Full Display
</h1>
<br>
<table style="margin:auto; text-align:center;">
<tr>
<td style='text-align:left; padding:5px; border:1px solid black'>
EOF

    #printf ("%-20s <I>%s</I><br>",'server_send_time',$server_send_time);

    print "<div style='text-align:left'>";
    print "<pre>\n";
    print "<b>Point of Origin</b>\n";
    printf( "%-20s <I>%-13s</I>\n", 'observer', $observer );
    printf( "%-20s <I>%-13s</I>\n", 'email', $email );
    printf( "%-20s <I>%-13s</I>\n", 'station id', $stn_id );
    printf( "%-20s <I>%-13s</I>\n", 'station name', $stn_name );

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

    if( $data_type eq "mob_taf" )
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

  }


  #
  # -------------------------
  #
  if( $results eq "message" || $results eq "submit" )
  {
    my $OUTPUT_TMP;
    if( $upload_wmo_text ne "" )
    {
      if( $data_type eq "lnd_mo_sfc" )
      {
        open( my $FILE, ">", "/tmp/wmo_file_$$" ) or die "Can't open /tmp/wmo_file_$$: $!";
        printf( $FILE "%s", $upload_wmo_text );
        close( $FILE );
        $ENV{'WMO_FILE'} = "/tmp/wmo_file_$$";
        $OUTPUT = `$PROGBIN/dcmsfc_2 -v3 -d /tmp/logdcmsfc_$$.out $ETC_DIR/tables/stns/sfc_stn_msl | grep -av ierr`; 
        $OUTPUT_TMP = `cat /tmp/logdcmsfc_$$.out`;
        system("/bin/rm /tmp/logdcmsfc_$$.out");
        system("/bin/rm /tmp/wmo_file_$$");
      } 
      elsif( $data_type eq "lnd_mo_raob" )
      {
        open( my $FILE, ">", "/tmp/wmo_file_$$" ) or die "Can't open /tmp/wmo_file_$$: $!";
        printf( $FILE "%s", $upload_wmo_text );
        close( $FILE );
        $ENV{'WMO_FILE'} = "/tmp/wmo_file_$$";
        $OUTPUT = `$PROGBIN/dcusnd_2 -v3 -d /tmp/logdcusnd_$$.out $ETC_DIR/tables/stns/sfc_stn_msl $ETC_DIR/tables/stns/shp_ref_lib | grep -av ierr`;
        $OUTPUT_TMP = `cat /tmp/logdcusnd_$$.out`;
        system("/bin/rm /tmp/logdcusnd_$$.out");
        system("/bin/rm /tmp/wmo_file_$$");
      }
    }

    if( $upload_wmo_file ne "" )
    {
      if( $data_type eq "lnd_mo_sfc" )
      {
        open( my $FILE, ">", "/tmp/wmo_file_$$" ) or die "Can't open /tmp/wmo_file_$$: $!";
        printf( $FILE "%s", $upload_wmo_file_out );
        close( $FILE );
        $ENV{'WMO_FILE'} = "/tmp/wmo_file_$$";
        $OUTPUT = `$PROGBIN/dcmsfc_2 -v3 -d /tmp/logdcmsfc_$$.out $ETC_DIR/tables/stns/sfc_stn_msl | grep -av ierr`;
        $OUTPUT_TMP = `cat /tmp/logdcmsfc_$$.out`;
        system("/bin/rm /tmp/logdcmsfc_$$.out");
        system("/bin/rm /tmp/wmo_file_$$");
        }
      elsif( $data_type eq "lnd_mo_raob" )
      {
        open( my $FILE, ">", "/tmp/wmo_file_$$" ) or die "Can't open /tmp/wmo_file_$$: $!";
        printf( $FILE "%s", $upload_wmo_file_out );
        close( $FILE );
        $ENV{'WMO_FILE'} = "/tmp/wmo_file_$$";
        $OUTPUT = `$PROGBIN/dcusnd_2 -v3 -d /tmp/logdcusnd_$$.out $ETC_DIR/tables/stns/sfc_stn_msl $ETC_DIR/tables/stns/shp_ref_lib | grep -av ierr`;
        $OUTPUT_TMP = `cat /tmp/logdcusnd_$$.out`;
        system("/bin/rm /tmp/logdcusnd_$$.out");
        system("/bin/rm /tmp/wmo_file_$$");
      }
      elsif( $data_type eq "mob_taf" )
      {
        $OUTPUT = "";
        $OUTPUT_TMP = "";
      }
    }

    #
    # Check diagnostic output file for errors and wanrings
    #
    if( $data_type eq "mob_taf" )
    {
      $OUTPUT = "";
      $OUTPUT_TMP = "";
    }
    my @lines = split('\n',$OUTPUT);
    my $cnt_critical = grep{ /WARNING/ } @lines;
    my $cnt_warning  = grep{ /ERROR/ } @lines;

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
      $OUTPUT_TMP_2 = "\nERROR --- Please check for errors\n\n";
    }
    elsif( $KEY_WORD eq "WARNING" )
    {
      $OUTPUT_TMP_2 = "\nWARNING --- Please check for warnings\n\n";
    }
    else
    {
      $OUTPUT_TMP_2 = "NO ENCODING PROBLEMS";
    }

    if( $data_type ne "mob_taf" )
    {
      $OUTPUT = join("\n",$OUTPUT,$OUTPUT_TMP_2);
      $OUTPUT_TMP_2="=========================== DIAGMOSTIC OUTPUT =========================";
      $OUTPUT = join("\n",$OUTPUT,$OUTPUT_TMP_2);
      $OUTPUT = join("\n",$OUTPUT,$OUTPUT_TMP);
    }
  }


  #
  # -------------------------
  #
  if( $results eq "message" )
  {
    print <<EOF;
<!DOCTYPE html><html> <head> <title>report decoded</title> </head> <body>
<table style="margin:auto; text-align:center;">
<tr>
<td>
<h1>
$title --- Decoded
</h1>
<br>
<table>
<tr>
<td style='text-align:left; padding:5px; border:1px solid black'>
<pre>
EOF
    if($data_type eq "mob_taf")
    {
      if($upload_wmo_text ne "")
      {
        printf ("%s",$upload_wmo_text);
      }

      if($upload_wmo_file ne "")
      {
        printf ("%s",$upload_wmo_file_out);
      }
    }
    else
    {
      printf("%s",$OUTPUT);
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
  }

  #
  # -------------------------
  #
  if( $results eq "submit" )
  {
    print <<EOF;
<!DOCTYPE html><html> <head> <title>report submission</title> </head> <body>
<table style="margin:auto; text-align:center;">
<tr>
<td style='text-align:center;'>
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

    if( $data_type eq "mob_taf" )
    {
      printf( "<b>%-20s</b>\n%s\n", 'upload_mobtaf', $upload_wmo_text_mobtaf );

      if( $upload_wmo_text ne "" )
      {
        printf( "<b>%-20s</b>\n%s\n", 'upload_wmo_text', $upload_wmo_text );
      }

      if( $upload_wmo_file ne "" )
      {
        printf( "<b>%-20s</b>\n%s\n", 'upload_wmo_file', $upload_wmo_file_out );
      }
    }
    else
    {
      printf( "%s", $OUTPUT );
    }

    if( $KEY_WORD eq "ERROR" )
    {
      $ERROR = "YES";
      printf( "%s\n","ERROR --- Please check encoded message for errors" );
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
  }

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
  my $file_name = "encode_${data_type}.$stn_id.$sub_dtg.$unq_num" =~ /^([\w.]+)$/;
  $file_name = $1;
  my $output_file_name  = "../dynamic/archive/$clas/$file_name";
  open( my $DIAG, ">", $output_file_name ) or die "Can't open diagnostic file, $output_file_name: $!";

  #
  # Set up an enocded file to go in the encoded and archive subdirectories
  #
  my $sec_pre;
  $sec_pre = "j";

  my $yday_3 = sprintf( "%03d", $yday_s ); 
  my $encode_file_name = "${sec_pre}${yday_3}jo${unq_num}r";
  my $output_encode_file_name  = "../dynamic/encoded/$clas/$encode_file_name";
  open( my $ENCODE, ">", $output_encode_file_name ) or die "Can't open diagnostic file, $output_encode_file_name: $!";

  my $product_name = "US058OMET-TXTsl1";
  $product_name = join( ".", $product_name, $send_dtg );
  $product_name = join( "_", $product_name, $encode_file_name );

  $dps_hdr = "BEGIN";
  $dps_hdr = join( "\n", $dps_hdr, $stn_id );
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
      $dcls_inst = sprintf( "%02d %s %02d", $dcls_day, $month_name{ int( "$dcls_mon" ) }, $dcls_yr-2000 );
#     $dcls_inst = sprintf("%04d-%02d-%02d", $dcls_y, $dcls_mon, $dcls_day);
    }
    $dps_hdr = join( "\n", $dps_hdr, "DECLASSIFY ON:" );
    $dps_hdr = join( " ", $dps_hdr, $dcls_inst );
  }

  $dps_hdr = join( "\n", $dps_hdr, "STNNAME:" );
  $dps_hdr = join( " ", $dps_hdr, $stn_name );
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
    if( $data_type eq "mob_taf" )
    {
      $encode_out = join( "", $upload_wmo_text_mobtaf, "=" );
    }
    else
    {
      $encode_out = join( "", $upload_wmo_text, "=" );
    }

    print( $DIAG "$encode_out" );
    print( $ENCODE "$encode_out" );
  }
  else
  {
    my @rpt_id_list = split( ",", $rpt_id );
    my $rpt_id_cnt = @rpt_id_list;
    my $temp_word;
    for( my $cnt = 0; $cnt < $rpt_id_cnt; $cnt++ )
    {
      $temp_word = $rpt_id_list[$cnt];
      $upload_wmo_file_out =~ s/\n$temp_word/=\n$temp_word/g;
    }
    my $encode_out = join( "", $upload_wmo_file_out, "=" );
    print( $DIAG "$encode_out" );
    print( $ENCODE "$encode_out" );
  }

  close( $DIAG );
  chmod( 0664, "$output_file_name" );
  close( $ENCODE );
  chmod( 0664, "$output_encode_file_name" );

  return();

}#End process_data

sub form_output
{
  #
  # Place input data into a file for archiving
  #

  my $unq_num;
  $unq_num   = $$;
  $unq_num = sprintf( "%010d", $unq_num );

  my $file_name = "raw_${data_type}.$stn_id.$sub_dtg.$unq_num" =~ /^([\w.]+)$/;
  $file_name = $1;
  my $output_file_name  = "../dynamic/archive/$clas/$file_name";

  open( my $FILE, ">", $output_file_name ) or die "Can't open $output_file_name: $!";

  print $FILE "--- Hidden Information ---\n";
  print $FILE "server_send_time      $server_send_time\n";
  print $FILE "client_receive_time   $client_receive_time\n";
  print $FILE "client_send_time      $client_send_time\n";
  print $FILE "submit_type           $submit_type\n";
  print $FILE "---- Point of Origin -----\n";
  print $FILE "observer              $observer\n";
  print $FILE "email                 $email\n";
  print $FILE "stn_id                $stn_id\n";
  print $FILE "station name          $stn_name\n";
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
    ( $title, $data_type, $rpt_id ) = @_;

    $title =~ s/[^a-zA-Z' ]//g;
    $data_type =~ s/[^a-zA-Z_]//g;
    $rpt_id =~ s/[^A-Z,]//g;

    # setup web directory.
    my @str_array=split( "\/", $ENV{SCRIPT_NAME} );
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
    #============================= Begin main script ===============================
    #

    if( $q->param() )
    {
    #
    # Process form output if present
    #

      $results = $q->param("results");
      if( ! defined( $results ) )
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
      ( $server_send_time = $q->param("server_send_time") ) =~ s/[^0-9_]//g;
      ( $client_receive_time = $q->param("client_receive_time") ) =~ s/[^0-9_]//g;
      ( $client_send_time = $q->param("client_send_time") ) =~ s/[^0-9_]//g;
      ( $submit_type = $q->param("submit_type") ) =~ s/[^a-zA-Z_]//g;

      &form_input();
      if( $results eq "submit" )
      {
        &activity_file();
        &diag_output();
        if( $ERROR eq "NO" )
        {
          &process_data();
          &form_output();
        }
      }
      elsif( $results eq "message" )
      {
        &diag_output();
      }
      elsif( $results eq "full" )
      {
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

