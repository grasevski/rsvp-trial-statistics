-- initialize and populate the temporary tables and views

@@tables.sql;
@@views.sql;

-- Assume the user's rule number is their userid mod 10
insert into temp_user
select userid, gender_prid, mod(userid, 10), case when u is not null then 1 else 0 end
from &account_table left join (
  select distinct userid u from &impressions
  where created between &trial_start_date and &trial_end_date
) on u=userid where creationdate < &trial_end_date
  and hlastaction > trunc(&trial_start_date - &interval_days);

-- Only target userid and rule are important for the calculations
insert into temp_impression
select distinct targetuserid, rule from &impressions
where created between &trial_start_date and &trial_end_date;

-- Recommendation clicks which occured during the trial period
insert into temp_click
select id, u1.userid, u2.userid, created from &clicks c
join temp_user u1 on u1.userid=c.userid
join temp_user u2 on u2.userid=targetuserid
where created between &trial_start_date and &currenttime;

-- Kisses which occured during the trial period
insert into temp_kiss
select k.id, initiatinguserid, targetuserid, case when positivereply = 1 then 1 else 0 end, k.created
from &kiss_table k left join &reply_table r on r.id=replymessageid
join temp_user u1 on u1.userid=initiatinguserid
join temp_user u2 on u2.userid=targetuserid
where k.created between &trial_start_date and &currenttime;
