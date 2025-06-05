#!/usr/bin/perl -T

use warnings;
use strict;

#
# Setup Pearl CGI
#
use lib "/fnmoc/u/curr/lib/perllib";
use CGI;
use lib "../lib";
use sys_info qw(getDevLevel getHostClass getAppName);
use web_routines qw(getClasBnr getClas);

$ENV{'PATH'} = '/usr/bin';
delete @ENV{'IFS', 'CDPATH', 'BASH_ENV'};

# remove before promotion
# use CGI::Carp "fatalsToBrowser";

#
# Setup object-oriented CGI
#
#my $q = CGI->new();

#============================= Begin main script ===============================

my ($dir,$data_type, $name, $dtg, $uniq_num);
my ($year, $month, $day, $hour, $minute, $second);
my (@data_type_list);
my (@field_array);
my (@name_sort, $name_sort_cnt);
my (@name_cnt);
my (@name_cnt_1_7);
my (@name_cnt_8_14);
my ($i, $j, $k, $l, $m);
my ($sec, $min, $hr, $mday, $mon, $yr, $wday, $yday, $dlight);
my ($time);
my (@date);
my (@md);
my ($date_ob);
my ($string, $line, $sub_line);
my (@clas_list);
my ($clas_list_cnt);
my ($line_ok);
my ($file_name);
my ($section);
my ($section_ok);
my ($date_rd);
my ($time_rd);
my ($csgn);
my ($ship_name);
my ($title);
my (%ship_name_hash);
my ($clas_banner);
my ($date_14);
my ($data_type_list_cnt);
my ($dir_clas);
my ($CLAS);
my ($file);
my ($field_array_cn);
my ($td_cnt);
my ($field_array_cnt);
my $shp_ref_lib = "/fnmoc/u/curr/etc/static/app/msl/navy_shp_ref_lib";

open( my $FILE, "<", "../html/data_display.html_template" ) or die "Can't open ../html/data_display.html_template: $!";

print "Content-type: text/html\n\n";

#
# read ship name file
#
open( my $SFILE, "<", $shp_ref_lib ) or die "Can't open '$shp_ref_lib': $!";

while( $line = <$SFILE> )
{
  ( $csgn, $ship_name, $title ) = split( /\:/,$line );
  $csgn =~ s/\s+$//;
  $ship_name =~ s/\s+$//;
  $ship_name_hash{$csgn} = $ship_name;
}

close( $SFILE );

$clas_banner = getClasBnr();

