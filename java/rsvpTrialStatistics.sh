#!/bin/sh

~/java/bin/javac *.java
~/oracle/instantclient_11_2/sqlplus -s nicholasg/nGrasevski1@SMARTR510-SERV1/ORCL @../init.sql
rm -rf score && mkdir score
~/java/bin/java -cp "ojdbc6.jar;." RsvpScore nicholasg nGrasevski1 score <queries.sql
~/oracle/instantclient_11_2/sqlplus -s nicholasg/nGrasevski1@SMARTR510-SERV1/ORCL @runQueries.sql
~/java/bin/java -cp "ojdbc6.jar;." RsvpTailStats nicholasg nGrasevski1 <../tailViews.txt >tail.csv
