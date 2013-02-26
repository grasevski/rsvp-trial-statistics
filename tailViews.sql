-- Views for calculating new, act0, pop0 and act0_pop0 stats

-- List of rule numbers, 0..9
create or replace view rule as
select rownum-1 rule from dual connect by level <= 10;

-- List of gender numbers, 134..135
create or replace view gender as
select rownum+133 gender from dual connect by level <= 2;

-- List of placements, 1..6
create or replace view placement as
select rownum placement from dual connect by level <= 9;

-- Recommendations generated, including impressions for rules 0-3
create or replace view tail_generated as
select userid, targetuserid, placement, created from placement, (
  select u.userid userid, targetuserid, x.created created
  from userrule u join temp_recom x on x.userid=u.userid
  where r between 0 and 3
  union select u.userid userid, targetuserid, x.created created
  from userrule u join temp_impression x on x.userid=u.userid
  where r between 4 and 9
);

-- Impressions
create or replace view tail_delivered as
select userid, targetuserid, placement, created
from temp_impression;

-- Clicks
create or replace view tail_clicked as
select userid, targetuserid, placement, created
from temp_click;

-- Kisses, from clicks
create or replace view tail_kissed as
select userid, targetuserid, placement, created from (
  select k.userid userid, k.targetuserid targetuserid, placement, k.created created, max(c.created)
  from temp_kiss k join temp_click c
  on k.userid=c.userid and k.targetuserid=c.targetuserid
  where c.created < k.created
  group by k.userid, k.targetuserid, placement, k.created);

-- Successful kisses
create or replace view tail_kissed_t as
select userid, targetuserid, placement, created from (
  select k.userid userid, k.targetuserid targetuserid, placement, k.created created, max(c.created)
  from temp_kiss k join temp_click c
  on k.userid=c.userid and k.targetuserid=c.targetuserid
  where c.created < k.created and positivereply = 1
  group by k.userid, k.targetuserid, placement, k.created);

-- Channels, from clicks
create or replace view tail_channeled as
select userid, targetuserid, placement, created from (
  select k.userid userid, k.targetuserid targetuserid, placement, k.created created, max(c.created)
  from temp_channel k join temp_click c
  on k.userid=c.userid and k.targetuserid=c.targetuserid
  where c.created < k.created
  group by k.userid, k.targetuserid, placement, k.created);

commit;
