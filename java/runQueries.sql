-- Run trial statistics queries
spool unittest
@@unittest.sql
spool trial2Verification
@@trial2Verification.sql
spool summary
@@../summary.sql
spool score
@@../score.sql
spool contacts
@@../contacts.sql
spool trial2
@@../trial2.sql
quit
