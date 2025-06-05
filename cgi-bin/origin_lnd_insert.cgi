#!/usr/bin/perl -Tw
#
# origin_lnd_insert.cgi
#
# Prints out HTML for origin_lnd_insert form
#

use strict;
use warnings;

my $check_email = shift;
if ( $check_email =~ /^([a-z]+)$/ ){ $check_email = $1; } #untainting
my $stn_id = shift;
if( $stn_id =~ /^([a-aA-Z0-9]+)$/ ){ $stn_id = $1; } #untainting

my $TD = " ";
# XBT must take land information and turn it into a ship to be able to utilize wmo_routines.pm
if( $stn_id eq "Flight_ID" )
{
    $TD = '<input type="hidden" name="ship_title" value="USS">';
}

print <<EOF;
<tr>
<td>
<!-- ********************************** Point of Origin Information ************************************ -->
  <fieldset>
  <legend><b>Point of origin information</b></legend>
  <table>
  <tr>

  <td style="text-align:left;">
    <tr>
    <td style="text-align:left;">Observer name:</td>
    <td style="text-align:left;">
    <input tabindex="1" size="40" maxlength="40" type="TEXT" name="observer" id="observer" onblur="check_str_state(this.value,'observer');">
    </td>
    </tr>

    <tr>
    <td style="text-align:left;">Email:</td>
    <td style="text-align:left;">
    <input tabindex="1" size="20" maxlength="40" type="TEXT" name="email" id="email" onblur="${check_email}(this.value,'email');">
    </td>
    </tr>

    <tr>
    <td style="text-align:left;">${stn_id}:</td>
    <td style="text-align:left;">
    <input tabindex="1" size="9" maxlength="9" type="TEXT" name="stn_id" id="stn_id" onblur="check_str_int_state(this.value,'stn_id');">
    </td>
    </tr>

    <tr>
    <td style="text-align:left;">Station name:</td>
    <td style="text-align:left;">
    <input tabindex="1" size="40" maxlength="40" type="TEXT" name="stn_name" id="stn_name" onblur="check_str_int_state(this.value,'stn_name');">
    ${TD}
    </td>

  </tr>
  </table>
  </fieldset>
</td>
</tr>
EOF
