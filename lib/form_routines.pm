#!/usr/bin/perl -w

package form_routines;

use warnings;
use strict;
use lib qw(/fnmoc/web/webservices/apache/app/common/lib);

use vars qw($title $data_type);
use vars qw($sub_dir $web_dir $form_intro $form_explanation $remote_id $browser_type $q);
use vars qw($results $server_receive_time $server_send_time
            $client_receive_time $client_send_time $accept_location);
# activity_file
use vars qw($sec_s $min_s $hour_s $mday_s $mon_s $year_s $wday_s $yday_s $isdat_s $send_dtg);
# form_input
use vars qw($observer_title $observer $email $csgn_name $ship_title $ship_name
     $obs_yr $obs_mo $obs_day $obs_hr $obs_min
     $actl_ob_hr $actl_ob_min $obs_time
     $sub_yr $sub_mo $sub_day $sub_hr $sub_min $sub_time
     $clas_type $cls_sel $cls_cvt $cls_ath $cls_rsn $cls_doc $clas
     $dcls_sel $dcls_yr $dcls_mon $dcls_day $dcls_tday $dcls_txt
     $dcls_sec $dcls_min $dcls_hr $dcls_wday $dcls_yday $dcls_isdat $dcls_inst
     $mv_plfm_dir $mv_plfm_spd $mv_plfm_dir_id $mv_plfm_spd_id $mv_plfm_dir_1 $mv_plfm_spd_1
     $lat_sign $lat $lon_sign $lon $quad $oct
     $alt_set_type $alt_set $stn_ht $stn_lvl_pres_type $stn_lvl_pres $sea_lvl_pres
     $pres_tdcy_char_id $pres_tdcy_amt $std_isob_sfc $geop_std_isob_sfc
     $pres_wx_id $past_wx_id_1 $past_wx_id_2 $stn_type_id
     $air_temp_sign $air_temp $dwpt_sign $dwpt
     $rel_hum $wet_bulb_temp_sign $wet_bulb_temp $wet_bulb_temp_mthd
     $horz_sfc_vsby_type $horz_sfc_vsby $horz_sfc_vsby_id
     $wnd_dir $wnd_spd $wnd_mthd $wnd_dir_id $wnd_id
     $wnd_gst_type $wnd_gst $wnd_vrb_1 $wnd_vrb_2
     $prsnt_wx $sky_cdn $rmrks
     $tot_cld_amt $cld_base_ht $low_cld_amt
     $cld_base_ht_id $tot_cld_amt_id $low_cld_amt_id
     $low_cld_type_id $mid_cld_type_id $hi_cld_type_id
     $sea_temp_mthd $sea_temp
     $inst_wav_per $inst_wav_ht_1 $inst_wav_ht_2
     $wnd_wav_per $wnd_wav_ht
     $pri_swl_wav_dir $pri_swl_wav_ht $pri_swl_wav_per
     $scdy_swl_wav_dir $scdy_swl_wav_ht $scdy_swl_wav_per
     $ice_accr_cause $ice_accr_rate
     $ice_accr_cause_id $ice_accr_thkn $ice_accr_rate_id $sea_ice_conc_id
     $ice_dev_stage_id $ice_type_amt_id $ice_edge_brg_id $ice_sit_id
     $icing_rmrk $ice_rmrk
     $rpt_typ $rpt_typ_id $submit_type
     $day_utc $mon_utc $yr_utc $hr_utc $min_utc $units
     $lat_d $lat_m $lat_s $lon_sign $lon_d $lon_m $lon_s
     $bt_type $rcrdr @zz $profile_cnt @ttt $radio_call
     $zz0 $zz1 $zz2 $zz3 $zz4 $zz5 $zz6 $zz7 $zz8 $zz9
     $zz10 $zz11 $zz12 $zz13 $zz14 $zz15 $zz16 $zz17 $zz18 $zz19
     $zz20 $zz21 $zz22 $zz23 $zz24 $zz25 $zz26 $zz27 $zz28 $zz29
     $zz30 $zz31 $zz32 $zz33 $zz34 $zz35 $zz36 $zz37 $zz38 $zz39
     $zz40 $zz41 $zz42 $zz43 $zz44 $zz45 $zz46 $zz47 $zz48 $zz49
     $zz50 $zz51 $zz52 $zz53 $zz54 $zz55 $zz56 $zz57 $zz58 $zz59
     $zz60 $zz61 $zz62 $zz63 $zz64 $zz65 $zz66 $zz67 $zz68 $zz69
     $zz70 $zz71 $zz72 $zz73 $zz74 $zz75 $zz76 $zz77 $zz78 $zz79
     $zz80 $zz81 $zz82 $zz83 $zz84 $zz85 $zz86 $zz87 $zz88 $zz89
     $zz90 $zz91 $zz92 $zz93 $zz94 $zz95 $zz96 $zz97 $zz98 $zz99
     $tt0 $tt1 $tt2 $tt3 $tt4 $tt5 $tt6 $tt7 $tt8 $tt9
     $tt10 $tt11 $tt12 $tt13 $tt14 $tt15 $tt16 $tt17 $tt18 $tt19
     $tt20 $tt21 $tt22 $tt23 $tt24 $tt25 $tt26 $tt27 $tt28 $tt29
     $tt30 $tt31 $tt32 $tt33 $tt34 $tt35 $tt36 $tt37 $tt38 $tt39
     $tt40 $tt41 $tt42 $tt43 $tt44 $tt45 $tt46 $tt47 $tt48 $tt49
     $tt50 $tt51 $tt52 $tt53 $tt54 $tt55 $tt56 $tt57 $tt58 $tt59
     $tt60 $tt61 $tt62 $tt63 $tt64 $tt65 $tt66 $tt67 $tt68 $tt69
     $tt70 $tt71 $tt72 $tt73 $tt74 $tt75 $tt76 $tt77 $tt78 $tt79
     $tt80 $tt81 $tt82 $tt83 $tt84 $tt85 $tt86 $tt87 $tt88 $tt89
     $tt90 $tt91 $tt92 $tt93 $tt94 $tt95 $tt96 $tt97 $tt98 $tt99);
# process_data
use vars qw( $obs_dtg $sub_dtg $group $section_0 $section_1 $section_2 $section_3
            $section_4 $section_m $dps_hdr );
# round_date
use vars qw( $new_obs_yr $new_obs_mo $new_obs_day $new_obs_hr $obs_jul );

sub setup
{

    #
    # Setup Pearl CGI
    #
    use lib "/fnmoc/u/curr/lib/perllib";
    use CGI;
    # remove before promotion
    #use CGI::Carp "fatalsToBrowser";

    #
    # Limit file upload size
    #
    #use constant MAX_FILE_SIZE => 7_000;

    return();

}#End setup

#================================= Begin Functions =============================

