-- initialize and populate the temporary tables and views

@@tables.sql
@@views.sql

-- Assume the user's rule number is their userid mod 10
insert into temp_user
select userid, gender_prid, case when u is not null then 1 else 0 end
from &account_table left join (
  select distinct userid u from &impressions
  where created between &trial_start_date and &trial_end_date
) on u=userid where creationdate < &trial_end_date
  and hlastaction > trunc(&trial_start_date - &interval_days);

-- Oracle requires a sequence object to generate primary keys
create sequence s;

-- Recommendations which occurred during the trial period
insert into temp_recom
select s.nextval, u1.userid, u2.userid, score, created
from &recom_table x
join userrule u1 on u1.userid=x.userid and r=rule
join temp_user u2 on u2.userid=targetuserid
where created between &trial_start_date and &currenttime;

-- Remove temporary sequence
drop sequence s;

-- Recommendation impressions which occurred during the trial period
insert into temp_impression
select x.id, u1.userid, u2.userid, score, placement, created
from &impressions x
join userrule u1 on u1.userid=x.userid and r=rule
join temp_user u2 on u2.userid=targetuserid
where created between &trial_start_date and &currenttime;

-- Recommendation clicks which occurred during the trial period
insert into temp_click
select x.id, u1.userid, u2.userid, score, placement, created
from &clicks x
join userrule u1 on u1.userid=x.userid and r=rule
join temp_user u2 on u2.userid=targetuserid
where created between &trial_start_date and &currenttime;

-- Kisses which occured during the trial period
insert into temp_kiss
select k.id, u1.userid, u2.userid, positivereply, k.created, k.replydate
from &kiss_table k
join temp_user u1 on u1.userid=initiatinguserid
join temp_user u2 on u2.userid=targetuserid
left join &reply_table r on r.id=replymessageid
where k.created between &trial_start_date and &currenttime;

-- Channels which were opened during the trial period
insert into temp_channel
select channelid, u1.userid, u2.userid, opendate from &channel_table
join temp_user u1 on u1.userid=initiatinguserid
join temp_user u2 on u2.userid=targetuserid
where opendate between &trial_start_date and &currenttime;

commit;
