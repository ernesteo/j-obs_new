#!/usr/bin/perl -T

use warnings;
use strict;

#
# Setup Pearl CGI
#
# use lib "/gpfs/apps/webservices";
use CGI;
use lib "../lib";
use sys_info qw(getDevLevel getHostClass getAppName);
use web_routines qw(printClasBnr getClas);

$ENV{'PATH'} = '/usr/bin';
delete @ENV{'IFS', 'CDPATH', 'BASH_ENV'};

#============================= Begin main script ===============================
#
# print beginning HTML lines
#
print "Content-type: text/html\n\n";

print "<!DOCTYPE html>";
print "<html>";
print "<head>";
print "<title>J-OBS usage statistics</title>";
print "</head>";
print "<body>";
print <<EOF;
     <link rel="stylesheet" type="text/css" href="/common/css/common.css" />
     <link rel="stylesheet" type="text/css" href="../css/util.css" />
EOF

#
# print clasiification bar
#
printClasBnr();

print <<EOF;
     J-OBS usage statistics
     <pre>
EOF

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
my ($string_ok);
my ($csgn);
my ($ship_name);
my ($title);
my (%ship_name_hash);
my ($file);
my ($dir_clas);
my ($data_type_list_cnt);
my ($field_array_cnt);
my $shp_ref_lib = "/fnmoc/u/curr/etc/static/app/msl/navy_shp_ref_lib";


#
# determine clasiification list
#
if(getHostClass() eq "secret")
{ 
  @clas_list = ("unclas", "confid", "secret");
}
else
{ 
  @clas_list = ("unclas");
}

$clas_list_cnt = @clas_list;


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


#
# Create dates
#
$time = time();
for ($m=0; $m <= 14; $m++)
{
  $time = time() - 86400 * $m;
  ($sec, $min, $hr, $mday, $mon, $yr, $wday, $yday, $dlight) = gmtime($time);
  $mon = $mon + 1;
  $yr = $yr + 1900;
  $date[$m] = sprintf("%04d%02d%02d",$yr,$mon,$mday);
  $md[$m] = sprintf("%02d/%02d",$mon,$mday);
}


#
# Create data type list
#
@data_type_list = ("ship_sfc","ship_sfc_form","ship_raob","ship_mo_taf","bathy","bathy_form","tesac",
                   "lnd_mo_sfc","lnd_mo_raob","lnd_mo_taf","acft_amdar","bufr", "bathy_csv");
$data_type_list_cnt = @data_type_list;


#
# Identify archive directory
#
$dir="../dynamic/archive";

#
# Cycle through classifications
#
print "UTC date $md[0]  $md[1]  $md[2]  $md[3]  $md[4]  $md[5]  $md[6]  $md[7]  $md[7] - $md[1]  $md[14] - $md[8]\n";
print "         TODAY\n";

for ($l = 0; $l < $clas_list_cnt; $l++)
{
  $dir_clas = "$dir/$clas_list[$l]";
  print "\n<br>-------------------------------------------<b>$clas_list[$l]</b>--------------------------------------------\n";


#
# Read archived encoded file names.
#
  opendir(DIR, $dir_clas) or die "can't open directory: $dir_clas";
  my (@final, %hash,) = ((), ());
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
# remove duplicate names ans create name list
#
      if (not exists $hash{$name})
      {
        push @final, $name;
        $hash{$name} = 1;
      }
    }
  }
  close(DIR);
  $field_array_cnt = @field_array;


#
# Sort names
#
  @name_sort = sort(@final);
  $name_sort_cnt = @final;

#
# Cycle through data types
#
  for ($j = 0; $j < $data_type_list_cnt; $j++)
  {

#
# Cycle through names
#
    for ($k = 0; $k < $name_sort_cnt; $k++)
    {
      for ($m = 0; $m <= 14; $m++)
      {
        $name_cnt[$k][$j][$m] = 0;
      }
      $name_cnt_1_7[$k][$j] = 0;
      $name_cnt_8_14[$k][$j] = 0;

#
# Cycle through fields
#
      for ($i = 0; $i < $field_array_cnt; $i++)
      {
        ($data_type, $name, $dtg, $uniq_num) = split(/\./,$field_array[$i]);
        ($year, $month, $day, $hour, $minute, $second) = ($dtg =~ /^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/);
        $date_ob = join("",$year, $month, $day);
#
# Select data type and name
#
        if($data_type eq $data_type_list[$j] && $name_sort[$k] eq $name)
        {
          for ($m = 0; $m <= 14; $m++)
          {
            if($date_ob eq $date[$m])
            {
              $name_cnt[$k][$j][$m] = $name_cnt[$k][$j][$m] + 1;
            }
          }
          if($date_ob lt $date[1] && $date_ob ge $date[7])
          {
            $name_cnt_1_7[$k][$j] = $name_cnt_1_7[$k][$j] + 1;
          }
          if($date_ob lt $date[8] && $date_ob ge $date[14])
          {
            $name_cnt_8_14[$k][$j] = $name_cnt_8_14[$k][$j] + 1;
          }
        }
      }
    }
  }


#
# Display counts
#
  for ($j = 0; $j < $data_type_list_cnt; $j++)
  {
    $string_ok = 0;
    $string = sprintf("\n%-14s\n", "<b>$data_type_list[$j]</b>");
    for ($k = 0; $k < $name_sort_cnt; $k++)
    {
      $line_ok = 0;

      for ($m = 0; $m <= 14; $m++)
      {
        if( $name_cnt[$k][$j][$m] > 0 )
        {
          $line_ok = 1;
        }
      }

      if($line_ok eq "1")
      {
        $csgn = $name_sort[$k];

        if(defined $ship_name_hash{$csgn})
        {
          $ship_name = $ship_name_hash{$csgn};
        }
        else
        {
          $ship_name = "UNKNOWN";
        }
        $string = join("",$string, "($ship_name)\n");

        $line = sprintf(" %4s ", $name_sort[$k]);
        for ($m = 0; $m <= 7; $m++)
        { 
          $sub_line = sprintf("%3d",$name_cnt[$k][$j][$m]);
          $line = join("    ",$line, $sub_line)
        }
        $sub_line = sprintf("     %3d",$name_cnt_1_7[$k][$j]); 
        $line = join("   ",$line, $sub_line);
        $sub_line = sprintf("         %3d\n",$name_cnt_8_14[$k][$j]); 
        $line = join("   ",$line, $sub_line);
        $string = join("",$string, $line);
        $string_ok = 1;
      }
    }
    if($string_ok eq "1")
    {
      print $string;
    }
  }
}


print <<EOF;
   </pre>
EOF
     

#
# print clasiification bar
#
printClasBnr();

print <<EOF;
   </body>
   </html>
EOF

