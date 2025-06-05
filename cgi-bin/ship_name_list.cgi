#!/usr/bin/perl -T
#
# ship_name_list.cgi
#

use warnings;
use strict;

$ENV{'PATH'} = '/usr/bin';
delete @ENV{'IFS', 'CDPATH', 'BASH_ENV'};

my #variables
(  $file_nm,             $file_sz,                $bufr,
   @file_arr,            $call_sign,
   $name,                $org,                    $shp_hsh,
);

print "Content-type: text/plain\n\n";

$file_nm = "/fnmoc/u/curr/etc/static/app/msl/navy_shp_ref_lib";
$file_sz = -s $file_nm;

open( my $FH, "<", $file_nm ) or die "'$file_nm' failed to open!: $!";
read( $FH, $bufr, $file_sz );
close( $FH );

@file_arr = split( "\n", $bufr);

for my $line ( @file_arr )
{
    ( $call_sign, $name, $org ) = split( "\:", $line );

    $call_sign =~ s/\s*$//;
    $name      =~ s/\s*$//;
    $org       =~ s/\s*$//;

    $shp_hsh->{$call_sign}->{name} = $name;
    $shp_hsh->{$call_sign}->{org}  = $org;
}

sub by_name_then_call_sign
{
    $shp_hsh->{$a}->{name} cmp $shp_hsh->{$b}->{name}
      ||
    $a cmp $b
}

for my $key ( sort by_name_then_call_sign keys %{ $shp_hsh } )
{
    printf( "%-30s %-4s   %s\n", $shp_hsh->{$key}->{name}, $key, $shp_hsh->{$key}->{org} );
}
