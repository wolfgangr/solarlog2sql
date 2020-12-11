#!/usr/bin/perl
## #!/usr/bin/perl -w strict

# write solarlog data into database
# by Wolfgang Rosner
#

# load credentials
require "./db_cred_writer.pli" ; 

# debug printing level 0...3
my $debug= 0 ;

die "usage: script.pl path events.js" if (scalar @ARGV != 2);
my ($datapath, $filename) =  @ARGV ;
my $infile = sprintf("%s/%s", $datapath , $filename ) ;

debug_print(2, sprintf ("\tprocessing event file  %s\n", $infile)) ;



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

  # next if /^\s*#/;             # skip comment lines

  # skip header line
  # Date1;Time1;Date2;Time2;Power_Perc

  # next if /Date1;Time1;Date2;Time2;Power_Perc/ ;

  # next unles /^\se\[ev\+\+\]=\"(

  my @fields = split /"|;/ ;

  debug_print (2, join '#', @fields) ;
  debug_print (2, "\n");

  my ($evpp, $dt1raw, $dt2raw, $inv, $stat, $err, $trail) = @fields;
  next unless $evpp eq "e[ev++]=" ;
  next unless $trail eq "\r" ;
  next unless defined ($err);
  next unless (scalar @fields == 7 );
  ##### die ("#### debug ####");



  # my ($d1, $t1, $d2, $t2, $perc ) = @fields;
  my $dt1 = mysql_datetime ($dt1raw);
  my $dt2 = mysql_datetime ($dt2raw);


  my $sql = "REPLACE INTO `events` (DateTime1, DateTime2, Inv, status, err ) VALUES ( ";
  $sql .= sprintf ( " '%s' ", $dt1);
  if (defined ($dt2)) {
    $sql .= sprintf (", '%s' ", $dt2);
  } else {
    $sql .= ", (NULL) ";
  } 
  $sql .= sprintf (", '%d' ", $inv);
  $sql .= sprintf (", '%d' ", $stat);
  $sql .= sprintf (", '%d' ", $err);
  $sql .= " );" ; 

  debug_print (2, "SQL-Statement: $sql \n");


  #### die ("########### debug #########");
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
  # my ($date, $time) = @_;
  my ($d, $m, $y , $time ) = split ( /\.|\ /, $_[0] , 4) ;
  # return undef unless  ($date);
  return undef unless  ($time);
  # my ($d, $m, $y) = split ( /\./, $date , 3) ;
  return  (sprintf ('20%s-%s-%s %s' ,  $y, $m, $d  , $time ));
}




