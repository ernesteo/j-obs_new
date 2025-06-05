#!/usr/bin/perl -Tw
#
# origin_insert.cgi
#
# Dynamically creates the ship drop down list
#

use strict;
use warnings;

my $check_email = shift;
if ( $check_email =~ /^([a-z]+)$/ ){ $check_email = $1; } #untainting

my $ship_ref_file = "/fnmoc/u/curr/etc/static/app/msl/navy_shp_ref_lib";
my $file_sz       = -s $ship_ref_file;

my ( $bufr,          @file_arr,               $line,
     $call_sign,     $name,                   $org,
   );

open( my $SHP, "<", $ship_ref_file ) or die "'$ship_ref_file' failed to open!: $!";
read( $SHP, $bufr, $file_sz );
close( $SHP );

print <<EOF;
<tr>
<td>
<!-- ********************************** Point of Origin Information ************************************ -->
  <fieldset>
  <legend><b>Point of origin information</b></legend>
  <table>
  <tr>

  <td align="left">
    <tr>
    <td style="text-align:left;"><a href="../observer.html" target="OBS_TITLE">Observer:</a></td>
    <td style="text-align:left;">
    <select tabindex="1" name="observer_title" id="observer_title">
      <option value="Aerographer's Mate">Aerographer's Mate</option>
      <option value="Quartermaster">Quartermaster</option>
      <option value="Sonar Technician">Sonar Technician</option>
      <option value="other">other</option>
    </select>
    <input tabindex="1" size="20" maxlength="40" type="TEXT" name="observer" id="observer" onblur="check_str_state(this.value,'observer');">
    </td>
    </tr>

    <tr>
    <td style="text-align:left;">Email:</td>
    <td style="text-align:left;">
    <input tabindex="1" size="20" maxlength="40" type="TEXT" name="email" id="email" onblur="$check_email(this.value,'email');">
    </td>
    </tr>

    <tr>
    <td style="text-align:left;">Ship call sign:</td>
    <td style="text-align:left;">
    <input tabindex="1" size="4" maxlength="4" type="TEXT" name="csgn_name" id="csgn_name" onkeyup="search_cs()" onblur="check_ship_call_sign(this.value,'csgn_name');">

<SELECT id="csgn_name_list" onclick="select_cs()">
<OPTION value=""></OPTION>
<OPTION value="ZZZZ-NOT IN LIST">NOT IN LIST</OPTION>

EOF


    #Dynamically fill csgn_name_list
    @file_arr = split( "\n", $bufr );
    for my $line ( @file_arr )
    {
        ( $call_sign, $name, $org ) = split( "\:", $line );
        
        $call_sign =~ s/\s*$// ;
        $name      =~ s/\s*$// ;
        $org       =~ s/\s*$// ;

        print "<OPTION value=\"$call_sign-$org $name\">$call_sign-$org $name</OPTION>\n";
    }

print <<EOF;
</SELECT>

    </td>
    </tr>

    <tr>
    <td>Ship:</td>
    <td>
    <select tabindex="1" name="ship_title" id="ship_title">
      <option value="USS">USS</option>
      <option value="USNS">USNS</option>
      <option value="USCGC">USCGC</option>
      <option value="other">other</option>
    </select>
    <input tabindex="1" size="40" maxlength="40" type="TEXT" name="ship_name" id="ship_name" onblur="check_str_state(this.value,'ship_name');">
    If empty, enter ship\'s name
    </td>
  <td>

  </tr>
  </table>
  </fieldset>
</td>
</tr>

EOF
