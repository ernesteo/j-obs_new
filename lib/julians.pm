#!/usr/bin/perl -w

package Julians;

use warnings;
use strict;

########################################################################
#
#  date related constants
#

my @OrdinalDates = ( 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365,
                     0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366 );
                     ### note: 13 entries per-year: last entry is days in year
                     ###       (see &LeapYear return value)

my ($Jan,$Day1) = (0, 1);       #first day of month, first month of year
                                ##  $Jan  = 0 if Jan is 0, 1 if Jan is 1
                                ##  $Day1 = 0 if first day of month is 0, else 1
                                # NOTE: a value of "0" for $Jan matches C's 
                                # ##"struct tm" structure and perls internal 
                                # ##localtime()/gmtime() functions.
                                # ##A value of 1 matches what normal people expect.
                                # ##Where possible it is suggested that these
                                # ##values remain at (0, 1) as this matches
                                # ##what programmers expect.

my $JanYr0 = 1721059;   #Julian Day for Jan 1, 1BC (year "0000")
my $ODO = 2;            #offset to get modern day of week from Julian Day
                        ##(always positive so we never get negative Julian Days)

### limits for use by the &check functions
my $YearMin = 0;        #minimum year 
my $YearMax = 9999;     #maximum year

### &iso_8601 definitions
my @Locale = ( 2, 0, 1 );  #typical order of date information in local locale
                           ##(array of 3 values: [0] gives years offset,
                           ##[1] gives month's offset, and [2] gives days offset.
my $Pivot = 1968;          #piviot year (as full four-digit year)
my $Pivot2 = $Pivot % 100; #pivot year as two-digit year
# $Century = int( ( localtime )[5] / 100 ) * 100 + 1900;        #current century

my $LeapYearSw;



########################################################################
#
#   CheckOrdinal -- verify Ordinal (Julian) date is correct
#       # &CheckOrdinal( yyyy, jjj );
#       # the various Julians functions are not defined for invalid dates.
#         this function provides a way to check that dates are valid.
#       # scalar context: 
#           # returns undef if non-numeric values encountered.
#           # returns 0 if invalid numeric date value.
#           # returns 1 on success.
#       # array context:
#           # returns undef if non-numeric values encountered.
#           # returns () if invalid numeric date value.
#           # returns ( yyyy, jjj0 ) on success (jjj0 is day where 
#             0 is 1st day of year: these style dates are often used 
#             internally by the Julians package).
#
sub CheckOrdinal
{
    my ( $year, $jjj ) = @_;
   
    $jjj -= $Day1;

    return() unless $year =~ /^\d+$/        #verify numeric
                     &&  $jjj =~ /^\d+$/;

    &LeapYear( $year );

    return wantarray ? () : 0 if $year < $YearMin ||  $year > $YearMax;
    return wantarray ? () : 0 if $jjj < 0  || 
                    $jjj >= $OrdinalDates[12+$LeapYearSw-1];
   
    return wantarray ? ( $year, $jjj ) : 1;

}#End CheckOrdinal


########################################################################
#
#   CheckGreg -- verify Gregorian date is correct
#       # &CheckGreg( yyyy, mm, dd );
#       # the various Julians functions are not defined for invalid dates.
#         this function provides a way to check that dates are valid.
#       # scalar context: 
#           # returns undef if non-numeric values encountered.
#           # returns 0 if invalid numeric date value.
#           # returns 1 on success.
#       # array context:
#           # returns undef if non-numeric values encountered.
#           # returns () if invalid numeric date value.
#           # returns ( yyyy, mm0, dd0 ) on success (mm0 is month, where
#               0 = Jan,  dd0 is day, where 0 is 1st day of year: these
#               style dates are often used internally by the Julians package).
#
sub CheckGreg
{
    my ( $year, $month, $day ) = @_;
   
    $month -= $Jan;
    $day -= $Day1;

    return()  unless $year  =~ /^\d+$/  && #verify numeric
                     $month =~ /^\d+$/  &&
                     $day   =~ /^\d+$/;

    return wantarray ? () : 0 if $year < $YearMin ||  $year > $YearMax;

    &LeapYear( $year );

    return wantarray ? () : 0 if $month < 0  ||  $month >= 12;
    my $mon = $month + $LeapYearSw;
    return wantarray ? () : 0 if $day < 0  || 
                    $day >= ( $OrdinalDates[$mon+1] - $OrdinalDates[$mon] - 1 );
   
    return wantarray ? ( $year, $month, $day ) : 1;

}#End CheckGreg


########################################################################
#
#   Ordinal2Julday - calculate number of days since  Sunday, Janurary 1, 4713 BC
#       # &Ordinal2Julday( yyyy, jjj );
#       # returns a very large number that provides a number that makes
#         many date calculations very easy.
#
sub Ordinal2Julday
{
    my ( $year, $jjj ) = @_;

    my $days = $year * 365;         #calc days since Jan 1, 0000, w/o leaps
    if( $year >= 1 )
    { #adjust for previous leap years
      $days += int( ($year+3) / 4 );    #add in enough days to (almost) do leaps
      $days -= int( ($year-1) / 100 );  #century years are not leap years unless
      $days += int( ($year-1) / 400 );  ##evenly divisable by 400.
    }

    $days += $JanYr0;                   #calculate Julian Day (not Julian Date!)
                                        ### (well, 1/2 day off, but who cares
                                        ###  that true Julian Days run noon
                                        ###  to noon rather than changing days
                                        ###  at midnight)

    $days += $jjj - $Day1;              #add in days into year

    return $days;
}#End Ordinal2Julday



