#!/bin/sh

# Rsvp trial statistics

# This batch script serves as a basic use case of the scripts in
# this directory. The results schema is initialized in oracle by the
# init.sql script. The results are then extracted from the oracle
# schema and printed to text files.

~/java/bin/javac *.java
~/oracle/instantclient_11_2/sqlplus -s nicholasg/nGrasevski1@SMARTR510-SERV1/ORCL @../init.sql
rm -rf score && mkdir score
~/java/bin/java -cp "ojdbc6.jar;." RsvpScore nicholasg nGrasevski1 score <../scores.txt
~/oracle/instantclient_11_2/sqlplus -s nicholasg/nGrasevski1@SMARTR510-SERV1/ORCL @runQueries.sql
~/java/bin/java -cp "ojdbc6.jar;." RsvpTailStats nicholasg nGrasevski1 tail.csv <../tailViews.txt |tee tail.txt