sub check_location
{
  my $FILE;
  my $rlat;
  my $rlon;
  if($data_type eq "ship_sfc_form")
  {
    $rlat = $lat; 
    if($lat_sign eq "S")
    {
      $rlat = -$rlat;
    }

    $rlon = $lon;
    if($lon_sign eq "W")
    {
      $rlon = -$rlon;
    }
  }
  if($data_type eq "bathy_form")
  {
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
  } 

  open( $FILE, ">", "../dynamic/temp/location_$$.list" ) or die "../dynamic/temp/location_$$.list: $!";
  printf( $FILE "%-6s %-6.1f %6.1f\n",$csgn_name,$rlat,$rlon );
  close( $FILE );

# -------------------------
# draw map with location

  open( $FILE, ">", "../dynamic/temp/coverage_plot_$$.in" ) or die "../dynamic/temp/coverage_plot_$$.in: $!";
  printf( $FILE "%s\n", "TITLE1=Location Check" );
  printf( $FILE "%s\n", "IMAGE_FILE=../dynamic/temp/location_check_plot_$$.png" );
  #printf( $FILE "%s\n", "IMAGE_FILE=STDOUT" );
  if( $clas_type eq "U" )
  {
    printf( $FILE "%s\n", "IMAGE_BG=/fnmoc/u/curr/etc/static/app/cov_plots2/images/basic_white_unclassified.png" );
  }
  elsif($clas_type eq "C")
  {
    printf( $FILE "%s\n", "IMAGE_BG=/fnmoc/u/curr/etc/static/app/cov_plots2/images/basic_white_confidential.png" );
  }
  elsif($clas_type eq "C")
  {
    printf( $FILE "%s\n", "IMAGE_BG=/fnmoc/u/curr/etc/static/app/cov_plots2/images/basic_white_secret.png" );
  }
  else
  {
    printf( $FILE "%s\n", "IMAGE_BG=/fnmoc/u/curr/etc/static/app/cov_plots2/images/basic_white.png" );
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

  # CDM change following when promoting
  my $INPUT =`/fnmoc/u/curr/bin/coverage_plot ../dynamic/temp/coverage_plot_$$.in 2>&1`;

  if( -e "../dynamic/temp/location_$$.list" )
  {
      unlink( "../dynamic/temp/location_$$.list" ) or warn "Failed to delete '../dynamic/temp/location_$$.list': $!";
  }
  
  if( -e "../dynamic/temp/coverage_plot_$$.in" )
  {
      unlink( "../dynamic/temp/coverage_plot_$$.in" ) or warn "Failed to delete '../dynamic/temp/coverage_plot_$$.in': $!";
  }

  #
  # -------------------------
  #
  # onsubmit="return check_accept_location(this) && check_data_list('ship_sfc')"
  # onsubmit="return check_accept_location()"
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
  if($data_type eq "ship_sfc")
  {
    print('action="../cgi-bin/ship_sfc.cgi"');
  }
  elsif($data_type eq "ship_raob")
  {
    print('action="../cgi-bin/ship_raob.cgi"');
  }
  elsif($data_type eq "bathy")
  {
    print('action="../cgi-bin/bathy.cgi"');
  }
  elsif($data_type eq "tesac")
  {
    print('action="../cgi-bin/tesac.cgi"');
  }

  print <<EOF;
onsubmit="return check_accept_location()"
method="post"
target="loc_target"
enctype="multipart/form-data">

EOF
  print <<EOF;
<!--# Bookkeeping --->
<input type="hidden" name="title" value="$title">
<input type="hidden" name="submit_type" value="$submit_type">
<input type="hidden" name="data_type" value="$data_type">
<input type="hidden" name="clas" value="$clas">
<input type="hidden" name="id_num" value="$$">

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

EOF
  print <<EOF;
<!--# Transmission -->
<input type="hidden" name="server_send_time" value="$server_send_time">
<input type="hidden" name="server_receive_time" value="">
<input type="hidden" name="client_receive_time" value="$client_receive_time">
<input type="hidden" name="client_send_time" value="$client_send_time">
EOF
# $server_receive_time isn't defined at this point
#<input type="hidden" name="server_receive_time" value="$server_receive_time">

if($data_type eq "ship_sfc_form")
{

#
# BBXX --- surface ship message
#
  print <<EOF;
<!--# ship location-->
<input type="hidden" name="lat_sign" value="$lat_sign">
<input type="hidden" name="lon_sign" value="$lon_sign">
<input type="hidden" name="lat" value="$lat">
<input type="hidden" name="lon" value="$lon">
<!--# data-->
<!--# Part 1 -->
<input type="hidden" name="rpt_typ_id" value="$rpt_typ_id">
<input type="hidden" name="wnd_dir" value="$wnd_dir">
<input type="hidden" name="wnd_spd" value="$wnd_spd">
<input type="hidden" name="wnd_mthd" value="$wnd_mthd">
<input type="hidden" name="wnd_gst_type" value="$wnd_gst_type">
<input type="hidden" name="wnd_gst" value="$wnd_gst">
<input type="hidden" name="wnd_vrb_1" value="$wnd_vrb_1">
<input type="hidden" name="wnd_vrb_2" value="$wnd_vrb_2">
<input type="hidden" name="horz_sfc_vsby" value="$horz_sfc_vsby">
<input type="hidden" name="horz_sfc_vsby_id" value="$horz_sfc_vsby_id">
<input type="hidden" name="horz_sfc_vsby_type" value="$horz_sfc_vsby_type">
<input type="hidden" name="prsnt_wx" value="$prsnt_wx">
<input type="hidden" name="sky_cdn" value="$sky_cdn">
<input type="hidden" name="air_temp_sign" value="$air_temp_sign">
<input type="hidden" name="air_temp" value="$air_temp">
<input type="hidden" name="dwpt_sign" value="$dwpt_sign">
<input type="hidden" name="dwpt" value="$dwpt">
<input type="hidden" name="wet_bulb_temp_sign" value="$wet_bulb_temp_sign">
<input type="hidden" name="wet_bulb_temp" value="$wet_bulb_temp">
<input type="hidden" name="alt_set_type" value="$alt_set_type">
<input type="hidden" name="alt_set" value="$alt_set">
<input type="hidden" name="rmrks" value="$rmrks">
<input type="hidden" name="stn_lvl_pres" value="$stn_lvl_pres">
<input type="hidden" name="stn_lvl_pres_type" value="$stn_lvl_pres_type">
<input type="hidden" name="sea_lvl_pres" value="$sea_lvl_pres">
<input type="hidden" name="tot_cld_amt_id" value="$tot_cld_amt_id">
<input type="hidden" name="mv_plfm_dir_1" value="$mv_plfm_dir_1">
<input type="hidden" name="mv_plfm_spd_1" value="$mv_plfm_spd_1">
<input type="hidden" name="sea_temp" value="$sea_temp">
<input type="hidden" name="wnd_wav_ht" value="$wnd_wav_ht">
<input type="hidden" name="wnd_wav_per" value="$wnd_wav_per">
<input type="hidden" name="pri_swl_wav_dir" value="$pri_swl_wav_dir">
<input type="hidden" name="pri_swl_wav_ht" value="$pri_swl_wav_ht">
<input type="hidden" name="pri_swl_wav_per" value="$pri_swl_wav_per">
<input type="hidden" name="scdy_swl_wav_dir" value="$scdy_swl_wav_dir">
<input type="hidden" name="scdy_swl_wav_ht" value="$scdy_swl_wav_ht">
<input type="hidden" name="scdy_swl_wav_per" value="$scdy_swl_wav_per">

<!--# Part 2 -->
<input type="hidden" name="wnd_id" value="$wnd_id">
<input type="hidden" name="stn_type_id" value="$stn_type_id">
<input type="hidden" name="cld_base_ht_id" value="$cld_base_ht_id">
<input type="hidden" name="pres_tdcy_char_id" value="$pres_tdcy_char_id">
<input type="hidden" name="pres_tdcy_amt" value="$pres_tdcy_amt">
<input type="hidden" name="pres_wx_id" value="$pres_wx_id">
<input type="hidden" name="past_wx_id_1" value="$past_wx_id_1">
<input type="hidden" name="past_wx_id_2" value="$past_wx_id_2">
<input type="hidden" name="low_cld_amt_id" value="$low_cld_amt_id">
<input type="hidden" name="low_cld_type_id" value="$low_cld_type_id">
<input type="hidden" name="mid_cld_type_id" value="$mid_cld_type_id">
<input type="hidden" name="hi_cld_type_id" value="$hi_cld_type_id">
<input type="hidden" name="mv_plfm_dir_id" value="$mv_plfm_dir_id">
<input type="hidden" name="mv_plfm_spd_id" value="$mv_plfm_spd_id">
<input type="hidden" name="ice_accr_cause_id" value="$ice_accr_cause_id">
<input type="hidden" name="ice_accr_thkn" value="$ice_accr_thkn">
<input type="hidden" name="ice_accr_rate_id" value="$ice_accr_rate_id">
<input type="hidden" name="sea_ice_conc_id" value="$sea_ice_conc_id">
<input type="hidden" name="icing_rmrk" value="$icing_rmrk">
<input type="hidden" name="ice_dev_stage_id" value="$ice_dev_stage_id">
<input type="hidden" name="ice_type_amt_id" value="$ice_type_amt_id">
<input type="hidden" name="ice_edge_brg_id" value="$ice_edge_brg_id">
<input type="hidden" name="ice_sit_id" value="$ice_sit_id">
<input type="hidden" name="ice_rmrk" value="$ice_rmrk">

<!--# Misc. -->
<input type="hidden" name="stn_ht" value="$stn_ht">
<input type="hidden" name="rel_hum" value="$rel_hum">
<input type="hidden" name="wet_bulb_temp_mthd" value="$wet_bulb_temp_mthd">
<input type="hidden" name="sea_temp_mthd" value="$sea_temp_mthd">
EOF
#<input type="hidden" name="std_isob_sfc" value="$std_isob_sfc">
#<input type="hidden" name="geop_std_isob_sfc" value="$geop_std_isob_sfc">
#<input type="hidden" name="inst_wav_ht_1" value="$inst_wav_ht_1">
#<input type="hidden" name="inst_wav_ht_1" value="$inst_wav_ht_1">
#<input type="hidden" name="inst_wav_per" value="$inst_wav_per">

}
elsif($data_type eq "bathy_form")
{

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

<!--# Profile -->
<input type="hidden" name="units" value="$units">
<input type="hidden" name="profile_cnt" value="$profile_cnt">
EOF
  my $i;
  for ($i = 0; $i <= $profile_cnt; $i++)
  {

  print <<EOF;
<input type="hidden" name="zz$i" value="$zz[$i]">
<input type="hidden" name="tt$i" value="$ttt[$i]">
EOF
  }
}




  print <<EOF;
<table style="margin:auto; text-align:center;">
<tr>
<td style="text-align:center">
<br>
<a href="javascript:window.open('','_self').close();">close window</a>
</td>
</tr>
<tr>
<td style="text-align:center">
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

    return();

}#End check_location

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
      unlink( "../dynamic/temp/location_check_plot_${id_num}.png" ) or warn  "Failed to delete '../dynamic/temp/location_check_plot_${id_num}.png': $!";
  }

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
  ( my $sec, my $min, my $hour, my $mday, my $mon, my $year, my $wday, my $yday, my $isdat ) = gmtime;

  use vars qw($clas_banner);
  use sys_info qw(getDevLevel getHostClass getAppName);
  use web_routines qw(getClasBnr getClas);
  #
  # Create the html file and send to client
  #
  print "Content-type: text/html; charset=utf-8\n\n";

  open( my $IN, "<", "../html/data_type_form.html_template" ) or die "Can't open ../html/data_type_form.html_template: $!";

  my $clas_banner = getClasBnr();

  $year = $year + 1900;
  $mon  = $mon +1;

  my $date_time = join( "_",$year, $mon, $mday, $hour, $min, $sec );

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
    s/#FORM_STAT#/$date_time/g;
    s/#SUBMIT_TYPE#/form/g;
    s/#FORM_INTRO#/$form_intro/g;
    s/#FORM_EXPLAN#/$form_explanation/g;
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
       open( my $INS, "<", "../html/color_insert_all.html_template" ) or die "Can't open ../html/color_insert_all.html_template: $!";
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
       open( my $INS, "<", "../html/time_insert.html_template" ) or die "Can't open ../html/time_insert.html_template: $!" ;

       while( <$INS> )
       {
         if( index($_, '//' ) == 0 )
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
        open( $INS, "<", "../html/security_unclas_insert.html_template" ) or die "../html/security_unclasinsert.html_template: $!";
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
    elsif( index( $_,"#FORM_INSERT#" ) >= 0 )
    {
       open( my $INS, "<", "../html/${data_type}_insert.html_template" ) or die "Can't open ../html/${data_type}_insert.html_template: $!";

       while( <$INS> )
       {
         if( index( $_ ,'//' ) == 0 )
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
  if( ! -e "../dynamic/activity_logs/${data_type}_activity.log" )
  {
    open( my $USERS, ">", "../dynamic/activity_logs/${data_type}_activity.log" ) || die "Can't open ${data_type}_activity.log: $!";
    close( $USERS );
    chmod( 0664, "../dynamic/activity_logs/${data_type}_activity.log" );
  }

  #
  # Check if this is an accidental resubmital, such as a browser refresh
  #
  open( my $USERS, "<",  "../dynamic/activity_logs/${data_type}_activity.log" ) || die "Can't open ${data_type}_activity.log: $!";

  my @users  = <$USERS>;
  close( $USERS );
  chmod( 0664, "../dynamic/activity_logs/${data_type}_activity.log" );
  my $new_user = "$csgn_name $remote_id ob_time $sub_time";

  foreach my $user ( @users )
  {
    chomp $user;
    if( $new_user eq $user )
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
  ( $sec_s, $min_s, $hour_s, $mday_s, $mon_s, $year_s, $wday_s, $yday_s, $isdat_s ) = gmtime;

  $year_s = $year_s + 1900;
  $mon_s  = $mon_s +1;
  $yday_s = $yday_s +1;
  $server_receive_time = join( "_", $year_s, $mon_s,$mday_s, $hour_s, $min_s, $sec_s );
  $send_dtg = sprintf( "%4d%02d%02d%02d%02d%02d", $year_s, $mon_s,$mday_s, $hour_s, $min_s, $sec_s );

  my $log_filename = "${data_type}_activity.log";
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
  close(  $USERS );
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
  ( $observer       = $q->param("observer") ) =~ s/[^a-zA-Z]//g;
  ( $observer_title = $q->param("observer_title") ) =~ s/[^a-zA-Z0-9. ]//g;
  # webservices 8 Fast and flexible email validation
  my $expr;
  #$expr = '^(([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?))$';
  # webservices 9 Email validation which complies with RFC 2822
  $expr = '^(((\"[^\"\f\n\r\t\b]+\")|([\w\!\#\$\%\&\'\*\+\-\~\/\^\`\|\{\}]+(\.[\w\!\#\$\%\&\'\*\+\-\~\/\^\`\|\{\}]+)*))@((\[(((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9])))\])|(((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9]))\.((25[0-5])|(2[0-4][0-9])|([0-1]?[0-9]?[0-9])))|((([A-Za-z0-9\-])+\.)+[A-Za-z\-]+)))$';

  my $temp_var = $q->param("email") =~ /$expr/;
  if( !defined ($temp_var) )
  {
    $email        = "not valid";
  }
  else
  {
    $email        = $q->param("email");
  } 

  # ship information
  ( $csgn_name  = $q->param("csgn_name") ) =~ s/[^a-zA-Z]//g;
  $csgn_name    =~ tr/a-z/A-Z/;               # all characters to uppercase 
  ( $ship_name  = $q->param("ship_name") ) =~ s/[^a-zA-Z]//g;
  $ship_name    =~ tr/a-z/A-Z/;               # all characters to uppercase
  ( $ship_title = $q->param("ship_title") ) =~ s/[^a-zA-Z]//g;
  $ship_title   =~ tr/a-z/A-Z/;               # all characters to uppercase

  # time of observation
  ( $obs_yr      = $q->param("obs_yr" ))  =~ s/[^0-9]//g;
  ( $obs_mo      = $q->param("obs_mo") )  =~ s/[^0-9]//g;
  ( $obs_day     = $q->param("obs_day") ) =~ s/[^0-9]//g;
  ( $obs_hr      = $q->param("obs_hr") )  =~ s/[^0-9]//g;
  ( $actl_ob_hr  = $q->param("obs_hr") )  =~ s/[^0-9]//g;
  ( $obs_min     = $q->param("obs_min") ) =~ s/[^0-9]//g;
  ( $actl_ob_min = $q->param("obs_min") ) =~ s/[^0-9]//g;
  $obs_time      = "${obs_yr}_${obs_mo}_${obs_day}_${obs_hr}_${obs_min}";

  # time of submittal
  my $sub_sec;
  my $sub_wday;
  my $sub_yday;
  my $sub_isdat;
  ( $sub_sec, $sub_min, $sub_hr, $sub_day, $sub_mo, $sub_yr, $sub_wday, $sub_yday, $sub_isdat ) = gmtime;
  $sub_mo = $sub_mo +1;
  $sub_yr = $sub_yr +1900;
  $sub_time    = "${sub_yr}_${sub_mo}_${sub_day}_${sub_hr}_${sub_min}";

  # security
  ($clas_type      = $q->param("clas_type")) =~ s/[^UCS]//g;

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


  if($data_type eq "ship_sfc_form")
  {
  # ship surface form
  ($mv_plfm_dir_id    = $q->param("mv_plfm_dir_id")) =~ s/[^0-9\/]//g;
  $mv_plfm_dir = "";
  if($mv_plfm_dir_id eq "/") {$mv_plfm_dir = "";}
  if($mv_plfm_dir_id eq "/") {$mv_plfm_dir = "displacement not reported";}
  if($mv_plfm_dir_id eq "0") {$mv_plfm_dir = "stationary";}
  if($mv_plfm_dir_id eq "1") {$mv_plfm_dir = "NE";}
  if($mv_plfm_dir_id eq "2") {$mv_plfm_dir = "E";}
  if($mv_plfm_dir_id eq "3") {$mv_plfm_dir = "SE";}
  if($mv_plfm_dir_id eq "4") {$mv_plfm_dir = "S";}
  if($mv_plfm_dir_id eq "5") {$mv_plfm_dir = "SW";}
  if($mv_plfm_dir_id eq "6") {$mv_plfm_dir = "W";}
  if($mv_plfm_dir_id eq "7") {$mv_plfm_dir = "NW";}
  if($mv_plfm_dir_id eq "8") {$mv_plfm_dir = "N";}
  if($mv_plfm_dir_id eq "9") {$mv_plfm_dir = "unknown";}
  ($mv_plfm_spd_id    = $q->param("mv_plfm_spd_id")) =~ s/[^0-9\/]//g;
  $mv_plfm_spd = "";
  if($mv_plfm_spd_id eq "/") {$mv_plfm_spd = "not reported";}
  if($mv_plfm_spd_id eq "0") {$mv_plfm_spd = " 0 knot";}
  if($mv_plfm_spd_id eq "1") {$mv_plfm_spd = "1-5 knots";}
  if($mv_plfm_spd_id eq "2") {$mv_plfm_spd = "6-10 knots";}
  if($mv_plfm_spd_id eq "3") {$mv_plfm_spd = "11-15 knots";}
  if($mv_plfm_spd_id eq "4") {$mv_plfm_spd = "16-20 knots";}
  if($mv_plfm_spd_id eq "5") {$mv_plfm_spd = "21-25 knots";}
  if($mv_plfm_spd_id eq "6") {$mv_plfm_spd = "26-30 knots";}
  if($mv_plfm_spd_id eq "7") {$mv_plfm_spd = "31-35 knots";}
  if($mv_plfm_spd_id eq "8") {$mv_plfm_spd = "36-40 knots";}
  if($mv_plfm_spd_id eq "9") {$mv_plfm_spd = "over 40 knots";}
  ($mv_plfm_dir_1     = $q->param("mv_plfm_dir_1")) =~ s/[^0-9-]//g;
  ($mv_plfm_spd_1     = $q->param("mv_plfm_spd_1")) =~ s/[^0-9-]//g;
  ($lat               = $q->param("lat")) =~ s/[^0-9.]//g;
  ($lat_sign          = $q->param("lat_sign")) =~ s/[^NS]//g;
  ($lon               = $q->param("lon")) =~ s/[^0-9.]//g;
  $lon_sign          = $q->param("lon_sign");
  ($lon_sign          = $q->param("lon_sign")) =~ s/[^EW]//g;
  if($lat_sign eq "N" && $lon_sign eq "E")
  {
    $quad = "1";
    if($lon >= 90)
    {
      $oct = "2";
    }
    else
    {
      $oct = "3";
    } 
  }
  if($lat_sign eq "N" && $lon_sign eq "W")
  {
    $quad = "7";
    if($lon >= 90)
    {
      $oct = "1";
    }
    else
    {
      $oct = "0";
    } 
  }
  if($lat_sign eq "S" && $lon_sign eq "W")
  {
    $quad = "5";
    if($lon >= 90)
    {
      $oct = "6";
    }
    else
    {
      $oct = "5";
    } 
  }
  if($lat_sign eq "S" && $lon_sign eq "E")
  {
    $quad = "3";
    if($lon >= 90)
    {
      $oct = "7";
    }
    else
    {
      $oct = "8";
    }
  }


  # elevation and pressure
  ($alt_set_type      = $q->param("alt_set_type")) =~ s/[E]//g;
  ($alt_set           = $q->param("alt_set")) =~ s/[^0-9M]//g;
  ($stn_ht            = $q->param("stn_ht")) =~ s/[^0-9]//g;
  ($stn_lvl_pres_type = $q->param("stn_lvl_pres_type")) =~ s/[E]//g;
  ($stn_lvl_pres      = $q->param("stn_lvl_pres")) =~ s/[^0-9.M]//g;
  ($sea_lvl_pres      = $q->param("sea_lvl_pres")) =~ s/[^0-9M]//g;
  ($pres_tdcy_char_id = $q->param("pres_tdcy_char_id")) =~ s/[^0-8]//g;
  ($pres_tdcy_amt     = $q->param("pres_tdcy_amt")) =~ s/[^0-9M]//g;
  # not in web page
  #$std_isob_sfc      = $q->param("std_isob_sfc");
  $std_isob_sfc      = "";
  #$geop_std_isob_sfc = $q->param("geop_std_isob_sfc");
  $geop_std_isob_sfc = "";


  # weather
  ($pres_wx_id   = $q->param("pres_wx_id")) =~ s/[^0-9]//g;
  ($past_wx_id_1 = $q->param("past_wx_id_1")) =~ s/[^0-9]//g;
  ($past_wx_id_2 = $q->param("past_wx_id_2")) =~ s/[^0-9]//g;
  if($pres_wx_id ne "" || $past_wx_id_1 ne "" || $past_wx_id_2 ne "")
  {
    $stn_type_id = 1;
  }
  else
  {
    $stn_type_id = 3;
  }

  # air conditions
  ($air_temp_sign      = $q->param("air_temp_sign")) =~ s/[^M]//g;
  ($air_temp           = $q->param("air_temp")) =~ s/[^0-9.]//g;
  ($dwpt_sign          = $q->param("dwpt_sign")) =~ s/[^M]//g;
  ($dwpt               = $q->param("dwpt")) =~ s/[^0-9.]//g;
  ($rel_hum            = $q->param("rel_hum")) =~ s/[^0-9]//g;
  ($wet_bulb_temp_sign = $q->param("wet_bulb_temp_sign")) =~ s/[^M]//g;
  ($wet_bulb_temp      = $q->param("wet_bulb_temp")) =~ s/[^0-9.M]//g;
  ($wet_bulb_temp_mthd = $q->param("wet_bulb_temp_mthd")) =~ s/[^0-3]//g;

  ($horz_sfc_vsby_type = $q->param("horz_sfc_vsby_type")) =~ s/[^V]//g;
  ($horz_sfc_vsby      = $q->param("horz_sfc_vsby")) =~ s/[^0-9\/ ]//g;
  ($horz_sfc_vsby_id   = $q->param("horz_sfc_vsby_id")) =~ s/[^0-9\/]//g;
  if($horz_sfc_vsby_id eq "//"  && $horz_sfc_vsby ne "")
  {
    if($horz_sfc_vsby eq "0")   # 0 nmile
    {
      $horz_sfc_vsby_id = "90"; # < 0.05 km
    }
    if($horz_sfc_vsby eq "1/16")   # 1/16 nm -> 0.10 km
    {
      $horz_sfc_vsby_id = "91";    # .05 km
    }
    if($horz_sfc_vsby eq "1/8")   # 1/8 nm -> 0.25 km
    {
      $horz_sfc_vsby_id = "92";    # 0.2 km
    }
    if($horz_sfc_vsby eq "1/4")   # 1/4 nm -> 0.45 km
    {
      $horz_sfc_vsby_id = "93";    # 0.5 km
    }
    if($horz_sfc_vsby eq "1/2")   # 1/2 nm -> 0.90 km
    {
      $horz_sfc_vsby_id = "94";    # 1.0 km
    }
    if($horz_sfc_vsby eq "1")   # 1 nm -> 1.80 km
    {
      $horz_sfc_vsby_id = "95";    # 2 km
    }
    if($horz_sfc_vsby eq "1 1/2")   # 1 1/2 nm -> 2.80 km
    {
      $horz_sfc_vsby_id = "95";    # 2 km
    }
    if($horz_sfc_vsby eq "2")   # 2 nm -> 3.70 km
    {
      $horz_sfc_vsby_id = "96";    # 4 km
    }
    if($horz_sfc_vsby eq "2 1/2")   # 2 1/2 nm -> 4.60 km
    {
      $horz_sfc_vsby_id = "96";    # 4 km
    }
    if($horz_sfc_vsby eq "3")   # 3 nm -> 5.50 km
    {
      $horz_sfc_vsby_id = "96";    # 4 km
    }
    if($horz_sfc_vsby eq "4")   # 4 nm -> 7.40 km
    {
      $horz_sfc_vsby_id = "97";    # 10 km
    }
    if($horz_sfc_vsby eq "5")   # 5 nm -> 9.50 km
    {
      $horz_sfc_vsby_id = "97";    # 10 km
    }
    if($horz_sfc_vsby eq "6")   # 6 nm -> 11.10 km
    {
      $horz_sfc_vsby_id = "97";    # 10 km
    }
    if($horz_sfc_vsby eq "7")   # 7 nm -> 13.00 km
    {
      $horz_sfc_vsby_id = "97";    # 10 km
    }
    if($horz_sfc_vsby eq "8")   # 8 nm -> 14.80 km
    {
      $horz_sfc_vsby_id = "97";    # 10 km
    }
    if($horz_sfc_vsby eq "9")   # 9 nm -> 16.70 km
    {
      $horz_sfc_vsby_id = "98";    # 20 km
    }
    if($horz_sfc_vsby eq "10")   # 10 nm -> 18.50 km
    {
      $horz_sfc_vsby_id = "98";    # 20 km
    }
    if($horz_sfc_vsby eq ">10")
    {
      $horz_sfc_vsby_id = "99";    # >50 km
    }
  }


  # wind
  #$wnd_id        = $q->param("wnd_id");
  #$stn_type_id   = $q->param("stn_type_id");
  ($wnd_spd       = $q->param("wnd_spd")) =~ s/[^0-9]//g;
  ($wnd_dir       = $q->param("wnd_dir")) =~ s/[^0-9]//g;
  if($wnd_spd == 0)
  {
    $wnd_dir_id  = "00";
  }
  else
  {
    if($wnd_dir eq "" || $wnd_dir eq"M")
    {
      $wnd_dir_id  = "//";
    }
    else
    {
      my $wnd_dir_10  = sprintf("%.0f", $wnd_dir / 10.0);
      $wnd_dir_id  = sprintf("%02i", $wnd_dir_10);
      if($wnd_dir_id == 0)
      {
        $wnd_dir_id = 36;
      }
    }
  }
  $wnd_mthd      = $q->param("wnd_mthd");
  if($wnd_mthd eq "measured")
  {
    $wnd_id = 4;
  }
  else
  {
    $wnd_id = 3;
  }
  ($wnd_gst_type  = $q->param("wnd_gst_type")) =~ s/[^GQ]//g;
  ($wnd_gst       = $q->param("wnd_gst")) =~ s/[^0-9]//g;
  ($wnd_vrb_1     = $q->param("wnd_vrb_1")) =~ s/[^0-9]//g;
  ($wnd_vrb_2     = $q->param("wnd_vrb_2")) =~ s/[^0-9]//g;

  # clouds
  ($prsnt_wx        = $q->param("prsnt_wx")) =~ s/[^a-zA-Z0-9.:=\/-]//g;
  ($sky_cdn         = $q->param("sky_cdn")) =~ s/[^a-zA-Z0-9.:=\/-]//g;
  ($rmrks           = $q->param("rmrks")) =~ s/[^a-zA-Z0-9.:=\/-]//g;
  ($cld_base_ht_id  = $q->param("cld_base_ht_id")) =~ s/[^0-9\/]//g;
  if($cld_base_ht_id eq "/") {$cld_base_ht = "unknown";}
  if($cld_base_ht_id eq "0") {$cld_base_ht = "0 - 50 m";}
  if($cld_base_ht_id eq "1") {$cld_base_ht = "50 - 100 m";}
  if($cld_base_ht_id eq "2") {$cld_base_ht = "100 - 200 m";}
  if($cld_base_ht_id eq "3") {$cld_base_ht = "200 - 300 m";}
  if($cld_base_ht_id eq "4") {$cld_base_ht = "300 - 600 m";}
  if($cld_base_ht_id eq "5") {$cld_base_ht = "600 - 1000 m";}
  if($cld_base_ht_id eq "6") {$cld_base_ht = "1000 - 1500 m";}
  if($cld_base_ht_id eq "7") {$cld_base_ht = "1500 - 2000 m";}
  if($cld_base_ht_id eq "8") {$cld_base_ht = "2000 - 2500 m";}
  if($cld_base_ht_id eq "9") {$cld_base_ht = "2500 m or none";}
  ($tot_cld_amt_id  = $q->param("tot_cld_amt_id")) =~ s/[^0-9\/]//g;
  if($tot_cld_amt_id eq "/") {$tot_cld_amt = "not made";}
  if($tot_cld_amt_id eq "0") {$tot_cld_amt = "0";}
  if($tot_cld_amt_id eq "1") {$tot_cld_amt = "1/8";}
  if($tot_cld_amt_id eq "2") {$tot_cld_amt = "2/8";}
  if($tot_cld_amt_id eq "3") {$tot_cld_amt = "3/8";}
  if($tot_cld_amt_id eq "4") {$tot_cld_amt = "4/8";}
  if($tot_cld_amt_id eq "5") {$tot_cld_amt = "5/8";}
  if($tot_cld_amt_id eq "6") {$tot_cld_amt = "6/8";}
  if($tot_cld_amt_id eq "7") {$tot_cld_amt = "7/8";}
  if($tot_cld_amt_id eq "8") {$tot_cld_amt = "8/8";}
  if($tot_cld_amt_id eq "9") {$tot_cld_amt = "obsured";}
  ($low_cld_amt_id  = $q->param("low_cld_amt_id")) =~ s/[^0-9\/]//g;
  if($low_cld_amt_id eq "/") {$low_cld_amt = "not made";}
  if($low_cld_amt_id eq "0") {$low_cld_amt = "0";}
  if($low_cld_amt_id eq "1") {$low_cld_amt = "1/8";}
  if($low_cld_amt_id eq "2") {$low_cld_amt = "2/8";}
  if($low_cld_amt_id eq "3") {$low_cld_amt = "3/8";}
  if($low_cld_amt_id eq "4") {$low_cld_amt = "4/8";}
  if($low_cld_amt_id eq "5") {$low_cld_amt = "5/8";}
  if($low_cld_amt_id eq "6") {$low_cld_amt = "6/8";}
  if($low_cld_amt_id eq "7") {$low_cld_amt = "7/8";}
  if($low_cld_amt_id eq "8") {$low_cld_amt = "8/8";}
  if($low_cld_amt_id eq "9") {$low_cld_amt = "obsured";}
  ($low_cld_type_id = $q->param("low_cld_type_id")) =~ s/[^0-9\/]//g;
  ($mid_cld_type_id = $q->param("mid_cld_type_id")) =~ s/[^0-9\/]//g;
  ($hi_cld_type_id  = $q->param("hi_cld_type_id")) =~ s/[^0-9\/]//g;

  # sea state
  ($sea_temp_mthd   = $q->param("sea_temp_mthd")) =~ s/[^0-7]//g;
  ($sea_temp        = $q->param("sea_temp")) =~ s/[^0-9.]//g;

  # not in web page
  #$inst_wav_per      = $q->param("inst_wav_per");
  #$inst_wav_ht_1     = $q->param("inst_wav_ht_1");
  #$inst_wav_ht_2     = $q->param("inst_wav_ht_2");
  $inst_wav_per      = "";
  $inst_wav_ht_1     = "";
  $inst_wav_ht_2     = "";
  ($wnd_wav_per       = $q->param("wnd_wav_per")) =~ s/[^0-9]//g;
  ($wnd_wav_ht        = $q->param("wnd_wav_ht")) =~ s/[^0-9]//g;
  ($pri_swl_wav_dir   = $q->param("pri_swl_wav_dir")) =~ s/[^0-9]//g;
  ($pri_swl_wav_ht    = $q->param("pri_swl_wav_ht")) =~ s/[^0-9]//g;
  ($pri_swl_wav_per   = $q->param("pri_swl_wav_per")) =~ s/[^0-9]//g;
  ($scdy_swl_wav_dir  = $q->param("scdy_swl_wav_dir")) =~ s/[^0-9]//g;
  ($scdy_swl_wav_ht   = $q->param("scdy_swl_wav_ht")) =~ s/[^0-9]//g;
  ($scdy_swl_wav_per  = $q->param("scdy_swl_wav_per")) =~ s/[^0-9]//g;

  # ice conditions
  ($ice_accr_thkn        = $q->param("ice_accr_thkn")) =~ s/[^0-9]//g;
  ($ice_accr_cause_id    = $q->param("ice_accr_cause_id")) =~ s/[^0-4]//g;
  $ice_accr_cause = "";
  if($ice_accr_cause_id eq "1") {$ice_accr_cause = "ocean spray";}
  if($ice_accr_cause_id eq "2") {$ice_accr_cause = "fog";}
  if($ice_accr_cause_id eq "3") {$ice_accr_cause = "spray and fog";}
  if($ice_accr_cause_id eq "4") {$ice_accr_cause = "rain";}
  if($ice_accr_cause_id eq "5") {$ice_accr_cause = "spray and rain";}
  ($ice_accr_rate_id     = $q->param("ice_accr_rate_id")) =~ s/[^0-4]//g;
  $ice_accr_rate = "";
  if($ice_accr_rate_id eq "0") {$ice_accr_rate = "not building";}
  if($ice_accr_rate_id eq "1") {$ice_accr_rate = "building slowly";}
  if($ice_accr_rate_id eq "2") {$ice_accr_rate = "building rapidly";}
  if($ice_accr_rate_id eq "3") {$ice_accr_rate = "ice melting or breaking slowly";}
  if($ice_accr_rate_id eq "4") {$ice_accr_rate = "ice melting or breaking rapidly";}
  ($icing_rmrk           = $q->param("icing_rmrk")) =~ s/[^a-zA-Z0-9.:=\/-]//g;
  ($sea_ice_conc_id      = $q->param("sea_ice_conc_id")) =~ s/[^0-9\/]//g;
  ($ice_dev_stage_id     = $q->param("ice_dev_stage_id")) =~ s/[^0-9\/]//g;
  ($ice_type_amt_id      = $q->param("ice_type_amt_id")) =~ s/[^0-9\/]//g;
  ($ice_edge_brg_id      = $q->param("ice_edge_brg_id")) =~ s/[^0-9\/]//g;
  ($ice_sit_id           = $q->param("ice_sit_id")) =~ s/[^0-9\/]//g;
  ($ice_rmrk             = $q->param("ice_rmrk")) =~ s/[^a-zA-Z0-9.:=\/-]//g;

  # misc
  ($rpt_typ_id           = $q->param("rpt_typ_id")) =~ s/[^0-6]//g;
  if($rpt_typ_id eq "1") {$rpt_typ = "METAR";}
  if($rpt_typ_id eq "2") {$rpt_typ = "SPECI";}
  if($rpt_typ_id eq "3") {$rpt_typ = "SPECI-aircraft mishap";}
  if($rpt_typ_id eq "4") {$rpt_typ = "SPECI-collision at sea";}
  if($rpt_typ_id eq "5") {$rpt_typ = "SPECI-man overboard";}
  if($rpt_typ_id eq "6") {$rpt_typ = ">SPECI-local requirement";}

  }
  elsif($data_type eq "bathy_form")
  {
    # need actual obs date and time
    ($day_utc  = $q->param("obs_day")) =~ s/[^0-9]//g;
    ($mon_utc  = $q->param("obs_mo")) =~ s/[^0-9]//g;
    ($yr_utc   = $q->param("obs_yr")) =~ s/[^0-9]//g;
    ($yr_utc) = ($yr_utc =~ /(.{1}$)/);
    ($hr_utc   = $q->param("obs_hr")) =~ s/[^0-9]//g;
    ($min_utc  = $q->param("obs_min")) =~ s/[^0-9]//g;

    # CDM duplication?
    # time of submittal
     ($sub_sec, $sub_min, $sub_hr, $sub_day, $sub_mo, $sub_yr, $sub_wday, $sub_yday, $sub_isdat ) = gmtime;
    $sub_mo = $sub_mo +1;
    $sub_yr = $sub_yr +1900;
    $sub_time    = "${sub_yr}_${sub_mo}_${sub_day}_${sub_hr}_${sub_min}";

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
    @zz = ("") x 100;
#    $zz[0] = "0";
    if ( defined ($q->param("zz0")) ) { ($zz[0] = $q->param("zz0")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz1")) ) { ($zz[1] = $q->param("zz1")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz2")) ) { ($zz[2] = $q->param("zz2")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz3")) ) { ($zz[3] = $q->param("zz3")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz4")) ) { ($zz[4] = $q->param("zz4")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz5")) ) { ($zz[5] = $q->param("zz5")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz6")) ) { ($zz[6] = $q->param("zz6")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz7")) ) { ($zz[7] = $q->param("zz7")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz8")) ) { ($zz[8] = $q->param("zz8")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz9")) ) { ($zz[9] = $q->param("zz9")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz10")) ) { ($zz[10] = $q->param("zz10")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz11")) ) { ($zz[11] = $q->param("zz11")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz12")) ) { ($zz[12] = $q->param("zz12")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz13")) ) { ($zz[13] = $q->param("zz13")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz14")) ) { ($zz[14] = $q->param("zz14")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz15")) ) { ($zz[15] = $q->param("zz15")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz16")) ) { ($zz[16] = $q->param("zz16")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz17")) ) { ($zz[17] = $q->param("zz17")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz18")) ) { ($zz[18] = $q->param("zz18")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz19")) ) { ($zz[19] = $q->param("zz19")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz20")) ) { ($zz[20] = $q->param("zz20")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz21")) ) { ($zz[21] = $q->param("zz21")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz22")) ) { ($zz[22] = $q->param("zz22")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz23")) ) { ($zz[23] = $q->param("zz23")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz24")) ) { ($zz[24] = $q->param("zz24")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz25")) ) { ($zz[25] = $q->param("zz25")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz26")) ) { ($zz[26] = $q->param("zz26")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz27")) ) { ($zz[27] = $q->param("zz27")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz28")) ) { ($zz[28] = $q->param("zz28")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz29")) ) { ($zz[29] = $q->param("zz29")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz30")) ) { ($zz[30] = $q->param("zz30")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz31")) ) { ($zz[31] = $q->param("zz31")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz32")) ) { ($zz[32] = $q->param("zz32")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz33")) ) { ($zz[33] = $q->param("zz33")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz34")) ) { ($zz[34] = $q->param("zz34")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz35")) ) { ($zz[35] = $q->param("zz35")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz36")) ) { ($zz[36] = $q->param("zz36")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz37")) ) { ($zz[37] = $q->param("zz37")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz38")) ) { ($zz[38] = $q->param("zz38")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz39")) ) { ($zz[39] = $q->param("zz39")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz40")) ) { ($zz[40] = $q->param("zz40")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz41")) ) { ($zz[41] = $q->param("zz41")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz42")) ) { ($zz[42] = $q->param("zz42")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz43")) ) { ($zz[43] = $q->param("zz43")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz44")) ) { ($zz[44] = $q->param("zz44")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz45")) ) { ($zz[45] = $q->param("zz45")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz46")) ) { ($zz[46] = $q->param("zz46")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz47")) ) { ($zz[47] = $q->param("zz47")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz48")) ) { ($zz[48] = $q->param("zz48")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz49")) ) { ($zz[49] = $q->param("zz49")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz50")) ) { ($zz[50] = $q->param("zz50")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz51")) ) { ($zz[51] = $q->param("zz51")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz52")) ) { ($zz[52] = $q->param("zz52")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz53")) ) { ($zz[53] = $q->param("zz53")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz54")) ) { ($zz[54] = $q->param("zz54")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz55")) ) { ($zz[55] = $q->param("zz55")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz56")) ) { ($zz[56] = $q->param("zz56")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz57")) ) { ($zz[57] = $q->param("zz57")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz58")) ) { ($zz[58] = $q->param("zz58")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz59")) ) { ($zz[59] = $q->param("zz59")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz60")) ) { ($zz[60] = $q->param("zz60")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz61")) ) { ($zz[61] = $q->param("zz61")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz62")) ) { ($zz[62] = $q->param("zz62")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz63")) ) { ($zz[63] = $q->param("zz63")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz64")) ) { ($zz[64] = $q->param("zz64")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz65")) ) { ($zz[65] = $q->param("zz65")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz66")) ) { ($zz[66] = $q->param("zz66")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz67")) ) { ($zz[67] = $q->param("zz67")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz68")) ) { ($zz[68] = $q->param("zz68")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz69")) ) { ($zz[69] = $q->param("zz69")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz70")) ) { ($zz[70] = $q->param("zz70")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz71")) ) { ($zz[71] = $q->param("zz71")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz72")) ) { ($zz[72] = $q->param("zz72")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz73")) ) { ($zz[73] = $q->param("zz73")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz74")) ) { ($zz[74] = $q->param("zz74")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz75")) ) { ($zz[75] = $q->param("zz75")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz76")) ) { ($zz[76] = $q->param("zz76")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz77")) ) { ($zz[77] = $q->param("zz77")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz78")) ) { ($zz[78] = $q->param("zz78")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz79")) ) { ($zz[79] = $q->param("zz79")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz80")) ) { ($zz[80] = $q->param("zz80")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz81")) ) { ($zz[81] = $q->param("zz81")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz82")) ) { ($zz[82] = $q->param("zz82")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz83")) ) { ($zz[83] = $q->param("zz83")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz84")) ) { ($zz[84] = $q->param("zz84")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz85")) ) { ($zz[85] = $q->param("zz85")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz86")) ) { ($zz[86] = $q->param("zz86")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz87")) ) { ($zz[87] = $q->param("zz87")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz88")) ) { ($zz[88] = $q->param("zz88")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz89")) ) { ($zz[89] = $q->param("zz89")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz90")) ) { ($zz[90] = $q->param("zz90")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz91")) ) { ($zz[91] = $q->param("zz91")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz92")) ) { ($zz[92] = $q->param("zz92")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz93")) ) { ($zz[93] = $q->param("zz93")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz94")) ) { ($zz[94] = $q->param("zz94")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz95")) ) { ($zz[95] = $q->param("zz95")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz96")) ) { ($zz[96] = $q->param("zz96")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz97")) ) { ($zz[97] = $q->param("zz97")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz98")) ) { ($zz[98] = $q->param("zz98")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("zz99")) ) { ($zz[99] = $q->param("zz99")) =~ s/[^0-9.]//g; }

    $profile_cnt = 99;
    while ($zz[$profile_cnt] eq "")
    {
      $profile_cnt--;
    }

    @ttt = ("") x 100;
    if ( defined ($q->param("tt0")) ) { ($ttt[0] = $q->param("tt0")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt1")) ) { ($ttt[1] = $q->param("tt1")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt2")) ) { ($ttt[2] = $q->param("tt2")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt3")) ) { ($ttt[3] = $q->param("tt3")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt4")) ) { ($ttt[4] = $q->param("tt4")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt5")) ) { ($ttt[5] = $q->param("tt5")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt6")) ) { ($ttt[6] = $q->param("tt6")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt7")) ) { ($ttt[7] = $q->param("tt7")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt8")) ) { ($ttt[8] = $q->param("tt8")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt9")) ) { ($ttt[9] = $q->param("tt9")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt10")) ) { ($ttt[10] = $q->param("tt10")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt11")) ) { ($ttt[11] = $q->param("tt11")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt12")) ) { ($ttt[12] = $q->param("tt12")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt13")) ) { ($ttt[13] = $q->param("tt13")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt14")) ) { ($ttt[14] = $q->param("tt14")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt15")) ) { ($ttt[15] = $q->param("tt15")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt16")) ) { ($ttt[16] = $q->param("tt16")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt17")) ) { ($ttt[17] = $q->param("tt17")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt18")) ) { ($ttt[18] = $q->param("tt18")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt19")) ) { ($ttt[19] = $q->param("tt19")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt20")) ) { ($ttt[20] = $q->param("tt20")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt21")) ) { ($ttt[21] = $q->param("tt21")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt22")) ) { ($ttt[22] = $q->param("tt22")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt23")) ) { ($ttt[23] = $q->param("tt23")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt24")) ) { ($ttt[24] = $q->param("tt24")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt25")) ) { ($ttt[25] = $q->param("tt25")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt26")) ) { ($ttt[26] = $q->param("tt26")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt27")) ) { ($ttt[27] = $q->param("tt27")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt28")) ) { ($ttt[28] = $q->param("tt28")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt29")) ) { ($ttt[29] = $q->param("tt29")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt30")) ) { ($ttt[30] = $q->param("tt30")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt31")) ) { ($ttt[31] = $q->param("tt31")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt32")) ) { ($ttt[32] = $q->param("tt32")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt33")) ) { ($ttt[33] = $q->param("tt33")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt34")) ) { ($ttt[34] = $q->param("tt34")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt35")) ) { ($ttt[35] = $q->param("tt35")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt36")) ) { ($ttt[36] = $q->param("tt36")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt37")) ) { ($ttt[37] = $q->param("tt37")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt38")) ) { ($ttt[38] = $q->param("tt38")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt39")) ) { ($ttt[39] = $q->param("tt39")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt40")) ) { ($ttt[40] = $q->param("tt40")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt41")) ) { ($ttt[41] = $q->param("tt41")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt42")) ) { ($ttt[42] = $q->param("tt42")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt43")) ) { ($ttt[43] = $q->param("tt43")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt44")) ) { ($ttt[44] = $q->param("tt44")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt45")) ) { ($ttt[45] = $q->param("tt45")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt46")) ) { ($ttt[46] = $q->param("tt46")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt47")) ) { ($ttt[47] = $q->param("tt47")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt48")) ) { ($ttt[48] = $q->param("tt48")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt49")) ) { ($ttt[49] = $q->param("tt49")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt50")) ) { ($ttt[50] = $q->param("tt50")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt51")) ) { ($ttt[51] = $q->param("tt51")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt52")) ) { ($ttt[52] = $q->param("tt52")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt53")) ) { ($ttt[53] = $q->param("tt53")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt54")) ) { ($ttt[54] = $q->param("tt54")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt55")) ) { ($ttt[55] = $q->param("tt55")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt56")) ) { ($ttt[56] = $q->param("tt56")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt57")) ) { ($ttt[57] = $q->param("tt57")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt58")) ) { ($ttt[58] = $q->param("tt58")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt59")) ) { ($ttt[59] = $q->param("tt59")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt60")) ) { ($ttt[60] = $q->param("tt60")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt61")) ) { ($ttt[61] = $q->param("tt61")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt62")) ) { ($ttt[62] = $q->param("tt62")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt63")) ) { ($ttt[63] = $q->param("tt63")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt64")) ) { ($ttt[64] = $q->param("tt64")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt65")) ) { ($ttt[65] = $q->param("tt65")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt66")) ) { ($ttt[66] = $q->param("tt66")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt67")) ) { ($ttt[67] = $q->param("tt67")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt68")) ) { ($ttt[68] = $q->param("tt68")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt69")) ) { ($ttt[69] = $q->param("tt69")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt70")) ) { ($ttt[70] = $q->param("tt70")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt71")) ) { ($ttt[71] = $q->param("tt71")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt72")) ) { ($ttt[72] = $q->param("tt72")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt73")) ) { ($ttt[73] = $q->param("tt73")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt74")) ) { ($ttt[74] = $q->param("tt74")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt75")) ) { ($ttt[75] = $q->param("tt75")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt76")) ) { ($ttt[76] = $q->param("tt76")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt77")) ) { ($ttt[77] = $q->param("tt77")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt78")) ) { ($ttt[78] = $q->param("tt78")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt79")) ) { ($ttt[79] = $q->param("tt79")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt80")) ) { ($ttt[80] = $q->param("tt80")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt81")) ) { ($ttt[81] = $q->param("tt81")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt82")) ) { ($ttt[82] = $q->param("tt82")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt83")) ) { ($ttt[83] = $q->param("tt83")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt84")) ) { ($ttt[84] = $q->param("tt84")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt85")) ) { ($ttt[85] = $q->param("tt85")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt86")) ) { ($ttt[86] = $q->param("tt86")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt87")) ) { ($ttt[87] = $q->param("tt87")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt88")) ) { ($ttt[88] = $q->param("tt88")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt89")) ) { ($ttt[89] = $q->param("tt89")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt90")) ) { ($ttt[90] = $q->param("tt90")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt91")) ) { ($ttt[91] = $q->param("tt91")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt92")) ) { ($ttt[92] = $q->param("tt92")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt93")) ) { ($ttt[93] = $q->param("tt93")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt94")) ) { ($ttt[94] = $q->param("tt94")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt95")) ) { ($ttt[95] = $q->param("tt95")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt96")) ) { ($ttt[96] = $q->param("tt96")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt97")) ) { ($ttt[97] = $q->param("tt97")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt98")) ) { ($ttt[98] = $q->param("tt98")) =~ s/[^0-9.]//g; }
    if ( defined ($q->param("tt99")) ) { ($ttt[99] = $q->param("tt99")) =~ s/[^0-9.]//g; }

    ($radio_call = $q->param("csgn_name")) =~ s/[^a-zA-Z]//g;

    # remove blank lines
    my $i = 0;
    my $ii;
    my $inc = 0;
    while(($i + $inc) <= $profile_cnt)
    {
      until ($zz[$i + $inc] ne "" || ($i + $inc) == $profile_cnt)
      {
        $inc++;
      }
      $zz[$i] = $zz[$i + $inc];
      $ttt[$i] = $ttt[$i + $inc];
      $i++
    }
    $profile_cnt = $profile_cnt - $inc;
  }

  return();

}#End form_input


