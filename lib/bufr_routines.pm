#!/usr/bin/perl -w

package bufr_routines;

use warnings;
use strict;
use lib qw( /fnmoc/web/webservices/apache/app/common/lib );
use POSIX qw( uname );
use lib "/fnmoc/u/curr/lib/perllib";
use CGI;

use vars qw($title $data_type $source);

# bookkeeping variables
use vars qw($sub_dir $web_dir $remote_id $browser_type $q);

# values that are from web form input
    
# Data process method
use vars qw($results);

# point of origin
use vars qw($observer_title $observer $email $csgn_name $ship_title $ship_name);

# time of submission
use vars qw($sub_yr $sub_mo $sub_day $sub_hr $sub_min);

# security information
use vars qw($clas_type $cls_sel $cls_cvt $cls_ath $cls_rsn $cls_doc
     $dcls_sel $dcls_yr $dcls_mon $dcls_day $dcls_tday $dcls_txt);

# WMO message
use vars qw($bufr_type $upload_bufr_file);

# values that are determined internally and sent to web page
use vars qw($server_send_time $client_receive_time $client_send_time $submit_type $accept_location);

# values that are determined internally
use vars qw($sec_s $min_s $hour_s $mday_s $mon_s $year_s $wday_s $yday_s $isdat_s
     $remote_id $clas
     $fh
     $sub_dtg
     $dcls_sec $dcls_min $dcls_hr $dcls_wday $dcls_yday $dcls_isdat $dcls_inst
     $server_receive_time
     $actl_ob_hr $actl_ob_min
     $dps_hdr $send_dtg
     $sub_time);

use vars qw($bufr_file);

use vars qw($ERROR);

use vars qw($bufr_hdr);

use vars qw($bufr_hdr_rev);


#----------------------------------------------------------------------------------------------------------------------
# Start Subroutines
sub cleanup
{
  unlink "../dynamic/temp/location_check_plot_$$.png" ;
  unlink "../dynamic/temp/bufr_file_$$" ;
  unlink "../dynamic/temp/bufr_file_rev_$$" ;

  return();

}#End cleanup

