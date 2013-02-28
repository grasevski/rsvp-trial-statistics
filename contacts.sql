@@definitions.sql

-- Number of contacts for a user (M, F) per week in evaluation
-- period, avg, median, stddev
select rule, gender, week, nvl(avg(kiss), 0) avgkiss, nvl(median(kiss), 0) medkiss, nvl(stddev(kiss), 0) stdkiss
from rg2 left join (
  select r, u1.gender g, u1.userid u, getweek(k.created) w, count(*) kiss
  from &kiss_table k
  join userrule u1 on u1.userid=initiatinguserid
  join temp_user u2 on u2.userid=targetuserid
  left join &reply_table r on r.id=replymessageid
  where k.created between &evaluation_start_date and &trial_start_date
  group by r, u1.gender, u1.userid, getweek(k.created)
) on r=rule and g=gender and w=week
group by rule, gender, week order by rule, gender, week;

-- Count of positive kisses as above
select rule, gender, week, nvl(avg(kiss), 0) avgkiss, nvl(median(kiss), 0) medkiss, nvl(stddev(kiss), 0) stdkiss
from rg2 left join (
  select r, u1.gender g, u1.userid u, getweek(k.created) w, count(*) kiss
  from &kiss_table k
  join userrule u1 on u1.userid=initiatinguserid
  join temp_user u2 on u2.userid=targetuserid
  left join &reply_table r on r.id=replymessageid
  where k.created between &evaluation_start_date and &trial_start_date
    and positivereply = 1
  group by r, u1.gender, u1.userid, getweek(k.created)
) on r=rule and g=gender and w=week
group by rule, gender, week order by rule, gender, week;


-- Number of contacts for a user (M, F) per week in trial
-- period, avg, median, stddev
select rule, gender, week, nvl(avg(kiss), 0) avgkiss, nvl(median(kiss), 0) medkiss, nvl(stddev(kiss), 0) stdkiss
from rg2 left join (
  select u.userid, r, gender g, getweek(k.created) w, count(*) kiss
  from temp_kiss k join userrule u on u.userid=k.userid
  group by u.userid, r, gender, getweek(k.created)
) on r=rule and g=gender and w=week
group by rule, gender, week order by rule, gender, week;

-- Count of positive kisses as above
select rule, gender, week, nvl(avg(kiss), 0) avgkiss, nvl(median(kiss), 0) medkiss, nvl(stddev(kiss), 0) stdkiss
from rg2 left join (
  select u.userid, r, gender g, getweek(k.created) w, count(*) kiss
  from temp_kiss k join userrule u on u.userid=k.userid
  where positivereply = 1
  group by u.userid, r, gender, getweek(k.created)
) on r=rule and g=gender and w=week
group by rule, gender, week order by rule, gender, week;
