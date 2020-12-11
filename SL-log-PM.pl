#!/usr/bin/perl
## #!/usr/bin/perl -w strict

# write solarlog data into database
# by Wolfgang Rosner
#

# load credentials
require "./db_cred_writer.pli" ; 

# debug printing level 0...3
my $debug= 0 ;

die "usage: script.pl path PM.csv" if (scalar @ARGV != 2);
my ($datapath, $filename) =  @ARGV ;
my $infile = sprintf("%s/%s", $datapath , $filename ) ;

debug_print(2, sprintf ("\tprocessing PM file  %s\n", $infile)) ;



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

  # skip header line
  # Date1;Time1;Date2;Time2;Power_Perc

  next if /Date1;Time1;Date2;Time2;Power_Perc/ ;

  my @fields = split ';' ;

  debug_print (2, join '#', @fields) ;
  debug_print (2, "\n");

  unless (scalar @fields == 5 ) {
	      debug_print (3, "skipping line with wrong field number\n");
	          next;
	  }

  # my ($d1, $t1, $d2, $t2, $perc ) =(undef, undef, undef, undef, undef) ;
  # ($d1, $t1, $d2, $t2, $perc ) = @fields;

  my ($d1, $t1, $d2, $t2, $perc ) = @fields;
  my $dt1 = mysql_datetime ($d1, $t1);
  my $dt2 = mysql_datetime ($d2, $t2);


  my $sql = "REPLACE INTO `PM` (DateTime1, DateTime2, Power_perc) VALUES ( ";
  $sql .= sprintf ( " '%s' ", $dt1);
  if (defined ($dt2)) {
    $sql .= sprintf (", '%s' ", $dt2);
  } else {
    $sql .= ", (NULL) ";
  } 
  $sql .= sprintf (", '%d' ", $perc);
  $sql .= " );" ; 

  debug_print (2, "SQL-Statement: $sql \n");


  # die ("########### debug #########");
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

# mysql_datetime($date, $time)
sub mysql_datetime {
  my ($date, $time) = @_;
  return undef unless  ($date);
  return undef unless  ($time);
  my ($d, $m, $y) = split ( /\./, $date , 3) ;
  return  (sprintf ('20%s-%s-%s %s' ,  $y, $m, $d  , $time ));
}