sub generate_html
{
    #
    # Create the html file and send to client
    #
    use lib "../lib";
    use sys_info qw(getDevLevel getHostClass getAppName);
    use web_routines qw(getClasBnr getClas);
    
    my $IN;

    #
    # Create the html file and send to client
    #
    print "Content-type: text/html; charset=utf-8\n\n";

    if( $source eq "shp" )
    {
        open( $IN, "<", "../html/bufr_shp_form.html_template" ) or die "Can't open ../html/bufr_shp_form.html_template: $!";
    }
    else
    {
        open( $IN, "<", "../html/bufr_lnd_form.html_template" ) or die "Can't open ../html/bufr_lnd_form.html_template: $!";
    }

  #
  # Need to parse the including file and set the value of server_send_time to a
  # unique value. This could be YYYYMMDDHHMMSS.  This value would be saved
  # in ain id  log file along with the ship's call sign and possibly the obs time.
  # To guard against diplicate resubission through the use of the browser's
  # refresh, the log file would be checked.
  #
  (my $sec, my $min, my $hour, my $mday, my $mon, my $year, my $wday, my $yday, my $isdat) = gmtime;

  use vars qw($form_intro);
  use vars qw($clas_banner);

  $year = $year + 1900;
  $mon  = $mon +1;

  my $date_time = join ("_",$year, $mon, $mday, $hour, $min, $sec);

  #
  # select data type
  #
  if($data_type eq "bufr_shp" || $data_type eq "bufr_lnd" )
  {
    $form_intro="BUFR UPLOAD";
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
    if(index($_,'//') == 0)
    {
      next;
    }
    s/#WEB_DIR#/$web_dir/g;
    s/#TITLE#/$title/g;
    s/#DATA_TYPE#/$data_type/g;
    s/#FORM_INTRO#/$form_intro/g;
    s/#FORM_STAT#/$date_time/g;
    s/#SUBMIT_TYPE#/bufr/g;
    s/#CLAS_BANNER#/$clas_banner/g;

    if ( getHostClass() eq "secret" )
    { 
      s/#CLAS_LABEL#/clas/g;
    }
    else
    {
      s/#CLAS_LABEL#/unclas/g;
    }

    if(index($_,"#COL_INSERT#") >=0)
    {
       open( my $INS, "<", "../html/color_insert.html_template" ) or die "Can't open '../html/color_insert.html_template': $!";
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
    elsif(index($_,"#ORG_INSERT#") >=0)
    {
        my $clas = getHostClass();
        my $mail;

        if( $clas eq "secret" ){ $mail = "check_email_clas"; }
        else                   { $mail = "check_email_unclas"; }

        if( $source eq "shp" )
        {
            system( "../cgi-bin/origin_insert.cgi", $mail );
        }
        else
        {
            system( "../cgi-bin/origin_lnd_insert.cgi", $mail, "Call sign" );
        }
    }#End ORG_INSERT
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
        if(index($_,'//') == 0)
        {
          next;
        }

        if(getClas() eq "training")
        {
          s/#TRAINING#/  (FOR TRAINING PURPOSES ONLY/g;
        }
        else
        {
          s/#TRAINING#//g;
        }

        if(getHostClass() eq "unclas")
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
    elsif( index( $_, "#BUFR_INSERT#" ) >= 0 )
    {
       open( my $INS, "<", "../html/bufr_insert.html_template" ) or die "../html/bufr_insert.html_template: $!";
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
    else
    {
      if(index($_,'//') == 0)
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
  my $USERS;
  #
  # Use activity file to record web page useage
  #

  #
  # Create activity log if it isn't there.
  #
  if (! -e "../dynamic/activity_logs/${data_type}_activity.log")
  {
    open( $USERS, ">", "../dynamic/activity_logs/${data_type}_activity.log" ) || die "Can't open ${data_type}_activity.log: $!";
    close( $USERS );
    chmod (0664, "../dynamic/activity_logs/${data_type}_activity.log");
  }

  #
  # Check if this is an accidental resubmital from a browser refresh
  #
  open( $USERS, "<", "../dynamic/activity_logs/${data_type}_activity.log" ) || die "Can't open ${data_type}_activity.log: $!";

  my @users  = <$USERS>;
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
  ($sec_s, $min_s, $hour_s, $mday_s, $mon_s, $year_s, $wday_s, $yday_s, $isdat_s) = gmtime;

  $year_s = $year_s + 1900;
  $mon_s  = $mon_s + 1;
  $yday_s  = $yday_s + 1;
  $server_receive_time = join("_", $year_s, $mon_s, $mday_s, $hour_s, $min_s, $sec_s);
  $send_dtg = sprintf("%4d%02d%02d%02d%02d%02d",$year_s, $mon_s,$mday_s, $hour_s, $min_s, $sec_s);

  my $log_filename = "${data_type}_activity.log";
  my $log_file = "../dynamic/activity_logs/$log_filename";

  open( $USERS, ">>", $log_file ) || die "Can't open $log_file: $!";
  flock $USERS, 2;
  print $USERS "$csgn_name $remote_id svr_snd $server_send_time\n";
  print $USERS "$csgn_name $remote_id clt_rcv $client_receive_time\n";
  print $USERS "$csgn_name $remote_id clt_snd $client_send_time\n";
  print $USERS "$csgn_name $remote_id svr_rcv $server_receive_time\n";
  print $USERS "$csgn_name $remote_id sb_time $sub_time\n";
  print $USERS "--------------------------------------------------\n";
  close( $USERS );
  chmod (0664, "../dynamic/activity_logs/${data_type}_activity.log");

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
  if( $source eq "shp" ){ ( $observer_title = $q->param("observer_title") ) =~ s/[^a-zA-Z0-9. ]//g; }
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

  if( $source eq "shp" )
  {
      ( $ship_name      = $q->param("ship_name") ) =~ s/[^a-zA-Z ]//g;
      $ship_name      =~ tr/a-z/A-Z/;               # all characters to uppercase
      ($ship_title     = $q->param("ship_title")) =~ s/[^a-zA-Z]//g;
      $ship_title     =~ tr/a-z/A-Z/;               # all characters to uppercase
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


  ($bufr_type =  $q->param("bufr_type")) =~ s/[^a-z]//g;
  ($upload_bufr_file =  $q->param("upload_bufr_file")) =~ s/[^a-zA-Z0-9.-_\/]//g;

  if($upload_bufr_file ne "")
  {
      my $buffer = "";
      my $bytes;
      $fh = $q->upload( "upload_bufr_file");
      binmode( $fh, ":raw" );
      #
      # Copy BUFR file
      #
      open( my $UPLOADFILE, ">", "../dynamic/temp/bufr_file_$$" ) or die "Failed to open ../dynamic/temp/bufr_file_$$: $!";
      binmode( $UPLOADFILE, ":raw" );

      while ( <$fh> )
      {
         print $UPLOADFILE $_ ;
      }
      close( $UPLOADFILE );
      #
      # Check BUFR file and set $ERROR
      #
      use autodie;
      open( my $fhdr, '<:raw', "../dynamic/temp/bufr_file_$$" ) or die "Failed to open ../dynamic/temp/bufr_file_$$: $!";

      read( $fhdr, $bytes, 4 );

      #die 'Got $bytes_read but expected 4' unless $bytes_read == 4;
      close( $fhdr );

      $ERROR="no";
      $bufr_hdr = unpack 'a4', $bytes;

      if($bufr_hdr ne "BUFR")
      {
        $ERROR="yes";
      }

      system "cat ../dynamic/temp/bufr_file_$$ | tail -c 4 >| ../dynamic/temp/bufr_file_rev_$$";
      open( $fhdr, '<', "../dynamic/temp/bufr_file_rev_$$" ) or die "Failed to open ../dynamic/temp/bufr_file_rev_$$: $!";
      binmode( $fhdr, ":raw" );
      read( $fhdr, $bytes, 4 );
      close( $fhdr );
      my $bytes_rev = $bytes;
      $bufr_hdr_rev = unpack 'a4', $bytes_rev;
      if($bufr_hdr_rev ne "7777")
      {
        $ERROR="yes";
      }
      #unlink "../dynamic/temp/bufr_file_rev_$$";
  }

  return();

}#End form_input

sub diag_output
{
  use lib "../lib";
  use sys_info qw(getDevLevel getHostClass getAppName);

  #
  # Return diagnostic display of input after submission
  #

  #
  # Set variables needed by decoders
  #

  my $ETC_DIR = "/fnmoc/u/curr/etc/static/app/j-obs_batch";
  my $PROGBIN = "/fnmoc/u/curr/bin";

  $ENV{'GEMTBL'} = "$ETC_DIR/tables";
  $ENV{'GEMERR'} = "$ETC_DIR/error";
  $ENV{'GEMHLP'} = "$ETC_DIR/help";

  print "Content-type: text/html; charset=utf-8\n\n";

  if( $results eq "submit" )
  {
    print <<EOF;
<!DOCTYPE html><html> <head> <title>report submission</title> </head> <body>
<table>
<tr>
<td style='text-align:center;'>
<br> <a href=\"javascript:window.open('','_self').close();\">close window</a>
EOF
    if ($ERROR eq "yes")
    {
    print <<EOF;
<h1>
UPLOADED FILE IS NOT PROPERLY STRUCTURED AS BUFR
<br>
$bufr_hdr ... $bufr_hdr_rev
<br>
$title ERROR --- RESUBMIT
<br>
EOF
    }
    else
    {
    print <<EOF;
<h1>
#$title --- Submission Complete
<br>
EOF
    }

    print scalar (gmtime);
    print "<br> remote id: $remote_id";
    print "<br> web browser type: $browser_type";
    print "</h1>";
    print <<EOF;
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

  $sub_dtg = sprintf("%4d%02d%02d%02d%02d%02d",$sub_yr, $sub_mo, $sub_day, $sub_hr, $sub_min, 00);

  #
  # write out values into a diagnostic file
  #
  my $file_name = "encode_${data_type}.$csgn_name.$sub_dtg.$unq_num" =~ /^([\w.]+)$/;
  $file_name = $1;
  my $output_file_name  = "../dynamic/archive/$clas/$file_name";
  open( my $DIAG, ">", "../dynamic/temp/diag_$$" ) or die "Can't open diagnostic file, ../dynamic/temp/diag_$$: $!";

  #
  # Set up an enocded file to go in the encoded and archive subdirectories
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
  my $encode_file_name = "${sec_pre}${yday_3}jb${unq_num}r";
  my $output_encode_file_name  = "../dynamic/encoded/$clas/$encode_file_name";
  open( my $ENCODE, ">", "../dynamic/temp/encode_$$" ) or die "Can't open diagnostic file, ../dynamic/temp/encode_$$: $!";

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
    if($dcls_sel == 3)
    {
      $dcls_inst = $dcls_txt;
    }
    else
    {
      $dcls_inst = sprintf("%02d %s %02d", $dcls_day, $month_name{int("$dcls_mon")}, $dcls_yr-2000);
      #$dcls_inst = sprintf("%04d-%02d-%02d", $dcls_y, $dcls_mon, $dcls_day);
    }
    $dps_hdr = join("\n", $dps_hdr, "DECLASSIFY ON:");
    $dps_hdr = join(" ", $dps_hdr, $dcls_inst);
  }

  $dps_hdr = join("\n", $dps_hdr, "SHIPNAME:");
  $dps_hdr = join(" ", $dps_hdr, $ship_name);
  $dps_hdr = join("\n", $dps_hdr, "BUFR_DATA_TYPE: ");
  $dps_hdr = join(" ", $dps_hdr, $bufr_type);
  $dps_hdr = join("\n", $dps_hdr, "END");

  print( $DIAG "$dps_hdr\n" );
  print( $ENCODE "$dps_hdr\n" );

  close( $DIAG );
  close( $ENCODE );
  system  "cat ../dynamic/temp/diag_$$ ../dynamic/temp/bufr_file_$$ >| $output_file_name";
  chmod (0664, "$output_file_name");
  system  "cat ../dynamic/temp/encode_$$ ../dynamic/temp/bufr_file_$$ >| $output_encode_file_name";
  chmod (0664, "$output_encode_file_name");
  #unlink "../dynamic/temp/bufr_file_$$";

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
  my $output_file_name  = "../dynamic/archive/$clas/$file_name";
  open( my $FILE, ">", "../dynamic/temp/raw_$$" ) or die "Can't open ../dynamic/temp/raw_$$: $!";

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
  print $FILE "\n----- BUFR FILE ----------\n";
  close( $FILE );
  system  "cat ../dynamic/temp/raw_$$ ../dynamic/temp/bufr_file_$$ >| $output_file_name";
  chmod (0664, "$output_file_name");
 
  return();

}#End form_output

sub main
{
    # access subroutine arguments
    ( $title, $data_type, $source ) = @_;

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

      #
      # Process form output if present
      #
      ($server_send_time = $q->param("server_send_time")) =~ s/[^0-9_]//g;
      ($client_receive_time = $q->param("client_receive_time")) =~ s/[^0-9_]//g;
      ($client_send_time = $q->param("client_send_time")) =~ s/[^0-9_]//g;
      ($submit_type = $q->param("submit_type")) =~ s/[^a-zA-Z_]//g;

      &form_input();
      if($results eq "submit")
      {
        &activity_file();
        &diag_output();

        if($ERROR eq "no")
        {
          &process_data();
          &form_output();
        }

        #&cleanup();
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
