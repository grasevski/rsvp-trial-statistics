-- Temporary views are used to simplify queries
-- NB MUST BE RUN WHENEVER DEFINITIONS CHANGE! Otherwise they will
-- be referring to the wrong parameters.

@@definitions.sql

-- Combinations of rule, genders etc
create or replace view rulegroup as
select rule, c.boolid c, g1.boolid+134 gender1, g2.boolid+134 gender2
from temp_rule, temp_bool c, temp_bool g1, temp_bool g2;

-- Users plus their rules, for convenience
create or replace view userrule as
select userid, gender, isrecommendee, created, mod(userid, 10) r
from temp_user;

-- Distinct pairings of rules and targetuserids, for convenience
create or replace view candidates as
select distinct r rule, targetuserid from temp_impression i
join userrule r on r.userid=i.userid where r between 0 and 3
union select distinct r rule, targetuserid from temp_recom i
join userrule r on r.userid=i.userid where r between 4 and 9;

-- lhs2rhs kiss interactions for non-recommendees
create or replace view lhs2rhs0 as
select positivereply, r, u1.gender g1, u2.gender g2, u1.userid u, u2.userid t, case when c.targetuserid is not null then 1 else 0 end c
from temp_kiss k join userrule u1 on u1.userid=k.userid
join temp_user u2 on u2.userid=targetuserid left join candidates c
on c.targetuserid=u2.userid and rule=r where u1.isrecommendee = 0;

-- lhs2rhs kiss interactions for recommendees
create or replace view lhs2rhs1 as
select positivereply, r, u1.gender g1, u2.gender g2, u1.userid u, u2.userid t, case when c.targetuserid is not null then 1 else 0 end c
from temp_kiss k join userrule u1 on u1.userid=k.userid
join temp_user u2 on u2.userid=k.targetuserid
left join (select userid, targetuserid, min(created) c
  from temp_click where c <= k.created group by userid, targetuserid
) c on c.userid=u1.userid and c.targetuserid=u2.userid;

-- lhs2q kiss interactions
create or replace view lhs2q as
select positivereply, r, u1.gender g1, u2.gender g2, u2.isrecommendee c, u1.userid u, u2.userid t
from temp_kiss k join userrule u1 on u1.userid=k.userid
join temp_user u2 on u2.userid=targetuserid;

-- p2rhs kiss interactions
create or replace view p2rhs as
select positivereply, r, u1.gender g1, u2.gender g2, u1.userid u, u2.userid t, case when c.targetuserid is not null then 1 else 0 end c
from temp_kiss k join userrule u1 on u1.userid=k.userid
join temp_user u2 on u2.userid=targetuserid left join candidates c
on c.targetuserid=u2.userid and rule=r;


-- Groupings for the summary data
create or replace view rg as
select r.rule rule, w.rule week, boolid+134 gender, p.rule placement
from temp_rule r, temp_rule w, temp_bool, temp_rule p
where p.rule < 4 and w.rule between 1 and 6;

-- Groupings for the contacts data
create or replace view rg2 as
select r.rule rule, boolid+134 gender, w.rule week
from temp_rule r, temp_bool, temp_rule w
where w.rule between 1 and 6;

-- These recommendations are used for the "days from recommendation
-- to impression" calculations
create or replace view temp_unique_recom as
select userid, targetuserid, min(created) c
from temp_recom group by userid, targetuserid;

-- These impressions are used for the "days from impression to x"
-- calculations
create or replace view temp_unique_impression as
select userid, targetuserid, placement, min(created) c
from temp_impression group by userid, targetuserid, placement;

-- These clicks are used for the "days from click to x" calculations
create or replace view temp_unique_click as
select userid, targetuserid, placement, min(created) c
from temp_click group by userid, targetuserid, placement;

-- These kisses are used for the "days from x to kiss" calculations
create or replace view temp_unique_kiss as
select userid, targetuserid, min(created) c
from temp_kiss group by userid, targetuserid;

-- These channels are used for the "days from x to channel"
-- calculations
create or replace view temp_unique_channel as
select userid, targetuserid, min(created) c
from temp_channel group by userid, targetuserid;

-- Kisses, augmented with most recent score
create or replace view kissscore as
select userid, targetuserid, positivereply, k.created created, score
from (
  select k.userid u, k.targetuserid t, positivereply, k.created created, max(c.created) c
  from temp_kiss k join temp_click c
  on c.userid=k.userid and c.targetuserid=k.targetuserid
  where c.created <= k.created
  group by k.userid, k.targetuserid, k.positivereply, k.created
) k join temp_click c on userid=u and targetuserid=t
where c.created=c;

-- As above, with successful kisses
create or replace view kissscore_t as
select userid, targetuserid, created, score
from kissscore where positivereply=1;

-- Channels, augmented with most recent score
create or replace view channelscore as
select userid, targetuserid, k.created created, score
from temp_click c join (
  select k.userid u, k.targetuserid t, k.created created, max(c.created) c
  from temp_channel k join temp_click c
  on c.userid=k.userid and c.targetuserid=k.targetuserid
  where c.created <= k.created
  group by k.userid, k.targetuserid, k.created
) k on u=userid and t=targetuserid
where c=c.created;

-- Returns the trial week of the given time
create or replace function getweek(t in timestamp) return integer as
begin
  return trunc(extract(day from t - &trial_start_date)/7) + 1;
end;
.
/

-- Converts an interval to a number of days as a floating point
-- number
create or replace function interval2float
(t in interval day to second) return float as begin
  return extract(day from t) + (extract(hour from t)
      + (extract(minute from t) + extract(second from t)/60)/60)/24;
end;
.
/

commit;
