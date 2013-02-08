#!/bin/sh

~/java/bin/javac *.java
~/oracle/instantclient_11_2/sqlplus -s nicholasg/nGrasevski1@SMARTR510-SERV1/ORCL @init.sql
~/java/bin/java -cp "ojdbc6.jar;." RsvpScore nicholasg nGrasevski1 134 135 <queries.sql
~/java/bin/java -cp "ojdbc6.jar;." RsvpScore nicholasg nGrasevski1 0 9 <moreQueries.sql
~/oracle/instantclient_11_2/sqlplus -s nicholasg/nGrasevski1@SMARTR510-SERV1/ORCL @runQueries.sql