sub diag_output
{

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
<td>
<br> <a href=\"javascript:window.open('','_self').close();window.open('','_long_form').close()\">close windows</a>
<h1>
$title Submission Complete
<br>
EOF

  print scalar (gmtime);
  print "<br> remote id: $remote_id";
  print "<br> web browser type: $browser_type";
  print "</h1>";
}

if($results eq "message")
{
print <<EOF;
<!DOCTYPE html><html> <head> <title>encode message</title> </head> <body>
<table style="margin:auto; text-align:center;">
<tr>
<td>
<br> <a href=\"javascript:window.open('','_self').close();\">close window</a>
<h1>
<br> $title Encoded Message
</h1>
<br>
EOF
}

if($results eq "full")
{
print <<EOF;
<!DOCTYPE html><html> <head> <title>detail display</title> </head> <body>
<table style="margin:auto; text-align:center;">
<tr>
<td>
<br> <a href=\"javascript:window.open('','_self').close();\">close window</a>
<h1>
$title Detail Display
</h1>
<br>
<table style="margin:auto; text-align:center;">
<tr>
<td style='text-align:left; padding:10px; border:1px solid black'>
EOF

#  printf ("%-25s <I>%s</I><br>",'server_send_time',$server_send_time);

print "<pre>\n";
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
print "</pre>\n";

print "<b>Time of Submission</b>\n";
printf ("%-20s <I>%-13s</I>\n",'year',$sub_yr);
printf ("%-20s <I>%-13s</I>\n",'month',$sub_mo);
printf ("%-20s <I>%-13s</I>\n",'day',$sub_day);
printf ("%-20s <I>%-13s</I>\n",'hour',$sub_hr);
printf ("%-20s <I>%-13s</I>\n",'minute',$sub_min);

if($data_type eq "ship_sfc_form")
{
  print "<pre>\n";
  print "<b>Part 1</b>\n";
  printf ("%-25s <I>%-13s</I>\n",'  (1) report type',$rpt_typ);
  printf ("%-25s <I>%-13s</I>\n",'  (3) wind direction',$wnd_dir);
  printf ("%-25s <I>%-13s</I>\n",'  (4) wind speed',$wnd_spd);
  printf ("%-25s <I>%-13s</I>\n",'      wind method',$wnd_mthd);
  if($wnd_gst ne "")
  {
    printf ("%-25s <I>%-13s</I>\n",'  (5) wind gust',join("",$wnd_gst_type,$wnd_gst));
  }
  else
  {
    printf ("%-25s\n",'  (5) wind gust');
  }
  if($wnd_vrb_1 ne "")
  {
    printf ("%-25s <I>%-13s</I>\n",'  (6) wind variability',join("",$wnd_vrb_1,"V",$wnd_vrb_2));
  }
  else
  {
    printf ("%-25s\n",'  (6) wind variability');
  }
  printf ("%-25s <I>%-13s</I>\n",'  (7) horiz sfc vis',join("",$horz_sfc_vsby,$horz_sfc_vsby_type));
  printf ("%-25s <I>%-13s</I>\n",' (10) air temperature',join("",$air_temp_sign,$air_temp));
  printf ("%-25s <I>%-13s</I>\n",' (12) dew point',join("",$dwpt_sign,$dwpt));
  printf ("%-25s <I>%-13s</I>\n",' (20) wet bulb temp',join("",$wet_bulb_temp_sign,$wet_bulb_temp));
  printf ("%-25s <I>%-13s</I>\n",' (13) altimeter setting',join("",$alt_set_type,$alt_set));
  printf ("%-25s <I>%-13s</I>\n",' (22) stn level pres',join("",$stn_lvl_pres_type,$stn_lvl_pres));
  printf ("%-25s <I>%-13s</I>\n",'(22a) sea level pres',$sea_lvl_pres);
  printf ("%-25s <I>%-13s</I>\n",' (17) total sky cover',$tot_cld_amt);
  printf ("%-25s <I>%-13s</I>\n",'  (A) latitude',join("",$lat,$lat_sign));
  printf ("%-25s <I>%-13s</I>\n",'  (A) longitude',join("",$lon,$lon_sign));
  printf ("%-25s <I>%-13s</I>\n",'  (B) ship heading',$mv_plfm_dir_1);
  printf ("%-25s <I>%-13s</I>\n",'  (C) ship speed',$mv_plfm_spd_1);
  printf ("%-25s <I>%-13s</I>\n",'  (D) sea temp',$sea_temp);
  printf ("%-25s <I>%-13s</I>\n",'  (E) wind wave per',$wnd_wav_per);
  printf ("%-25s <I>%-13s</I>\n",'  (E) wind wave ht',$wnd_wav_ht);
  printf ("%-25s <I>%-13s</I>\n",'  (F) prim wave swell dir',$pri_swl_wav_dir);
  printf ("%-25s <I>%-13s</I>\n",'  (F) prim wave swell ht',$pri_swl_wav_ht);
  printf ("%-25s <I>%-13s</I>\n",'  (F) prim wave swell per',$pri_swl_wav_per);
  printf ("%-25s <I>%-13s</I>\n",'  (G) scdy wave swell dir',$scdy_swl_wav_dir);
  printf ("%-25s <I>%-13s</I>\n",'  (G) scdy wave swell ht',$scdy_swl_wav_ht);
  printf ("%-25s <I>%-13s</I>\n",'  (G) scdy wave swell per',$scdy_swl_wav_per);

  printf "<b>Part 2</b>\n";
  printf ("%-25s <I>%-13s</I>\n",'  iw - wind indicator',$wnd_id);
  printf ("%-25s <I>%-13s</I>\n",'  ix - wx data indicator',$stn_type_id);
  printf ("%-25s <I>%-13s</I>\n",'   h - cloud base ht',$cld_base_ht);
  printf ("%-25s <I>%-13s</I>\n",'   a - pres tend char id',$pres_tdcy_char_id);
  printf ("%-25s <I>%-13s</I>\n",' ppp - pres tend amt',$pres_tdcy_amt);
  printf ("%-25s <I>%-13s</I>\n",'  ww - present wx',$pres_wx_id);
  printf ("%-25s <I>%-13s</I>\n",'  W1 - past wx 1',$past_wx_id_1);
  printf ("%-25s <I>%-13s</I>\n",'  W2 - past wx 2',$past_wx_id_2);
  printf ("%-25s <I>%-13s</I>\n",'  Nh - low cloud amt id',$low_cld_amt_id);
  printf ("%-25s <I>%-13s</I>\n",'  Cl - low cloud type id',$low_cld_type_id);
  printf ("%-25s <I>%-13s</I>\n",'  Cm - mid cloud type id',$mid_cld_type_id);
  printf ("%-25s <I>%-13s</I>\n",'  Ch - hi cloud type id',$hi_cld_type_id);
  printf ("%-25s <I>%-13s</I>\n",'  Ds - ship heading',$mv_plfm_dir);
  printf ("%-25s <I>%-13s</I>\n",'  Vs - ship speed',$mv_plfm_spd);
  printf ("%-25s <I>%-13s</I>\n",'  Is - ice accret cause',$ice_accr_cause);
  printf ("%-25s <I>%-13s</I>\n",'EsEs - ice thickness',$ice_accr_thkn);
  printf ("%-25s <I>%-13s</I>\n",'  Rs - ice accret rate id',$ice_accr_rate);
  printf ("%-25s <I>%-13s</I>\n",'  ci - sea ice concentration',$sea_ice_conc_id);
  printf ("%-25s <I>%-13s</I>\n",'  Si - ice development',$ice_dev_stage_id);
  printf ("%-25s <I>%-13s</I>\n",'  bi - ice of land origin',$ice_type_amt_id);
  printf ("%-25s <I>%-13s</I>\n",'  Di - ice edge bearing',$ice_edge_brg_id);
  printf ("%-25s <I>%-13s</I>\n",'  zi - ice situation',$ice_sit_id);

  print "\n";
  print "<b>Misc.</b>\n";
  printf ("%-25s <I>%-13s</I>\n",'       station height',$stn_ht);
  printf ("%-25s <I>%-13s</I>\n",'       relative humidity',$rel_hum);
  printf ("%-25s <I>%-13s</I>\n",'  sw - wet bulb method',$wet_bulb_temp_mthd);
  printf ("%-25s <I>%-13s</I>\n",'  ss - sea temp method',$sea_temp_mthd);
# printf ("%-25s <I>%-13s</I>\n",'stand isob sfc',$std_isob_sfc);
# printf ("%-25s <I>%-13s</I>\n",'geop height',$geop_std_isob_sfc);
# printf ("%-25s <I>%-13s</I>\n",'inst wave ht 1',$inst_wav_ht_1);
# printf ("%-25s <I>%-13s</I>\n",'inst wave ht 1 units',$inst_wav_ht_1_units);
# printf ("%-25s <I>%-13s</I>\n",'inst wave ht 2',$inst_wav_ht_2);
# printf ("%-25s <I>%-13s</I>\n",'inst wave ht 2 units',$inst_wav_ht_2_units);
# printf ("%-25s <I>%-13s</I>\n",'inst wave per (sec)',$inst_wav_per);
  print "</pre>\n";
}
elsif($data_type eq "bathy_form")
{
  print "<pre>\n";
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
  print "<b>Profile</b>\n";
  if($units eq "/")
  {
    printf ("zz - meters / tt - C\n");
  }
  else
  {
    printf ("zz - feet / tt - F\n");
  }

  my $i;
  for ($i = 0; $i <= $profile_cnt; $i++)
  {
    printf ("%-4s<I>%4i</I>  %-4s<I>%4.1f</I>\n","zz${i}",$zz[$i],"tt${i}",$ttt[$i]);
  }
  print "</pre>\n";
}

print "<pre>\n";
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

if($data_type eq "ship_sfc_form")
{
  print "\n";
  print "<b>Text remarks</b>\n";
  printf ("%-30s <I>%s</I>\n",'Present Weather',$prsnt_wx);
  printf ("%-30s <I>%s</I>\n",'Sky Conditions',$sky_cdn);
  printf ("%-30s <I>%s</I>\n",'remarks and supplemental data',$rmrks);
  printf ("%-30s <I>%s</I>\n",'icing remark',$icing_rmrk);
  printf ("%-30s <I>%s</I>\n",'ice remark',$ice_rmrk);
}

print <<EOF;
</pre>
</td>
</tr>
</table>
</td>
</tr>
EOF

}#=================================

