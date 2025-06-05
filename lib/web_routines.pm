#!/usr/bin/perl -w

package web_routines;

use warnings;
use strict;
use lib qw(/fnmoc/web/webservices/apache/app/common/lib);
use POSIX qw( uname );
use Exporter;
our @ISA=qw(Exporter);
our @EXPORT_OK = qw(printClasBnr getClasBnr getClas);
our $traindir = "j-obs_training";

sub printClasBnr
{
  use lib "/fnmoc/u/curr/lib/perllib";
  use CGI;

  use sys_info qw(getDevLevel getHostClass getAppName);

  #
  # print clasiification bar
  #
  if( getAppName() eq $traindir )
  {
    if( getDevLevel() eq "alpha" )
    {
      print "<div class='training-bnr'>TRAINING --- ALPHA</div>";
    }
    elsif( getDevLevel() eq "beta" )
    {
      print "<div class='training-bnr'>TRAINING --- BETA</div>";
    }
    else
    {
      print "<div class='training-bnr'>TRAINING</div>";
    }
  }
  elsif( getHostClass() eq "unclas" )
  {
    if( getDevLevel() eq "alpha" )
    {
      print "<div class='sec-unclass-bnr'>UNCLASSIFIED --- ALPHA</div>";
    }
    elsif( getDevLevel() eq "beta" )
    {
      print "<div class='sec-unclass-bnr'>UNCLASSIFIED -- BETA</div>";
    }
    else
    {
      print "<div class='sec-unclass-bnr'>UNCLASSIFIED</div>";
    }
  }
  elsif( getHostClass() eq "secret" )
  {
    if( getDevLevel() eq "alpha" )
    {
      print "<div class='sec-secret-bnr'>SECRET --- ALPHA</div>";
    }
    elsif( getDevLevel() eq "beta" )
    {
      print "<div class='sec-secret-bnr'>SECRET --- BETA</div>";
    }
    else
    {
      print "<div class='sec-secret-bnr'>SECRET</div>";
    }
  }

  return();

}#End printClasBnr()

sub getClasBnr
{
  use lib "/fnmoc/u/curr/lib/perllib";
  use CGI;

  use sys_info qw(getDevLevel getHostClass getAppName);

  my $clasbanner;
  #
  # set clasiification bar
  #
  if( getAppName() eq $traindir )
  {
    if( getDevLevel() eq "alpha" )
    {
      $clasbanner = "<div class='training-bnr'>TRAINING --- ALPHA</div>";
    }
    elsif( getDevLevel() eq "beta" )
    {
      $clasbanner = "<div class='training-bnr'>TRAINING --- BETA</div>";
    }
    else
    {
      $clasbanner = "<div class='training-bnr'>TRAINING</div>";
    }
  }
  elsif( getHostClass() eq "unclas" )
  {
    if( getDevLevel() eq "alpha" )
    {
      $clasbanner = "<div class='sec-unclass-bnr'>UNCLASSIFIED --- ALPHA</div>";
    }
    elsif( getDevLevel() eq "beta" )
    {
      $clasbanner = "<div class='sec-unclass-bnr'>UNCLASSIFIED --- BETA</div>";
    }
    else
    {
      $clasbanner = "<div class='sec-unclass-bnr'>UNCLASSIFIED</div>";
    }
  }
  elsif( getHostClass() eq "secret" )
  {
    if( getDevLevel() eq "alpha" )
    {
      $clasbanner = "<div class='sec-secret-bnr'>SECRET --- ALPHA</div>";
    }
    elsif( getDevLevel() eq "beta" )
    {
      $clasbanner = "<div class='sec-secret-bnr'>SECRET --- BETA</div>";
    }
    else
    {
      $clasbanner = "<div class='sec-secret-bnr'>SECRET</div>";
    }
  }

  return $clasbanner;

}#End getClasBnr()

sub getClas
{
  use lib "/fnmoc/u/curr/lib/perllib";
  use CGI;

  use sys_info qw(getDevLevel getHostClass getAppName);

  my $clas;
  #
  # set clasiification
  #
  if( getAppName() eq $traindir )
  {
    $clas = "training";
  }
  elsif( getHostClass() eq "unclas" )
  {
    $clas = "unclas";
  }
  elsif( getHostClass() eq "secret" )
  {
    $clas = "secret";
  }

  return $clas;

}#End getClas()

1;