while ($line = <$FILE>)
{
#
# skip line
#
  if(index($line,'//') == 0)
  {
    next;
  }
#
# classification banner
#
  if(index($line,"#CLAS_BANNER#") >=0)
  {
    $line = $clas_banner;
  }

#
# setup insert lines
#
  if(index($line,"#INSERT#") >=0)
  {
    if(getHostClass() eq "unclas")
    {
      @clas_list = ("unclas");
    }
    elsif(getHostClass() eq "secret")
    {
      @clas_list = ("unclas", "confid", "secret");
    }
    else
    {
      @clas_list = ("unclas");
    }

$clas_list_cnt = @clas_list;

#
# Create date 14 days ago.
#

$time = time() - 14 * 24 * 60 *60;
($sec, $min, $hr, $mday, $mon, $yr, $wday, $yday, $dlight) = gmtime($time);
$mon = $mon + 1;
$yr = $yr + 1900;
$date_14 = sprintf("%04d%02d%02d",$yr,$mon,$mday);

#
# Create data type list
#
@data_type_list = ("ship_sfc","ship_sfc_form","ship_raob","ship_mo_taf","bathy","bathy_csv","bathy_form",
                   "tesac","lnd_mo_sfc","lnd_mo_raob","lnd_mo_taf","acft_amdar","bufr");
$data_type_list_cnt = @data_type_list;

#
# Identify archive directory
#
$dir="../dynamic/archive";

#
# Cycle through classifications
#
print "\n<br>\n";
for ($l = 0; $l < $clas_list_cnt; $l++)
{
  $dir_clas = "$dir/$clas_list[$l]";
  $CLAS = $clas_list[$l];
  $CLAS =~ tr/a-z/A-Z/;
  print "<br>\n";
  print "<b>========================================== $CLAS ==========================================</b><br>\n";

#
# Read archived encoded file names.
#
  opendir(DIR, $dir_clas) or die "can't open directory: $dir_clas";
  my (@final, %hash) = ((), ());
  (@field_array) = (());
  while (defined($file = readdir(DIR)))
  {
    if ($file =~ /^raw_/)
    {
      $file =~ s/^raw_//;
      push(@field_array, $file);
#
# Split out data type, call sign/station name, dtg and unique number
# from file name.
#
      ($data_type, $name, $dtg, $uniq_num) = split(/\./,$file);
#
# remove duplicate names and create name list
#
      if (not exists $hash{$name})
      {
        push @final, $name;
        $hash{$name} = 1;
      }
    }
  }
  close(DIR);
# @field_array = reverse(@field_array);
  @field_array = sort(@field_array);
  $field_array_cnt = @field_array;

#
# Sort names
#
  @name_sort = sort(@final);
  $name_sort_cnt = @final;


#
# Cycle through data types
#
  print "<table>\n";

  for ($j = 0; $j < $data_type_list_cnt; $j++)
  {
    $section_ok = 0;
    $section = "<tr>\n";
    $section = join("", $section, "<td>\n");
    $section = join("", $section, "<br><b><U>$data_type_list[$j]</U></b>\n");
    $section = join("", $section, "</td>\n");
    $section = join("", $section, "</tr>\n");
#
# Cycle through names
#
    $section = join("", $section, "<tr>\n");

    $td_cnt = 1;
    for ($k = 0; $k < $name_sort_cnt; $k++)
    {
      $line_ok = "0";
      $line = "<td style='text-align:center'>\n";
      $line = join("",$line, "<b>");
      $line = join("",$line, " $name_sort[$k]");
      $csgn = $name_sort[$k];
      if(defined $ship_name_hash{$csgn})
      {
        $ship_name = $ship_name_hash{$csgn};
      }
      else
      {
        $ship_name = "UNKNOWN";
      }
      $line = join("",$line, " ($ship_name)");
      $line = join("",$line, "</b>");
      $line = join("",$line, "\n<br>\n");
#
# Cycle through fields
#
      $line = join('',$line,  "<select tabindex='1' name='file_t' onblur='submit_values([this.value]);'>\n");

#
# Form drop-down listing of observations
#
#     for ($i = 0; $i < $field_array_cnt; $i++)
# CDM --- have most recent at top
      for ($i = $field_array_cnt-1; $i >= 0; $i--)
      {
        ($data_type, $name, $dtg, $uniq_num) = split(/\./,$field_array[$i]);
        ($year, $month, $day, $hour, $minute, $second) = ($dtg =~ /^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/);
        $date_ob = join("",$year, $month, $day);
        $date_rd = sprintf("%02d/%02d/%04d %02d%02dZ", $month, $day, $year, $hour, $minute);
#
#    Find the observations
#
        if($data_type eq $data_type_list[$j] && $name_sort[$k] eq $name)
        {
          if($date_ob ge $date_14)
          {
            $line = join('',$line, "<option value='$clas_list[$l]/#DATA_FORM#_$field_array[$i]'>$date_rd</option>\n");
            $section_ok = "1";
            $line_ok = "1";
          }
        }
      }


      $line = join('', $line, "</select>\n");
      $line = join("", $line, "</td>\n");

      if($line_ok eq "1")
      {
        $section = join("", $section, $line);
        $td_cnt++;
      }

      if($td_cnt > 5)
      {
        if($k < $name_sort_cnt - 1)
        {
          $line = "</tr>\n";
          $line = join("", $line, "<tr>\n");
          $section = join("", $section, $line);
        }
        $td_cnt = 1;
      }
    }

    if($section_ok eq "1")
    {
      $section = join("", $section, "</tr>\n");
      print ("$section");
    } 
  }
  print "</table>\n";

}

}
else
{
  print "$line\n";
}

}
close( $FILE );