if($results eq "submit" || $results eq "full" || $results eq "message")
{#=================================

#+++++++++++++++++++++++++++++ WMO REPORT ++++++++++++++++++++++++++++
print <<EOF;
<tr>
<td>
<table style="margin:auto; text-align:center;">
<tr>
<td style='text-align:left; padding:10px; border:1px solid black'>
EOF

print "<b>Generated WMO encoded message</b>\n";
}

if($results eq "message" || $results eq "submit" || $results eq "full")
{#=================================

  print "<div style='text-align:left'>\n";
  print "<pre>\n";
  if($data_type eq "ship_sfc_form")
  {
    print "$section_0\n";
    print "$section_1\n";
    print "$section_2\n";
# To avoid confusion about MOBOB METAR, do not show user
#   print "$section_m\n";
  }
  elsif($data_type eq "bathy_form")
  {
    print "$section_1\n";
    print "$section_2 ";
    print "$section_4\n";
  }
  print "</pre>\n";
  print "</div>\n";

}#=================================

if($results eq "submit" || $results eq "full" || $results eq "message")
{#=================================

print <<EOF;
</td>
</tr>
</table>
</td>
</tr>
</table>
</body>
</html>
EOF

}#=================================

#if($results eq "message")
#{#=================================

#print <<EOF;
#</td>
#</tr>
#</table>
#</body>
#</html>
#EOF

