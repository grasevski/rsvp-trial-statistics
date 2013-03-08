rsvp-trial-statistics
=====================

Trial 2 sql scripts


Synopsis
--------
This repository consists of 2 main scripts `rsvpTrialStatistics.sh` (for POSIX) and `rsvpTrialStatistics.bat` (for Windows), as well as some auxiliary files and helper programs written in Java. The purpose of `rsvpTrialStatistics.sh` is to gather statistics about the events and interactions between users which occurred during the trial period from the Oracle serve and output them to a set of text files.


Description
-----------
This is the basic procedure followed by `rsvpTrialStatistics.sh`:

1. Compile the java programs.
2. Initialize a temporary schema on Oracle.
3. Remove previous csv files.
4. Gather the results from the Oracle server.
5. Print the results to text files.


Dependencies
------------
The Oracle JDBC driver (included for your convenience) is required to run these scripts.


Installation
------------

1. Install dependencies
2. Download and extract this repository


Setup
-----
Various Oracle tables are required for these scripts to run. These are defined (along with all other parameters such as start date, end date etc) in `definitions.sql`. There are two other configurable files:

1. `tailViews.txt` - the tables/views which are queried for activity metrics
2. `scores.txt` - the tables/views which are queried for score metrics

Each of these text files consist of a list of "outputname,inputname" entries, where "inputname" is the Oracle table name and "outputname" is the output filename.


File Formats
------------
There are no specific input files used in these scripts apart from what was mentioned in setup.


Usage
-----
Once you have downloaded and extracted the repo, cd to it:

----
    cd /path/to/rsvp-text-statistics
----

Edit `tailViews.txt` and `scores.txt` to reference your Oracle tables, then run `rsvpTrialStatistics.bat` if on Windows, otherwise `rsvpTrialStatistics.sh` if on POSIX. Then once this is complete, import the resultant csv files into MS Excel. The "LST" files outputted by SQLPlus however will require manual editing before being imported into Excel.


Resources
---------
`Trial2.xlsm` may serve as an example of how to make use of the outputted text files. It contains the following key spreadsheets:

1. `Results` - summarizes the output of `trial2.sql`
2. `Summary` - summarizes the output of `summary.sql`
3. `Legend` - some notes on the specifications used for gender, interactions, etc
4. `Activity` - summarizes the output of the RsvpTailStats java program
5. `contactsData` - output of `contacts.sql`
6. `scoreData`, `scoreData_2` - output of `score.sql`
7. `impression`, `click`, `kiss`, `kiss_t`, `channel` - contains the score analysis csv data outputted by the RsvpScore java program