########################################################################
#
#   Greg2Julday - calculate number of days since Sunday, Janurary 1, 4713 BC
#       # &Greg2Julday( yyyy, mm, dd );
#       # returns Julian Day number.
#       # see &Ordinal2Julday for additional comments and notes.
#
sub Greg2Julday
{
    my @julian = &Greg2Ordinal( @_ );       #get julian date (array)
    return &Ordinal2Julday( @julian );  #return Julian Day

}#End Greg2Julday



########################################################################
#
#   Julday2Ordinal - return Ordinal date for corresponding Julian Day.
#       # &Julday2Greg( julday );
#       # See &Greg2Julday for restrictions, notes, etc.
#
sub Julday2Ordinal
{
    my ( $julday ) = @_;
    my ( $year, $jjj );

    $julday -= $JanYr0;         #adjust for Jan 1, year "0000" (1BC).
    $year = int( $julday / 365.2425 );  #get first guess for year
    &LeapYear( $year );         #test its leapness
    my ( $guess ) = &Ordinal2Julday( $year, $Day1 ); #test the guess
    while(1)            #refine the guess (expect no more than 1 correction)
    {   #check if correction needed
        $jjj = $julday - $guess + $JanYr0;      #get ordinal day in guess year
        if ( $jjj < 0 )
        {   #guess actually in NEXT year
            $year--;                    #backup up a year
            &LeapYear( $year ); #set new leapness
            $guess -= $OrdinalDates[12+$LeapYearSw-1];  #backup into this year
            next;                       #test new year
        }
        if ( $jjj >= $OrdinalDates[12+$LeapYearSw-1] )
        {   #guess got PREVIOUS year
            $guess += $OrdinalDates[12+$LeapYearSw-1];  #advance to next year
            $year++;                    #get year's number
            &LeapYear( $year ); #leap into next year
            next;                       #test new year
        }
        last;
    }

    $jjj += $Day1;

    return wantarray ? ( $year, $jjj ) : $jjj;

}#End Julday2Ordinal


########################################################################
#
#   Julday2Greg - return year, month, day for corresponding Julian Day.
#       # &Julday2Greg( yyyy, mm, dd );
#       # Given a Julian Day (see &Greg2Julday), return the corresponding
#         year, month, and day.
#       # See &Greg2Julday for restrictions, notes, etc.
#
sub Julday2Greg
{
    return &Ordinal2Greg( &Julday2Ordinal( @_ ) );

}#End Julday2Greg



########################################################################
#
#   LeapYear = set leap year
#       # &LeapYear( year );
#       # Returns 0 if not leap year or [sic] 13 on leap years. 
#         This provides a useful index into the @OrdinalDates array.
#       # Leaves the internal variable $LeapYearSw set to the return value.
#         This variable should only be used within the Julians library.
#
sub LeapYear
{
    my ($year) = @_;
    return $LeapYearSw = ( !($year%4)  &&  ( $year%100  ||  !($year%400) ) )
                                ? 13 : 0;
}#End LeapYear



########################################################################
#
#   iso_8601 - convert various representations into ISO-8601 Gregorian date
#       # &iso_8601( localtime );
#       # &iso_8601( month, day, year [, 2, 0, 1, pivot ] );
#       # &iso_8601( day, month, year, 2, 1, 0 [, pivot ] );
#       # &iso_8601( year, day, month, 0, 2, 1 [, pivot ] );
#       # &iso_8601( string [, @locale [, pivot ] ] );   UNIMPLEMENTED
#                  THIS FUNCTION NOT YET SUPPORTED......................
#
sub iso_8601
{
    my ( @args ) = @_;          #copy to local value we can safely alter
    my ( $year, $month, $day, $pivot, $year2 );
    if( @args == 9 )
    {   #9-element array in the format of localtime/gmtime.
        ( $year, $month, $day ) = @args[5,4,3];         #extract the good stuff
        $year += 1900;          #set true year
        $month += $Jan;         #adjust month value to match our own
        $day += $Day1 - 1;      #ensure relative to proper starting day
    }
    elsif( @args == 3  ||  @args >= 6 )
    {   #numeric years
        my ( @locale ) = splice( @args, 3, 3 ); #look for the locale
        @locale = @Locale unless @locale == 3;  #set default if not in arg
        ( $year, $month, $day ) = @args[ @locale ];     #extract digits
        $year2 = length( $year ) < 4;
        $pivot = $args[3];
    }
    elsif( @args == 1  ||  @args == 4  ||  @args == 5 )
    {   #parsing a string
        return();
    }
    else
    {   #invalid arguments!
        return();
    }

    if( ( $year2  ||  $year < 0 )  &&  defined $Pivot )
    {   #not a four digit year: expand 2/3 digit year into four-digit year
        $pivot = $Pivot2 unless defined $pivot; #ensure we have pivot year

        if( $year < $pivot  &&  $year >= 0 )
        {   #year is in 20'th century
            $year += 100;
        }

        if( $year < 1900 )
        {   #bias year appropriately
            $year += 1900;
        }
    }

    return( $year, $month, $day );

}#End iso_8601