#}#=================================

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
  $obs_dtg = sprintf("%4d%02d%02d%02d%02d%02d",$obs_yr, $obs_mo, $obs_day, $obs_hr, $obs_min, 00);
  $sub_dtg = sprintf("%4d%02d%02d%02d%02d%02d",$sub_yr, $sub_mo, $sub_day, $sub_hr, $sub_min, 00);


#
# create WMO enocoded message
#

if($data_type eq "ship_sfc_form")
{

#
# BBXX --- surface ship message
#

# section 0

# MiMiMjMj
  $section_0 = "BBXX";

# DDDD
  my $DDDD = sprintf("%4s",$csgn_name);
  $section_0 = join(" ", $section_0, $DDDD);

# YYGGiw
  &round_date(); 
  my $YY = sprintf("%02i",$new_obs_day); 
  my $GG = sprintf("%02i",$new_obs_hr);
  my $iw = sprintf("%1i", $wnd_id);
  $group = join("", $YY, $GG, $iw);
  $section_0 = join(" ", $section_0, $group);

# 99LaLaLa
  my $LaLaLa = sprintf("%03i", $lat * 10);
  $group = join("","99", $LaLaLa);
  $section_0 = join(" ", $section_0, $group);

# QcLoLoLoLo
  my $LoLoLoLo = sprintf("%04i", $lon * 10);
  $group = join("",$quad, $LoLoLoLo);
  $section_0 = join(" ", $section_0, $group);


# section 1

# iRixhVV
  my $iR = 4;
  my $ix = sprintf("%1i", $stn_type_id);
  my $h = $cld_base_ht_id;
  my $VV = $horz_sfc_vsby_id;
  $group = join("",$iR, $ix, $h, $VV);
  $section_1 = $group;

# Nddff
  my $N = $tot_cld_amt_id;
  my $dd = sprintf("%02i",$wnd_dir_id);
  my $ff;
  my $fff;
  if($wnd_spd eq "" || $wnd_spd eq "M")
  {
    $ff = "//";
    $fff = 0;
  }
  else
  {
    if($wnd_spd < 99)
    {
      $ff = sprintf("%02i",$wnd_spd);
      $fff = 0;
    }
    else
    {
      $ff = 99;
      $fff = $wnd_spd;
    }
  }
  $group = join("",$N, $dd, $ff);
  $section_1 = join(" ", $section_1, $group);

# 00fff
  if($fff > 99)
  {
    $group = join("","00", $fff);
    $section_1 = join(" ", $section_1, $group);
  }

# 1snTTT
  my $sn;
  if($air_temp_sign eq "")
  {
    $sn = "0";
  }
  else
  {
    $sn = "1";
  }
  my $TTT;
  if($air_temp ne "" && $air_temp ne "M")
  {
    $TTT = sprintf("%03i",$air_temp * 10);
    $group = join("","1", $sn, $TTT);
    $section_1 = join(" ", $section_1, $group);
  }

# 2snTdTdTd
  if($dwpt_sign eq "")
  {
    $sn = "0";
  }
  else
  {
    $sn = "1";
  }
  if($dwpt ne "" && $dwpt ne "M")
  {
    my $TdTdTd = sprintf("%03i",$dwpt * 10);
    $group = join("","2", $sn, $TdTdTd);
    $section_1 = join(" ", $section_1, $group);
  }

# 4PPPP
  if($sea_lvl_pres ne "" && $sea_lvl_pres ne "M")
  {
    my $PPPP = $sea_lvl_pres;
    if ($PPPP >= 10000)  {$PPPP -= 10000;}
    $PPPP = sprintf("%04i",$PPPP);
    $group = join("","4", $PPPP);
    $section_1 = join(" ", $section_1, $group);
  }

# 5appp
  if($pres_tdcy_amt ne "" && $pres_tdcy_amt ne "M")
  {
    my $a = $pres_tdcy_char_id;
    my $ppp = sprintf("%03i",$pres_tdcy_amt);
    $group = join("","5", $a, $ppp);
    $section_1 = join(" ", $section_1, $group);
  }

# 7wwW1W2
  my $ww;
  my $W1;
  my $W2;
  if($pres_wx_id ne "" || $past_wx_id_1 ne "" || $past_wx_id_2 ne "")
  {
    if($pres_wx_id ne "")
    {
      $ww = $pres_wx_id;
    }
    else
    {
      $ww = "//";
    }
    if($past_wx_id_1 ne "")
    {
      $W1 = $past_wx_id_1;
    }
    else
    {
      $W1 = "/";
    }
    if($past_wx_id_2 ne "")
    {
      $W2 = $past_wx_id_2;
    }
    else
    {
      $W2 = "/";
    }
    $group = join("","7", $ww, $W1, $W2);
    $section_1 = join(" ", $section_1, $group);
  }

# 8NhCLCMCH
  if($N ne "0" && $N ne "/")
  {

    my $Nh;
    my $CL;
    my $CM;
    my $CH;
    if($low_cld_amt_id ne "")
    {
      $Nh = $low_cld_amt_id;
    }
    else
    {
      $Nh = "/";
    }

    if($low_cld_type_id ne "")
    {
      $CL = $low_cld_type_id;
    }
    else
    {
      $CL = "/";
    }

    if($mid_cld_type_id ne "")
    {
      $CM = $mid_cld_type_id;
    }
    else
    {
      $CM = "/";
    }

    if($hi_cld_type_id ne "")
    {
      $CH = $hi_cld_type_id;
    }
    else
    {
      $CH = "/";
    }

    $group = join("","8", $Nh, $CL, $CM, $CH);
    $section_1 = join(" ", $section_1, $group);
  }

# 9GGgg
  $GG = sprintf("%02i",$obs_hr);
  my $gg = sprintf("%02i",$obs_min);
  $group = join("","9", $GG, $gg);
  $section_1 = join(" ", $section_1, $group);


# section 2

# 222Dsvs
  my $Ds = $mv_plfm_dir_id;
  my $vs = $mv_plfm_spd_id;
  $group = join("","222",$Ds, $vs);
  $section_2 = $group;

# 0ssTwTwTw
  my $ss = $sea_temp_mthd;
  my $TwTwTw;
  if($sea_temp ne "" && $sea_temp ne "M")
  {
    if($sea_temp >= 0)
    {
      $TwTwTw = sprintf("%03i",$sea_temp * 10 );
    }
    else
    {
      $TwTwTw = sprintf("%03i",-$sea_temp * 10);
      if($ss eq "0")
      {
        $ss = "1";
      }
      if($ss eq "2")
      {
        $ss = "3";
      }
      if($ss eq "4")
      {
        $ss = "5";
      }
      if($ss eq "6")
      {
        $ss = "7";
      }
    }
    $group = join("","0", $ss, $TwTwTw);
    $section_2 = join(" ",$section_2, $group);
  }

# 1PwaPwaHwaHwa --- not collected

# 2PwPwHwHw
  my $PwPw = "";
  my $HwHw = "";
  if($wnd_wav_per ne "" || $wnd_wav_ht ne "")
  {
    if($wnd_wav_per eq "00")
    {
      $PwPw = "00";
      $HwHw = "00";
    }
    if($wnd_wav_per eq "99")
    {
      $PwPw = "99";
    }
    if($wnd_wav_ht eq "")
    {
      $HwHw = "//";
    }
    if($wnd_wav_per eq "")
    {
      $PwPw = "//";
    }
    if($PwPw eq "")
    {
      $PwPw = sprintf("%02i",$wnd_wav_per);
    }
    if($HwHw eq "")
    {
      my $HwHw_flt = sprintf("%.0f",$wnd_wav_ht * 0.60996);
      $HwHw = sprintf("%02i",$HwHw_flt);
    }

    $group = join("","2", $PwPw, $HwHw);
    $section_2 = join(" ",$section_2, $group);
  }
  
  
# 3dw1dw1dw2dw2
  my $dw1dw1;
  my $dw2dw2;
  if($pri_swl_wav_dir ne "" && $pri_swl_wav_dir ne "M")
  {
    my $dw1dw1_10 = sprintf("%.0f",$pri_swl_wav_dir / 10.);
    $dw1dw1 = sprintf("%02i", $dw1dw1_10);
    if($scdy_swl_wav_dir ne "" && $scdy_swl_wav_dir ne "M")
    {
      my $dw2dw2_10 = sprintf("%.0f",$scdy_swl_wav_dir / 10.);
      $dw2dw2 = sprintf("%02i", $dw2dw2_10);
    }
    else
    {
      $dw2dw2 = "//";
    }
    $group = join("","3", $dw1dw1, $dw2dw2);
    $section_2 = join(" ",$section_2, $group);
  }

# 4Pw1Pw1Hw1Hw1
  my $Pw1Pw1;
  my $Hw1Hw1;
  if($pri_swl_wav_per ne "" && $pri_swl_wav_per ne "M")
  {
    $Pw1Pw1 = sprintf("%02i", $pri_swl_wav_per);
  }
  else
  {
    $Pw1Pw1 = "//";
  }

  if($pri_swl_wav_ht ne "" && $pri_swl_wav_ht ne "M")
  {
    my $Hw1Hw1_flt = sprintf("%.0f",$pri_swl_wav_ht * 0.60996);
    $Hw1Hw1 = sprintf("%02i",$Hw1Hw1_flt);
  }
  else
  {
    $Hw1Hw1 = "//";
  }

  if($Pw1Pw1 ne "//" || $Hw1Hw1 ne "//")
  {
    $group = join("","4", $Pw1Pw1, $Hw1Hw1);
    $section_2 = join(" ",$section_2, $group);
  }

# 5Pw2Pw2Hw2Hw2
  my $Pw2Pw2;
  my $Hw2Hw2;
  if($scdy_swl_wav_per ne "" && $scdy_swl_wav_per ne "M")
  {
    $Pw2Pw2 = sprintf("%02i", $scdy_swl_wav_per);
  }
  else
  {
    $Pw2Pw2 = "//";
  }
  if($scdy_swl_wav_ht ne "" && $scdy_swl_wav_ht ne "M")
  {
    my $Hw2Hw2_flt = sprintf("%.0f",$scdy_swl_wav_ht * 0.60996);
    $Hw2Hw2 = sprintf("%02i",$Hw2Hw2_flt);
  }
  else
  {
    $Hw2Hw2 = "//";
  }
  if($Pw2Pw2 ne "//" || $Hw2Hw2 ne "//")
  {
    $group = join("","5", $Pw2Pw2, $Hw2Hw2);
    $section_2 = join(" ",$section_2, $group);
  }

# 6IsEsEsRs
  my $Is;
  my $EsEs;
  my $Rs;
  if($ice_accr_cause_id ne "" || $ice_accr_thkn ne "" || $ice_accr_rate_id ne "")
  {
    if($ice_accr_cause_id ne "")
    {
      $Is = $ice_accr_cause_id;
    }
    else
    {
      $Is = "/";
    }
    if($ice_accr_thkn ne "")
    {
      $EsEs = sprintf("%02i", $ice_accr_thkn);
    }
    else
    {
      $EsEs = "//";
    }
    if($ice_accr_rate_id ne "")
    {
      $Rs = $ice_accr_rate_id;
    }
    else
    {
      $Rs = "/";
    }
    $group = join("","6", $Is, $EsEs, $Rs);
    $section_2 = join(" ",$section_2, $group);
  }
  elsif($icing_rmrk ne "")
  {
    $group = join("","ICING",$icing_rmrk);
    $section_2 = join(" ",$section_2, $group);
  }

# 8swTbTbTb
  my $sw;
  if($wet_bulb_temp_sign eq "")
  {
    if($wet_bulb_temp_mthd eq "0")
    {
      $sw = "0";
    }
    if($wet_bulb_temp_mthd eq "1")
    {
      $sw = "2";
    }
    if($wet_bulb_temp_mthd eq "2")
    {
      $sw = "5";
    }
    if($wet_bulb_temp_mthd eq "3")
    {
      $sw = "7";
    }
  }
  else
  {
    if($wet_bulb_temp_mthd eq "0")
    {
      $sw = "1";
    }
    if($wet_bulb_temp_mthd eq "2")
    {
      $sw = "6";
    }
  }
  my $TbTbTb;
  if($wet_bulb_temp ne "" && $wet_bulb_temp ne "M")
  {
    $TbTbTb = sprintf("%03i",$wet_bulb_temp * 10);
    $group = join("","8", $sw, $TbTbTb);
    $section_2 = join(" ", $section_2, $group);
  }

# ICEciSibiDizi
  my $ci;
  my $Si;
  my $bi;
  my $Di;
  my $zi;

  if($sea_ice_conc_id ne "" || $ice_dev_stage_id ne "" || $ice_type_amt_id ne "" || $ice_edge_brg_id ne "" || $ice_sit_id ne "")
  {
    if($sea_ice_conc_id ne "")
    {
      $ci = $ice_accr_cause_id;
    }
    else
    {
      $ci = "/";
    }
    if($ice_dev_stage_id ne "")
    {
      $Si = $ice_dev_stage_id;
    }
    else
    {
      $Si = "//";
    }
    if($ice_type_amt_id ne "")
    {
      $bi = $ice_type_amt_id;
    }
    else
    {
      $bi = "/";
    }
    if($ice_edge_brg_id ne "")
    {
      $Di = $ice_edge_brg_id;
    }
    else
    {
      $Di = "/";
    }
    if($ice_sit_id ne "")
    {
      $zi = $ice_sit_id;
    }
    else
    {
      $zi = "/";
    }
    $group = join("","ICE", $ci, $Si, $bi, $Di, $zi);
    $section_2 = join(" ",$section_2, $group);
  }
  elsif($ice_rmrk ne "")
  {
    $group = join("","ICE",$ice_rmrk);
    $section_2 = join(" ",$section_2, $group);
  }

#
# MOBOB METAR
#

# vvvvvvvvvvvvvvvvvvv MOBOB wrapper vvvvvvvvvvvvvvvvvvv
# MOBOBQ
  my $Q;
  $Q = $oct;
  $group = join("","MOBOB", $Q);
  $section_m = $group;

# METAR
  $section_m = join(" ",$section_m, "METAR");

# CCCC
  my $CCCC = sprintf("%4s",$csgn_name);
  $section_m = join(" ", $section_m, $CCCC);

# imimHHH
  my $imim = "//";
  my $HHH = sprintf("%03.0f",$stn_ht / 10);
  $group = join("", $imim, $HHH); 
  $section_m = join(" ",$section_m, $group);

# LaLaLaLoLoLo
  $LaLaLa = sprintf("%03.0f",$lat * 10);
  my $LoLoLo;
  if($lon < 100)
  {
    $LoLoLo = sprintf("%03.0f",$lon * 10);
  }
  else
  {
    $LoLoLo = sprintf("%03.0f",($lon - 100) * 10);
  }
  $group = join("", $LaLaLa, $LoLoLo);
  $section_m = join(" ",$section_m, $group);
# ^^^^^^^^^^^^^^^^^^^ MOBOB wrapper ^^^^^^^^^^^^^^^^^^^
 
# YYGGggZ
  $YY = sprintf("%02i",$obs_day); 
  $GG = sprintf("%02i",$obs_hr);
  $gg = sprintf("%02i",$obs_min);
  $group = join("", $YY, $GG, $gg, "Z");
  $section_m = join("", $section_m, "\n");
  $section_m = join("",$section_m, $group);
  
# dddffGfmfmKT
  my $ddd;
  if($wnd_dir eq "" || $wnd_dir eq"M")
  {
    $ddd  = "///";
  }
  else
  {
    $ddd = sprintf("%03i",$wnd_dir);
  }
  if($wnd_spd eq "" || $wnd_spd eq "M")
  {
    $ff = "//";
  }
  else
  {
    if($wnd_spd < 99)
    {
      $ff = sprintf("%02.0f",$wnd_spd);
      $group = join("", $ddd, $ff);
    }
    else
    {
      $fff = $wnd_spd;
      $group = join("", $ddd, $fff);
    }
  }
  my $fmfm;
  my $fmfmfm;
  if($wnd_gst eq "" || $wnd_gst eq "M")
  {
    $group = join("", $group, "KT");
  }
  else
  {
    if($wnd_gst < 99)
    {
      $fmfm = sprintf("%02.0f",$wnd_gst);
      $group = join("", $group, "G", $fmfm, "KT");
    }
    else
    {
      $fmfmfm = $wnd_gst;
      $group = join("", $group, "G", $fmfmfm, "KT");
    }
  }

  if($wnd_spd == 0)
  {
    $group = "00000KT";
  }
  $section_m = join(" ", $section_m, $group);

# dndndnVdxdxdx
  my $dndndn;
  my $dxdxdx;
  if($wnd_vrb_1 ne "" && $wnd_vrb_1 ne "M" && $wnd_vrb_2 ne "" && $wnd_vrb_2 ne "M")
  {
    $dndndn = sprintf("%03.0f",$wnd_vrb_1);
    $dxdxdx = sprintf("%03.0f",$wnd_vrb_2);
    $group = join("", $dndndn, "V", $dxdxdx);
    $section_m = join(" ", $section_m, $group);
  }

# VVVVVSM
  my $VVVVV;
  if($horz_sfc_vsby ne ">10")
  {
    if($horz_sfc_vsby eq "0")
    {
      $VVVVV = "0";
    }
    elsif($horz_sfc_vsby eq "1/16")
    {
      $VVVVV = "1/16";
    }
    elsif($horz_sfc_vsby eq "1/8")
    {
      $VVVVV = "1/8";
    }
    elsif($horz_sfc_vsby eq "1/4")
    {
      $VVVVV = "1/4";
    }
    elsif($horz_sfc_vsby eq "1/2")
    {
      $VVVVV = "1/2";
    }
    elsif($horz_sfc_vsby eq "1")
    {
      $VVVVV = "1";
    }
    elsif($horz_sfc_vsby eq "1 1/2")
    {
      $VVVVV = "1 1/2";
    }
    elsif($horz_sfc_vsby eq "2")
    {
      $VVVVV = "2 1/4";
    }
    elsif($horz_sfc_vsby eq "2 1/2")
    {
      $VVVVV = "2 3/4";
    }
    elsif($horz_sfc_vsby eq "3")
    {
      $VVVVV = "3 1/2";
    }
    elsif($horz_sfc_vsby eq "4")
    {
      $VVVVV = "4 1/2";
    }
    elsif($horz_sfc_vsby eq "5")
    {
      $VVVVV = "5 3/4";
    }
    elsif($horz_sfc_vsby eq "6")
    {
      $VVVVV = "7";
    }
    elsif($horz_sfc_vsby eq "7")
    {
      $VVVVV = "8";
    }
    elsif($horz_sfc_vsby eq "8")
    {
      $VVVVV = "9";
    }
    elsif($horz_sfc_vsby eq "9")
    {
      $VVVVV = "10";
    }
    elsif($horz_sfc_vsby eq "10")
    {
      $VVVVV = "11";
    }
    $group = join("", $VVVVV, "SM");
    $section_m = join(" ", $section_m, $group);
  }

# w'w'
  if($prsnt_wx ne "")
  {
    $section_m = join(" ", $section_m, $prsnt_wx);
  }

# clouds
# NsNsNshshshs

  if($cld_base_ht_id ne "" && $cld_base_ht_id ne "9")
  {
    my $hshshs;
    if($cld_base_ht_id eq "0")
    {
      $hshshs = "001";
      $group = $hshshs;
    }
    elsif($cld_base_ht_id eq "1")
    {
      $hshshs = "002";
      $group = $hshshs;
    }
    elsif($cld_base_ht_id eq "2")
    {
      $hshshs = "005";
      $group = $hshshs;
    }
    elsif($cld_base_ht_id eq "3")
    {
      $hshshs = "008";
      $group = $hshshs;
    }
    elsif($cld_base_ht_id eq "4")
    {
      $hshshs = "015";
      $group = $hshshs;
    }
    elsif($cld_base_ht_id eq "5")
    {
      $hshshs = "027";
      $group = $hshshs;
    }
    elsif($cld_base_ht_id eq "6")
    {
      $hshshs = "042";
      $group = $hshshs;
    }
    elsif($cld_base_ht_id eq "7")
    {
      $hshshs = "058";
      $group = $hshshs;
    }
    elsif($cld_base_ht_id eq "8")
    {
      $hshshs = "075";
      $group = $hshshs;
    }
    elsif($cld_base_ht_id eq "/")
    {
      $hshshs = "///";
      $group = $hshshs;
    }

    my $NsNsNs;
    if($tot_cld_amt_id eq "1" || $tot_cld_amt_id eq "2")
    {
      $NsNsNs = "FEW";
      $group = join("",  $NsNsNs, $group);
      
    }
    elsif($tot_cld_amt_id eq "3" || $tot_cld_amt_id eq "4")
    {
      $NsNsNs = "SCT";
      $group = join("", $NsNsNs, $group);
    }
    elsif($tot_cld_amt_id eq "5" || $tot_cld_amt_id eq "6" || $tot_cld_amt_id eq "7")
    {
      $NsNsNs = "BKN";
      $group = join("", $NsNsNs, $group);
    }
    elsif($tot_cld_amt_id eq "8")
    {
      $NsNsNs = "OVC";
      $group = join("", $NsNsNs, $group);
    }
    elsif($tot_cld_amt_id eq "0")
    {
      $group = "SKY";
    }
    else
    {
      $group = join("", "VV", $group);
    }
    $section_m = join(" ", $section_m, $group);

  }
  elsif($cld_base_ht_id eq "9")
  {
    $group = "SKY";
    $section_m = join(" ", $section_m, $group);
  }

# TT/TdTd
  my $TT;
  if($air_temp ne "" && $air_temp ne "M")
  {
    $TT = sprintf("%02.0f",$air_temp);
  }
  else
  {
    $TT = "//";
  }

  if($air_temp_sign ne "")
  {
    $TT = join("", "M", $TT);
  }

  my $TdTd;
  if($dwpt ne "" && $dwpt ne "M")
  {
    $TdTd = sprintf("%02.0f",$dwpt);
  }
  else
  {
    $TdTd = "//";
  }

  if($dwpt_sign ne "")
  {
    $TdTd = join("", "M", $TdTd);
  }

  $group = join("", $TT, "/", $TdTd);
  $section_m = join(" ", $section_m, $group);

# APHPHPHPH
  my $PHPHPHPH = $alt_set;
  $group = join("", "A", $PHPHPHPH);
  $section_m = join(" ", $section_m, $group);

# RMK

  my $RMK = $rmrks;
  if($sea_lvl_pres ne "" && $sea_lvl_pres ne "M")
  {
    my $SLP = $sea_lvl_pres;

    if    ($SLP >= 10000) {$SLP -= 10000;}
    elsif ($SLP >=  9000) {$SLP -=  9000;}
    elsif ($SLP >=  8000) {$SLP -=  8000;}

    $SLP = sprintf("%03.0f",$SLP);
    $RMK = join("", $RMK, " SLP:", $SLP);
  }
  if($wnd_wav_per ne "" && $wnd_wav_per ne "M" && $wnd_wav_ht ne "" && $wnd_wav_ht ne "M")
  {
    my $WWP = sprintf("%02.0f",$wnd_wav_per);
    my $WWH = sprintf("%02.0f",$wnd_wav_ht);
    $RMK = join("", $RMK, " SEAS:", $WWP, $WWH);
  }
  if($pri_swl_wav_dir ne "" && $pri_swl_wav_dir ne "M" && $pri_swl_wav_per ne "" && $pri_swl_wav_per ne "M" && $pri_swl_wav_ht ne "" && $pri_swl_wav_ht ne "M")
  {
    my $SWD = sprintf("%02.0f",($pri_swl_wav_dir / 10));
    my $SWP = sprintf("%02.0f",$pri_swl_wav_per);
    my $SWH = sprintf("%02.0f",$pri_swl_wav_ht);
    $RMK = join("", $RMK, " SWELL:", $SWD, $SWP, $SWH);
  }
  $group = join("", "RMK ", $RMK);
  $section_m = join("", $section_m, "\n");
  $section_m = join("", $section_m, $group);
}
elsif($data_type eq "bathy_form")
{

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
# $group = join("", $GG, $gg, $units);
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
 for ($i = 0; $i <= $profile_cnt; $i++)
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
}

