-- Create temp_activity table for calculating activity and
-- popularity stats.

-- Uses kiss table and trial dates
@@definitions.sql

-- Delete if already exists
drop table temp_activity purge;

-- Activity table. Summarizes kisses into first sent, first received
-- and last sent, last received for each 28 day bracket wrt the
-- trial period. This can then be queried to determine if a user is
-- active, and it is more efficient than querying the kiss table as
-- the number of kisses has been greatly reduced.
create table temp_activity (
  activityid integer primary key,
  userid integer not null references temp_user(userid),
  sent timestamp,
  received timestamp
);

-- Kisses (can't create a view due to permissions)
def temp_k='(select initiatinguserid userid, targetuserid, k.created created from &kiss_table k join temp_user u1 on u1.userid=initiatinguserid join temp_user u2 on u2.userid=targetuserid)'

-- Oracle sequence to create the primary key
create sequence s;

-- Populate the activity table
insert into temp_activity
select s.nextval, u, s, r from (
  select nvl(x.userid, y.targetuserid) u, max(x.created) s, max(y.created) r
  from &temp_k x full join &temp_k y on y.targetuserid=x.userid
  where x.created between &trial_start_date - &interval_days and &trial_start_date
  group by nvl(x.userid, y.targetuserid)
  union
  select nvl(x.userid, y.targetuserid) u, min(x.created) s, min(y.created) r
  from &temp_k x full join &temp_k y on y.targetuserid=x.userid
  where x.created between &trial_start_date - &interval_days and &trial_start_date
  group by nvl(x.userid, y.targetuserid)
  union
  select nvl(x.userid, y.targetuserid) u, max(x.created) s, max(y.created) r
  from &temp_k x full join &temp_k y on y.targetuserid=x.userid
  where x.created between &trial_start_date and &trial_start_date + &interval_days
  group by nvl(x.userid, y.targetuserid)
  union
  select nvl(x.userid, y.targetuserid) u, min(x.created) s, min(y.created) r
  from &temp_k x full join &temp_k y on y.targetuserid=x.userid
  where x.created between &trial_start_date and &trial_start_date + &interval_days
  group by nvl(x.userid, y.targetuserid)
  union
  select nvl(x.userid, y.targetuserid) u, max(x.created) s, max(y.created) r
  from &temp_k x full join &temp_k y on y.targetuserid=x.userid
  where x.created between &trial_start_date + &interval_days and &trial_end_date
  group by nvl(x.userid, y.targetuserid)
  union
  select nvl(x.userid, y.targetuserid) u, min(x.created) s, min(y.created) r
  from &temp_k x full join &temp_k y on y.targetuserid=x.userid
  where x.created between &trial_start_date + &interval_days and &trial_end_date
  group by nvl(x.userid, y.targetuserid)
);

-- Delete the sequence
drop sequence s;

commit;
