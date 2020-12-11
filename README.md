# solarlog2sql

## Work in Progress

Disclaimer:  
This does not even work for me,  
so do NEVER expect that it may do anything useful for you.  
You have been warned!  


## Parsing backup-CSV files from SOLARLOG(TM) loggers

.... and throw them into a database.  
There are .js and .csv formats available.  
Data structure for months, years and days are quite straight forward.  
CSV resembles a flat normalized data structure, that can be written to db line by line.  
It's a simple PERL boilerplate I use ever and ever again.  

minute-format is a bit tricky, 
since it's not normalized.  
column structure depends on the number of inverters and of MPP per inverters.  
  
I could manage to parse the header dynamically into a proper tree object.  
In the db, there will be seperate tables for inverters and MPP.  
Next step now is the diligent job to cycle through the lines.  
  
## configuration
  
I developped and tested this on a debian 10.   

I made a wrapper script **SL-dispatcher** which I hope fits nice into the **incrontab** framework.  
So, your cernel is watching your dir, where solarlog-backups drop in, no matter where they come from.  

	:~/solarlog/scripts$ incrontab -l
	/home/solarlog/log/     IN_CLOSE_WRITE  /home/user/solarlog/scripts/SL-dispatcher.sh $@ $#

I think other wrappers, like directory scanning, crontab an whatever might fit this as well


## Motivation

In early days of photovoltaic, Solarlog(TM) was an excellent, lean, stable, relaible product
with nice features to evaluate the performance of the array, e.g. for shades, temporaryy droputs etc.  
So, on positive experience from 2009, in 2012 it was a no-brainer to go for a larger Solarlog(TM).  
  
Sadly, it was hit by a thunderbolt and replaced by an "upgraded" Version, which in my view was a huge regression bug all over.   
Slow, cumbersome, and infelxible regarding individual views.  
They still offer the old view on their cloud service, albeit at substantial periodic fee.  
I think that's a strategy commonly known as "ransomware".  
  
  
## I want my data back!!