if($results eq "submit")
{
    #
    # write out values into a diagnostic file
    #

    my $unq_num;
    $unq_num = $$;
    $unq_num = sprintf( "%010d", $unq_num );

    my $file_name = "encode_${data_type}.$csgn_name.$sub_dtg.$unq_num" =~ /^([\w.]+)$/;
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

    open( my $ENCODE, ">", $output_encode_file_name ) or die "Can't open diagnostic file, $output_encode_file_name: $!";

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
        #$dcls_inst = sprintf("%04d-%02d-%02d", $dcls_y, $dcls_mon, $dcls_day);
      }
      $dps_hdr = join("\n", $dps_hdr, "DECLASSIFY ON:");
      $dps_hdr = join(" ", $dps_hdr, $dcls_inst);
    }
    $dps_hdr = join("\n", $dps_hdr, "SHIPNAME:");
    $dps_hdr = join(" ", $dps_hdr, $ship_name);
    $dps_hdr = join("\n", $dps_hdr, "END");

    print( $DIAG "$dps_hdr\n" );
    print( $ENCODE "$dps_hdr\n" );

    if($data_type eq "ship_sfc_form")
    {
      print( $DIAG "$section_0\n" );
      print( $ENCODE "$section_0\n" );
      print( $DIAG "$section_1\n" );
      print( $ENCODE "$section_1\n" );
      print( $DIAG "$section_2" );
      print( $ENCODE "$section_2" );
      print( $DIAG "=\n" );
      print( $ENCODE "=\n" );
      print( $DIAG "$section_m" );
      print( $ENCODE "$section_m" );
    }
    elsif($data_type eq "bathy_form")
    {
      print( $DIAG "$section_1\n" );
      print( $ENCODE "$section_1\n" );
      print( $DIAG "$section_2" );
      print( $ENCODE "$section_2" );
      print( $DIAG " $section_4" );
      print( $ENCODE " $section_4" );
    }
    print( $DIAG "=" );
    print( $ENCODE "=" );

    close( $DIAG );
    chmod( 0664, "$output_file_name" );
    close( $ENCODE );
    chmod( 0664, "$output_encode_file_name" );
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

  my $file_name = "raw_${data_type}.$csgn_name.$sub_dtg.$unq_num" =~ /^([\w.]+)$/;
  $file_name = $1;
  my $output_file_name  = "../dynamic/archive/$clas/$file_name";

  open( my $FILE, ">",  $output_file_name ) or die "Can't open $output_file_name: $!";

  print $FILE "----- Point of Origin ----\n";
  print $FILE "observer title        $observer_title\n";
  print $FILE "observer              $observer\n";
  print $FILE "email                 $email\n";
  print $FILE "csgn_name             $csgn_name\n";
  print $FILE "ship_title            $ship_title\n";
  print $FILE "ship_name             $ship_name\n";
  print $FILE "-- Time of Observationn ---\n";
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
  print $FILE "\n----- Browser Type ---------\n";
  print $FILE "$browser_type\n";

  if( $data_type eq "ship_sfc_form" )
  {
      print $FILE "---------- Part 1 ----------\n";
      print $FILE "rpt_typ_id            $rpt_typ_id\n";
      print $FILE "wnd_dir               $wnd_dir\n";
      print $FILE "wnd_spd               $wnd_spd\n";
      print $FILE "wnd_mthd              $wnd_mthd\n";
      print $FILE "wnd_gst_type          $wnd_gst_type\n";
      print $FILE "wnd_gst               $wnd_gst\n";
      print $FILE "wnd_vrb_1             $wnd_vrb_1\n";
      print $FILE "wnd_vrb_2             $wnd_vrb_2\n";
      print $FILE "horz_sfc_vsby         $horz_sfc_vsby\n";
      print $FILE "horz_sfc_vsby_id      $horz_sfc_vsby_id\n";
      print $FILE "horz_sfc_vsby_type    $horz_sfc_vsby_type\n";
      print $FILE "prsnt_wx              $prsnt_wx\n";
      print $FILE "sky_cdn               $sky_cdn\n";
      print $FILE "air_temp_sign         $air_temp_sign\n";
      print $FILE "air_temp              $air_temp\n";
      print $FILE "dwpt_sign             $dwpt_sign\n";
      print $FILE "dwpt                  $dwpt\n";
      print $FILE "wet_bulb_temp_sign    $wet_bulb_temp_sign\n";
      print $FILE "wet_bulb_temp         $wet_bulb_temp\n";
      print $FILE "alt_set_type          $alt_set_type\n";
      print $FILE "alt_set               $alt_set\n";
      print $FILE "rmrks                 $rmrks\n";
      print $FILE "stn_lvl_pres_type     $stn_lvl_pres_type\n";
      print $FILE "stn_lvl_pres          $stn_lvl_pres\n";
      print $FILE "sea_lvl_pres          $sea_lvl_pres\n";
      print $FILE "tot_cld_amt_id        $tot_cld_amt_id\n";
      print $FILE "lat                   $lat\n";
      print $FILE "lat_sign              $lat_sign\n";
      print $FILE "lon                   $lon\n";
      print $FILE "lon_sign              $lon_sign\n";
      print $FILE "mv_plfm_dir_1         $mv_plfm_dir_1\n";
      print $FILE "mv_plfm_spd_1         $mv_plfm_spd_1\n";
      print $FILE "sea_temp              $sea_temp\n";
      print $FILE "wnd_wav_ht            $wnd_wav_ht\n";
      print $FILE "wnd_wav_per           $wnd_wav_per\n";
      print $FILE "pri_swl_wav_dir       $pri_swl_wav_dir\n";
      print $FILE "pri_swl_wav_ht        $pri_swl_wav_ht\n";
      print $FILE "pri_swl_wav_per       $pri_swl_wav_per\n";
      print $FILE "scdy_swl_wav_dir      $scdy_swl_wav_dir\n";
      print $FILE "scdy_swl_wav_ht       $scdy_swl_wav_ht\n";
      print $FILE "scdy_swl_wav_per      $scdy_swl_wav_per\n";
      print $FILE "---------- Part 2 ----------\n";
      print $FILE "wnd_id                $wnd_id\n";
      print $FILE "stn_type_id           $stn_type_id\n";
      print $FILE "cld_base_ht_id        $cld_base_ht_id\n";
      print $FILE "pres_tdcy_char_id     $pres_tdcy_char_id\n";
      print $FILE "pres_tdcy_amt         $pres_tdcy_amt\n";
      print $FILE "pres_wx_id            $pres_wx_id\n";
      print $FILE "past_wx_id_1          $past_wx_id_1\n";
      print $FILE "past_wx_id_2          $past_wx_id_2\n";
      print $FILE "low_cld_amt_id        $low_cld_amt_id\n";
      print $FILE "low_cld_type_id       $low_cld_type_id\n";
      print $FILE "mid_cld_type_id       $mid_cld_type_id\n";
      print $FILE "hi_cld_type_id        $hi_cld_type_id\n";
      print $FILE "mv_plfm_dir_id        $mv_plfm_dir_id\n";
      print $FILE "mv_plfm_spd_id        $mv_plfm_spd_id\n";
      print $FILE "ice_accr_cause_id     $ice_accr_cause_id\n";
      print $FILE "ice_accr_thkn         $ice_accr_thkn\n";
      print $FILE "ice_accr_rate_id      $ice_accr_rate_id\n";
      print $FILE "sea_ice_conc_id       $sea_ice_conc_id\n";
      print $FILE "icing_rmrk            $icing_rmrk\n";
      print $FILE "ice_dev_stage_id      $ice_dev_stage_id\n";
      print $FILE "ice_type_amt_id       $ice_type_amt_id\n";
      print $FILE "ice_edge_brg_id       $ice_edge_brg_id\n";
      print $FILE "ice_sit_id            $ice_sit_id\n";
      print $FILE "ice_rmrk              $ice_rmrk\n";
      print $FILE "----------- Misc. ------i----\n";
      print $FILE "stn_ht                $stn_ht\n";
      print $FILE "rel_hum               $rel_hum\n";
      print $FILE "wet_bulb_temp_mthd    $wet_bulb_temp_mthd\n";
      print $FILE "sea_temp_mthd         $sea_temp_mthd\n";
      #print $FILE "std_isob_sfc          $std_isob_sfc\n";
      #print $FILE "geop_std_isob_sfc     $geop_std_isob_sfc\n";
      #print $FILE "inst_wav_ht_1         $inst_wav_ht_1\n";
      #print $FILE "inst_wav_ht_1         $inst_wav_ht_2\n";
      #print $FILE "inst_wav_per          $inst_wav_per\n";
  }
  elsif( $data_type eq "bathy_form" )
  {
      print $FILE "--------- Location ---------\n";
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
      print $FILE "--------- Message ----------\n";
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
      print $FILE "--------- Profile ----------\n";

      if($units eq "/")
      {
        print $FILE "zz - meters / tt - C\n";
      }
      else
      {
        print $FILE "zz - feet / tt - F\n";
      }

      my $i;
      for ($i = 0; $i <= $profile_cnt; $i++)
      {
        print $FILE "zz${i} $zz[$i]  ttt${i} $ttt[$i]\n";
      }    
  }

  close( $FILE );
  chmod( 0664, "$output_file_name" );

  return();

}#End form_output

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
  
  while( $done != 1 )
  {
    $month = $month + 1;
  
    if( $month == 1 || $month == 3 || $month == 5 || $month == 7 || $month == 8 || $month == 10 || $month == 12 )
    {
      $daysofmth = 31;
    }
    elsif( $month == 2 )
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
    elsif($month == 4 || $month == 6 || $month == 9 || $month == 11)
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
    #if($month == 12)
    #{
    #  $year = $year + 1;
    #  $julday = $julday - 31;
    #  $month = 0;
    #}
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
  ( $title, $data_type ) = @_;

  $title =~ s/[^a-zA-Z' ]//g;
  $data_type =~ s/[^a-zA-Z_]//g;

  # setup web directory.  
  my @str_array=split("\/", $ENV{SCRIPT_NAME});
  $sub_dir = $str_array[1];
  $web_dir="$ENV{SERVER_NAME}/$sub_dir";

  #
  # form introduction
  #
    if($data_type eq "ship_sfc_form")
    {
      $form_intro="<b>U.S. Manual for Ships' Surface Weather Observations</b>
                   <br>
                   <a href='../3144_1D_htm/31441e.pdf' target='31441E'>COMNAVMETOCCOM 3144.1E</a>
                   <br>
                   <a href='../3144_1D_htm/31441ech1.pdf' target='31441ECH1'>COMNAVMETOCCOM 3144.1E CH-1</a>";

      $form_explanation="<br>All ships MUST use COMNAVMETOCCOM Form 3141/3 to record observations
                        <br>Original observations are required to be archived onboard for a minimum of 6 months
                        <br>
                        <br>Synoptic Hours - 0000Z, 0600Z, 1200Z, 1800Z
                        <br>Asynoptic Hours - 0300Z, 0900Z, 1500Z, 2100Z";

    }
    elsif($data_type eq "bathy_form")
    {
      $form_intro="";
      $form_explanation="";
    }

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

    &form_input();
    if($results eq "submit" && $accept_location eq "unk")
    {
      &check_location();
    }
    elsif($results eq "submit" && $accept_location eq "yes")
    {
      &activity_file();
      &process_data();
      &diag_output();
      &form_output();
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