########################################################################
#
#   Greg2Ordinal - calculate number of days into a year 
#       # &Greg2Ordinal( yyyy, mm, dd );
#       # scalar context: returns Ordinal day number (jjj).
#       # array context: returns ( yyyy, jjj )
#       # leaves Julians'LeapYearSw set to 0 on normal years or
#         13 on leap years (useful index into @OrdinalDates).
#       # Given a date (using four-digit years), returns 0 to 364 
#         (365 on leap years)).
#       # Valid for all dates using the current Gegorian system
#         (i.e., after 1582/1752, etc.). Y2K Compliant.
#       # If you want to be independent of the the values of $Day1,
#         you typically will add $Day1 to the return value.
#
sub Greg2Ordinal
{
    my ( $year, $month, $day ) = @_;
  
    &LeapYear( $year );

    $month -= $Jan;             #allow for bias

    $day += $OrdinalDates[$month-1+$LeapYearSw];

    return wantarray ? ( $year, $day ) : $day;

}#End Greg2Ordinal



########################################################################
#
#   Ordinal2Greg - convert Ordinal date into Gregorian date
#       # &Ordinal2Greg( yyyy, jjj );
#       # Given a Ordinal date convert into into a traditional date.
#       # See all notes, etc., on &Greg2Ordinal.
#
sub Ordinal2Greg
{
    my ( $year, $jjj ) = @_;
    my $month;
   
    &LeapYear( $year );

    # calculate the month and day
    $jjj  -= $Day1;             #ensure day value biased at 0

    $month = int( $jjj / 31 );          #approximate month (may be 1 too small)
    $month++                            #adjust, if needed, for exact month
        if $jjj >= $OrdinalDates[$month+$LeapYearSw];

    $jjj -= $OrdinalDates[$month - 1 + $LeapYearSw];    #day in month

    # return appropriate value
    return( $year, $month + $Jan, $jjj + $Day1 );

}#End Ordinal2Greg



########################################################################
#
#   WeekdayJulday - return the day of the week for a particular date
#       # &WeekdayJulday( julday );
#       # Returns 0 for Sun, 6 for Sat.
#       # See &Ordinal2Julday for all restrictions and additional comments.
#
sub WeekdayJulday 
{
    return( @_ + $ODO ) % 7;

}#End WeekdayJulday


########################################################################
#
#   WeekdayOrdinal - return the day of the week for a particular date
#       # &WeekdayOrdinal( yyyy, jjj );
#       # Returns 0 for Sun, 6 for Sat.
#       # See &Ordinal2Julday for all restrictions and additional comments.
#       # NOTE: (julday+$Julians'ODO) % 7 provides answer.
#
sub WeekdayOrdinal 
{
    return ( &Ordinal2Julday( @_ ) + $ODO ) % 7;

}#End WeekdayOrdinal



########################################################################
#
#   WeekdayGregorian - return the day of the week for a particular date
#       # &WeekdayGregorian( yyyy, mm, dd );
#       # Returns 0 for Sun, 6 for Sat.
#       # See &Ordinal2Julday for all restrictions and additional comments.
#       # NOTE: (julday+$Julians'ODO) % 7 provides answer.
#
sub WeekdayGregorian 
{
    return ( &Greg2Julday( @_ ) + $ODO ) % 7;

}#End WeekdayGregorian

1;

#..................START EPILOGUE......................................
#
#
#  PROGRAM NAME: julians.pm
#
#  DESCRIPTION: This Pearl module contains Julian day library
#               Used to convert between julian day/gregorian/ordinal dates
#
#  FUNCTION NAMES: CheckOrdinal CheckGreg Ordinal2Julday Greg2Julday
#                  Julday2Ordinal Julday2Greg LeapYear iso_8601
#                  Greg2Ordinal Ordinal2Greg WeekdayJulday WeekdayOrdinal
#                  WeekdayGregorian 
#
#  DEVELOPER: Cary McGregor
#
#  REFERENCES: none
#
#  CLASSIFICATION: unclassified
#
#  RESTRICTIONS: none
#
#  COMPUTER/OPERATING SYSTEM :linux
#
#  OPERATIONAL LIBRARIES OF RESIDENCE: none
#
#  USAGE:
#
#
#  PARAMETERS: none
#
#  RETURN CODE:
#
#  DATA BASES: none
#
#  NON-FILE INPUT/OUTPUT: none
#
#  ERROR CONDITIONS: none
#
#
#  ADDITIONAL COMMENTS:
#
#
# ..................MAINTENANCE SECTION.................................
#
#  MAINTAINER: Cary McGregor
#
#  RECORD OF CHANGES:
#  version  CCP   resaon
#  1.0.1          Initial version
#
# ....................END EPILOGUE......................................
