#!/usr/bin/perl -T

use warnings;
use strict;

#
# Setup Pearl CGI
#
use lib "/fnmoc/u/curr/lib/perllib";
use CGI qw(:standard escapeHTML);
use lib "../lib";
use sys_info qw(getDevLevel getHostClass);
use web_routines qw(getClasBnr getClas);

$ENV{'PATH'} = '/usr/bin';
delete @ENV{'IFS', 'CDPATH', 'BASH_ENV'};

#
# Setup object-oriented CGI
#
#my $q = CGI->new();

#============================= Begin main script ===============================

my ($dir,$data_type, $csgn, $dtg, $uniq_num);
my ($year, $month, $day, $hour, $minute, $second);
my (@data_type_list);
my (@field_array);
my (@field_array_tmp);
my (@csgn_sort, $csgn_sort_cnt);
my (@csgn_cnt);
my (@csgn_cnt_1_7);
my (@csgn_cnt_8_14);
my ( $k, $l, $m );
my ($sec, $min, $hr, $mday, $mon, $yr, $wday, $yday, $dlight);
my ($time);
my (@date);
my (@md);
my ($date_ob);
my ($string, $line, $line2, $tline);
my (@clas_list);
my ($clas_list_cnt);
my ($line_ok);
my ($line2_ok);
my ($clas_ok);
my ($file_name);
my ($section);
my ($section_2);
my ($section_ok);
my ($section_2_ok);
my ($date_rd);
my ($time_rd);
my ($ship_name);
my ($title);
my (%ship_name_hash);
my ($clas_banner);
my ($date_14);
my ($data_type_list_cnt);
my ($dir_clas);
my ($CLAS);
my ($file);
my ($tfile);
my ($td_cnt);
my (@field_array_cnt);
my ($field_array_cnt_total);
my (@ob_list);
my (@ob_type_list);
my ($data_type_cnt);
my (@sub_line_array);
my ($sub_line);
my (@split_array);
my ($split_array_cnt);
my (%field_hash);
my ($field_id);
my (@field_id_array);
my (@date_rd_array);
my ($random_number);
my ($temp_value);
my $shp_ref_lib = "/fnmoc/u/curr/etc/static/app/msl/navy_shp_ref_lib";

