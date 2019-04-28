#!/usr/bin/perl -w strict

# write solarlog data into database
# by Wolfgang Rosner
#

# load credentials
require "./db_cred_writer.pli" ; 

# debug printing level 0...3
my $debug=3 ;

#========================================================
use DBD::mysql;		# mysql database access
my $driver = "mysql";
use Data::Dumper;	# for debug
use POSIX qw(strftime);	# time string formatting
use Switch;
# use DateTime::Format::MySQL;

my ($filename) =  @ARGV ;

debug_print(1, "\n$0 connecting as user <$user> to database <$database> at host <$DBHost>...\n");
my $dsn = "DBI:$driver:$database;$DBHost";
my $dbh = DBI->connect($dsn, $user, $passwd) 
# 		; ###### debug - not database
		|| die ("Could not connect to database: $DBI::errstr\n");
			#  || sqlerror($dbh, "", "Could not connect: $DBI::errstr\n");
debug_print(1, "\t...connected to database \n\n") ;

die "usage: script.pl filename.csv" if (scalar @ARGV != 1);
my $infile = $datapath . "/$filename" ;
open (INPUT, $infile) || die (sprintf "cannot open >%s< \n", $infile) ;


# read head line and analyze data structure of plant config
$header = <INPUT> ;
chomp $header ;
$header =~ s/\r//g ;   # looks like we have <cr><nl> DOS format?
$header =~ s/^#// ;

debug_print(3, sprintf("\nHeader line: %s \n", $header) ); 

@fieldnames = split ( ";", $header);

# my %fieldhash;
# $fieldhash{$_}++ for (@fieldnames);

debug_print(3,  Data::Dumper->Dump ([\@fieldnames]) ); 
# debug_print(3,  Data::Dumper->Dump ([\%fieldhash]) );

my $columns = scalar @fieldnames;
my $Datefield;
my $Timefield;
my @invlist;

foreach $pos (0..(scalar(@fieldnames))-1) {
  $key = $fieldnames[$pos] ;
  debug_print(3, sprintf "key : %s , \tpos: %s \n", $key , $pos );

  switch ($key) {
    case "Date" 	{ $Datefield = $pos }
    case "Time"         { $Timefield = $pos }
    case "INV"		{ push @invlist, { 'INV' => $pos } }
    else 		{    # look for mpp data - does not work with "case" 
       if ( $key =~ /(\D+)(dc)(\d+)/ ) {
         printf "\t>%s< \t>%s< \t>%s< \n",$1, $2, $3   ;
	 $invlist[-1]{'MPP'}[$3]{ $1.$2 } = $pos ;
       } else { 	       
         $invlist[-1]{$key} = $pos   ;
       }
    }

  }

}

debug_print(3,  Data::Dumper->Dump ([ $Datefield, $Timefield , $columns , \@invlist ]) );

# Header done, now process data lines

while(<INPUT>) {
  chomp;
  s/\r//g ; # looks like we have <cr><nl> DOS format?

  unless ($_) {
	      debug_print (3, "skipping empty line\n");
	          next;
	  }

  next if /^\s*#/;             # skip comment lines


  my @fields = split ';' ;

  debug_print (2, join '#', @fields) ;
  debug_print (2, "\n");

  unless (scalar @fields == $columns ) {
	      debug_print (3, "skipping line with wrong field number\n");
	          next;
	  }

  my $date = $fields[$Datefield] ;
  my $time = $fields[$Timefield] ;
  # $dt = time();

  # my $datetime = DateTime::Format::MySQL->format_datetime($dt);
  my ($d, $m, $y) = split ( /\./, $date, 3) ;
  my $mySQLdatetime = sprintf ('20%s-%s-%s %s' ,  $y, $m, $d  , $time );


  debug_print(3, Data::Dumper->Dump ([ $date, $time , $mySQLdatetime] ) ) ;

  # can we cycle over the inverters and print theri no and number of MPP for each?

  foreach $inv (@invlist) {
    # @inflist is an array of hashes, so $inv is a POINTER to a hash
    debug_print(3, Data::Dumper->Dump ( [ $inv ] ));
    @mpplist = @{$inv->{'MPP'}};
    $nummpp = scalar(@mpplist ) -1 ;
    debug_print(3, Data::Dumper->Dump ( [ \@mpplist ] ));
    debug_print(3, sprintf("inverter no: %d, number of mppt: %d \n", $fields[$inv->{'INV'}], $nummpp )) ;
    # cycle over inv fields
    foreach my $field (keys %$inv) {
      next if $field eq 'MPP' ;
      my $content = $fields[$inv->{$field }];
      debug_print(3, sprintf("  field %s content %d \n", $field, $content ));
    }

    # cylce over mpps
    foreach my $mpp (@mpplist) {
      next unless defined ($mpp) ;
      debug_print(3, sprintf("mpp %s \n", $mpp ));
      # cycle over mpp fields
      foreach my $mppfield (keys %$mpp) {
        #next if $field eq 'MPP' ;
        my $mppcontent = $fields[$mpp->{$mppfield }];
        debug_print(3, sprintf("  field %s content %d \n", $mppfield, $mppcontent ));
      }				        
    }
  }

die "############ DEBUG EXIT ##############";
#==================================~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~----------------
#

# my ($date, $inv, $psum, $pmax) = @fields;

  my $sql = "REPLACE INTO `days` (`Date`, `Inv`, `Psum`, `Pmax`) VALUES ( ";
  $sql .= " STR_TO_DATE('" ;
  $sql .= $date; 
  $sql .= "' , '%d.%m.%y') , ";
  $sql .= sprintf ("'%d' , ",  $inv);
  $sql .= sprintf ("'%d' , ",  $psum);
  $sql .= sprintf ("'%d'",  $pmax);

  $sql .= " );" ; 

  debug_print (2, "SQL-Statement: $sql \n");

  # execute sql statement
  my  $affected = $dbh->do($sql);
  debug_print (2, "\t$affected Datasets updated\n");
}
close (INPUT);
$dbh->disconnect ;
exit ;

#============================================
# debug_print($level, $content)
sub debug_print {
  $level = shift @_;
  print STDERR @_ if ( $level <= $debug) ;
}


