#!/usr/bin/perl -w

package sys_info;

use warnings;
use strict;
use lib qw(/fnmoc/web/webservices/apache/app/common/lib);
use POSIX qw( uname cuserid );
use Exporter;
our @ISA=qw(Exporter);
our @EXPORT_OK = qw(getDevLevel getHostClass getAppName);

sub getAppName
{
  my $script_name = $ENV{SCRIPT_NAME};
  $script_name =~tr/\// /;
  my @script_name_parts = split(" ",$script_name);
  return $script_name_parts[0];
}

sub getHostName
{
   my $nam = (uname)[1];
   $nam =~ s/^([a-zA-Z0-9-]+)(.*)/$1/;
   return $nam;
}

#-- Determine development level of host
#    ATOS2 = asd1uc#, bsb1u, dso1s
#    Emerald, Ruby = a4ou-a001 (emerald, ops, unclass, -, app node)
#                    a4bs-d001 (emerald, beta, secret, -, data node)
#                    a4au-n001 (emerald, dev, unclass, -, compute[batch] node)
#                    a1au-n001 (emerald, dev, unclass, -, compute[batch] node)

sub getDevLevel
{
   my $level = (defined $ENV{DEV}) ? $ENV{DEV} : undef;
   
   if( ! defined $level )
   { 
   	my $localHost = getHostName();
   	my $flag = substr( $localHost, 2, 1 );

   	if( $flag eq 'd' || $flag eq 'a' )
   	{
      		$level = "alpha";
   	}
   	elsif ( $flag eq 'b' )
   	{
      		$level = "beta";
   	}
   	elsif ( $flag eq 'o' )
   	{
      		$level = "ops";
   	}
   	elsif ( $flag eq 'p' )
   	{
      		$level = "prealpha";   # pre-alpha
   	}
   }
   return( $level );
}

sub getHostClass
{
   my $class;
   my $localHost = getHostName(); #-- check for which ATOS2 host level
   my $flag = substr( $localHost, 3,1 );
   if ( $flag eq 'u' )
   {
      $class = "unclas";
   }
   #   elsif( $flag eq 'c' )
   #{
   #$class = "confid";
   #}
   #elsif ( $flag eq 's' )
   else
   {
      $class = "secret";
   }
   return( $class );
}

#=============================== End Functions ===========================
1;