$file = "../html/data_display_short.html_template";
$file = escapeHTML("$file");
open( my $FILE, "<", $file ) or die " Can't open $file: $!";
printf ("%s\n\n", "Content-type: text/html");

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
    $line = "$clas_banner\n";
  }

  #
  # setup insert lines
  #
  if(index($line,"#INSERT#") >=0)
  {
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
                       "tesac","lnd_mo_sfc","lnd_mo_raob","lnd_mo_taf","xbt","bufr");
    $data_type_list_cnt = @data_type_list;

    #
    # Create ob list
    #
    @ob_list =      (["ship_sfc","ship_sfc_form"],["ship_raob"],["ship_mo_taf"],["bathy","bathy_form","bathy_csv"],
                     ["tesac"],["lnd_mo_sfc"],["lnd_mo_raob"],["lnd_mo_taf"],["xbt"],["bufr"]);
    @ob_type_list = ("sfc ship (BBXX)","ship raob (UUAA)","ship mobile taf (MOBTAFQ)","bathy (JJVV)","tesac (KKYY)",
                     "mobile sfc land (OOXX)","mobile raob land (UUII)","land mobile taf (MOBTAFQ)","acft bathy (XBT)","bufr");

    #
    # Identify archive directory
    #
    $dir="../dynamic/archive";

    #================================================================================================
    # Get call sign list and field arrays
    #
    # Cycle through classifications
    #
    my (@final, %hash) = ((), ());
    (@field_array) = (());
    for ($l = 0; $l < $clas_list_cnt; $l++)
    {
      $dir_clas = "$dir/$clas_list[$l]";
      $CLAS = $clas_list[$l];
      $CLAS =~ tr/a-z/A-Z/;

      #
      # Read archived encoded file names.
      #
      (@field_array_tmp) = (());
      opendir(DIR, $dir_clas) or die "can't open directory: $dir_clas";
      while (defined($file = readdir(DIR)))
      {
        if( $file =~ /^\./ ){ next; }

        if( $file =~ /^raw_/ )
        {
            # In order to spoof the code to think this is a ship
            # we need to open the xbt file to extract a "ship_name"
            # and add it to the ship_name_hash
            if( $file =~ /xbt/ )
            {
                my $file_size = -s "$dir_clas/$file";
                my @file_name_arr = split( /\./, $file );
                my $flight_id = $file_name_arr[1];
                eval{ open( FH, "< $dir_clas/$file" ) or die };
                if( $@ )
                {
                    print "file = '$dir_clas/$file' failed to open\n$!\n\n";
                }
                read( FH, my $bufr, $file_size );
                close( FH );
                my @file_arr = split( "\n", $bufr );
                my @line_arr = grep /ship_name/, @file_arr;
                my( $x, @name_arr ) = split( " ", $line_arr[0] );
                my $stn_name = join( " ", @name_arr );

                $ship_name_hash{$flight_id} = $stn_name;

            } # End if xbt

          $file =~ s/^raw_//;

          # Split out data type, call sign/station name, dtg and unique number
          # from file name.
          #
          ($data_type, $csgn, $dtg, $uniq_num) = split(/\./,$file);
          ($year, $month, $day, $hour, $minute, $second) = ($dtg =~ /^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/);
          $date_ob = join("",$year, $month, $day);

          if($date_ob ge $date_14)
          {
            push(@field_array_tmp, $file);

            $field_id=join("",$dtg, $uniq_num);
            $field_hash{$field_id}=$file;
          }
          #
          # remove duplicate names and create name list with clasification
          #
          if (not exists $hash{$csgn})
          {
            push @final, $csgn;
            $hash{$csgn} = 1;
          }
        }
      } # cycled through files
      close(DIR);

      #
      # Sort clasification directories
      #

      @field_array_tmp = sort(@field_array_tmp);
      $field_array_cnt[$l] = @field_array_tmp;
      push @field_array, [@field_array_tmp];

    } # End for $l cycled through classifications


    # Sort call signs
    #
    @csgn_sort = sort(@final);
    $csgn_sort_cnt = @final;

    #================================================================================================

    printf ("%s", "<table style='width:100%; border:10px ridge black'>\n");
    printf ("%s", "<tr  style='vertical-align:top'>\n");

    #
    # Cycle through names
    #
    $td_cnt = 1;
    for ($k = 0; $k < $csgn_sort_cnt; $k++)
    {
      $csgn = $csgn_sort[$k];
      if(defined $ship_name_hash{$csgn})
      {
        $ship_name = $ship_name_hash{$csgn};
      }
      else
      {
        $ship_name = "UNKNOWN";
      }

      $section = "<td style='text-align:center; padding:10px; border:1px solid black'>\n";
      $section = join("", $section, "<b>$csgn ($ship_name)</b>\n");
      $section = join("", $section, "<table style='margin:auto; text-align:center;'><tr>\n");


      #
      # Cycle through data types
      #

      $section_ok = 0;
      $data_type_cnt = 1;
      for my $ii ( 0 .. $#ob_type_list ) 
      {
        if($data_type_cnt == 1 || $data_type_cnt == 4 || $data_type_cnt == 7)
        {
          $line = "<td style='white-space:nowrap'>\n<br><b>$ob_type_list[$ii]</b>\n";
        }
        else
        {
          $line = "<br><br><b>$ob_type_list[$ii]</b>\n";
        }
        #
        # Cycle through classifications
        #
        $clas_ok = "0";
        for( $l = 0; $l < $clas_list_cnt; $l++ )
        {
          $dir_clas = "$dir/$clas_list[$l]";
          $CLAS = $clas_list[$l];
          $CLAS =~ tr/a-z/A-Z/;

          #
          # Cycle through fields
          #
          if ($CLAS eq "UNCLAS")
          {
          $line2 = "<br><span style='color:#00ff00'>U</span>";
          }
          elsif ($CLAS eq "CONFID")
          {
          $line2 = "<br><span style='color:#0000ff'>C</span>";
          }
          elsif ($CLAS eq "SECRET" )
          {
          $line2 = "<br><span style='color:#ff0000'>S</span>";
          }
          $random_number = int(rand 10000) + 1;
          $temp_value = "\"file_t_$random_number\"";
          $line2 = join(' ',$line2,  "<select tabindex='1' class='ob' name='file_t_$random_number' id='file_t_$random_number'  onblur='submit_values(this.value,$temp_value);'>\n");

          #
          # Form drop-down listing of observations
          #
          $line2_ok = "0";
          (@sub_line_array) = (());
          (@date_rd_array) = (());
          (@field_id_array) = (());
          for( my $i = $field_array_cnt[$l]-1; $i >= 0; $i-- )
          {
#           (@field_id_array) = (());

            for my $j ( 0 .. $#{$ob_list[$ii]} )
            {
              @split_array = split(/\./,$field_array[$l][$i]);
              $split_array_cnt = @split_array;
              ($data_type, $csgn, $dtg, $uniq_num) = split(/\./,$field_array[$l][$i]);
              $field_id=join("",$dtg, $uniq_num);
              ($year, $month, $day, $hour, $minute, $second) = ($dtg =~ /^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/);
              $date_ob = join("",$year, $month, $day);
              $date_rd = sprintf("%02d/%02d/%04d %02d%02dZ", $month, $day, $year, $hour, $minute);
              #
              #    Find the observations
              #
              if($data_type eq $ob_list[$ii][$j] && $csgn_sort[$k] eq $csgn)
              {
                if($date_ob ge $date_14)
                {
                  push(@date_rd_array, $date_rd);
                  push(@field_id_array, $field_id);

                  $line2_ok = "1";
                }
              }
            } # ob type names
          } # file names - $line2_ok

          #
          # do sorting here
          #
          if ( $line2_ok == 1 )
          {
            $clas_ok = "1";
            @field_id_array=sort {$b <=> $a} (@field_id_array);
            @date_rd_array=sort {$b cmp $a} (@date_rd_array);

            for my $i ( 0 .. $#field_id_array )
            {
              $line2 = join('',$line2, "<option value='$clas_list[$l]/#DATA_FORM#_$field_hash{$field_id_array[$i]}'>$date_rd_array[$i]</option>\n");
            }
          }


          if ( $line2_ok == 1 )
          {
            $line = join('', $line, "$line2\n");
            $line = join('', $line, "</select>\n");
          }


        }  # clas_list - $class_ok

        if($clas_ok eq "1")
        {
          $data_type_cnt++;

          if($data_type_cnt == 1 || $data_type_cnt == 4 || $data_type_cnt == 7)
          {
            $line = join("", $line, "</td>\n");
          }
          $section_ok = "1";
          $section = join("", $section, $line);
        }
      } # ob_type - $section_ok

      $line = "</td></tr></table>\n";
      $section = join("", $section, $line);
      if($section_ok eq "1")
      {
        printf ("%s", "$section");
        printf ("%s", "</td>");
        $td_cnt++;
      }
      if($section_ok eq "1" && $td_cnt > 5)
      {
        printf ("%s", "</tr>");
        printf ("%s", "<tr>");
        $td_cnt = 1;
      }

    } # call sign and ship name
    printf ("%s", "<td>");
    printf ("%s", "</table>");

  }
  else
  {
    printf ("%s", "$line");
  }

}
close( $FILE );

