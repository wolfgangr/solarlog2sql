#!/usr/bin/perl
## #!/usr/bin/perl -w strict

# write solarlog data into database
# by Wolfgang Rosner
#

# load credentials
require "./db_cred_writer.pli" ; 

# debug printing level 0...3
my $debug=0 ;

die "usage: script.pl path years.csv" if (scalar @ARGV != 2);
my ($datapath, $filename) =  @ARGV ;
my $infile = sprintf("%s/%s", $datapath , $filename ) ;

debug_print(2, sprintf ("\tprocessing file  %s\n", $infile)) ;



#========================================================
use DBD::mysql;		# mysql database access
my $driver = "mysql";
use Data::Dumper;	# for debug
use POSIX qw(strftime);	# time string formatting


debug_print(1, "\n$0 connecting as user <$user> to database <$database> at host <$DBHost>...\n");
my $dsn = "DBI:$driver:$database;$DBHost";
my $dbh = DBI->connect($dsn, $user, $passwd) 
# 		; ###### debug - not database
		|| die ("Could not connect to database: $DBI::errstr\n");
			#  || sqlerror($dbh, "", "Could not connect: $DBI::errstr\n");
debug_print(1, "\t...connected to database \n\n") ;

	
open (INPUT, $infile) || die (sprintf "cannot open >%s< \n", $infile) ;

while(<INPUT>) {
  chomp;
  unless ($_) {
	      debug_print (3, "skipping empty line\n");
	          next;
	  }

  next if /^\s*#/;             # skip comment lines

  my @fields = split ';' ;

  debug_print (2, join '#', @fields) ;
  debug_print (2, "\n");

  unless (scalar @fields == 3 ) {
	      debug_print (3, "skipping line with wrong field number\n");
	          next;
	  }

  my ($date, $inv, $psum) = @fields;

  my $sql = "REPLACE INTO `years` (`Date`, `Inv`, `Psum`) VALUES ( ";
  $sql .= " STR_TO_DATE('" ;
  $sql .= $date; 
  $sql .= "' , '%d.%m.%y') , ";
  $sql .= sprintf ("'%d' , ",  $inv);
  $sql .= sprintf ("'%d'",  $psum);
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


