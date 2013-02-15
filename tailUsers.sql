select rule, placement, gender, count(distinct u) nLHS, count(distinct t) nRHS, count(*) LHS2RHS
from (select rule, boolid gender from temp_rule, temp_bool)
left join (select
) on r=rule and g=gender group by rule, gender;

select &groupings, count(distinct u) nLHS, count(distinct t) nRHS, count(*) LHS2RHS
select &groupings, &measures from (select distinct &groupings
  from rule, placement, week, gender) left join (

) on &joins group by &groupings order by &groupings;


select u.userid u, targetuserid t, score, created c
from &impressions i join userrule u on u.userid=i.userid and r=rule
where rule between 0 and 3
union all select u.userid u, candidate_userid t, score, daterecommended c
from &all_recom r join userrule u on u.userid=r.userid and r=rule
where rule between 4 and 9;

select u.userid u, targetuserid t, score, created c
from &impressions i join userrule u on u.userid=i.userid and r=rule
where rule between 0 and 3
union all select u.userid u, targetuserid t, score, created c
from &impressions i join userrule u on u.userid=r.userid and r=rule
join (
  select userid, candidate_userid, methodnumber, score s, min(daterecommended) d
  from &all_recom
  group by userid, candidate_userid, methodnumber, score
) r on r.userid=u.userid
  and candidate_userid=targetuserid
  and methodnumber=r
  and s=score
  and d < created;

select u, t, score, placement, created from &clicks c
join userrule u on u.userid=c.userid and r=rule
join (select u, t, score s, min(c) c from delivered
  group by u, t, score)
on u=u.userid and t=targetuserid and s=score and c < created;

select u, t, score, created from &kiss_table k


create or replace view new_users as
select * from userrule where created between &date - 7 and &date;

create or replace view act0 as
select userid, gender, dob, created from userrule join (
  select userid u from userrule
  except select distinct userid u from temp_kiss
  where created between &date - 28 and &date) on u=userid;

create or replace view pop0 as
select userid, gender, dob, created from userrule join (
  select userid u from userrule
  except select distinct targetuserid u from temp_kiss
  where created between &date - 28 and &date) on u=userid;

create or replace view act0_pop0 as
select userid, gender, dob, created from userrule join (
  select userid u from userrule except (select distinct userid u
    from temp_kiss where created between &date - 28 and &date
    union select distinct targetuserid u from temp_kiss
    where created between &date - 28 and &date)) on u=userid;



select rule, placement, count(distinct u) nLHS, count(distinct t) nRHS, count(*) LHS2RHS


def groupings='rule, placement'
def measures='count(distinct u) nLHS, count(distinct t) nRHS, count(*) LHS2RHS'
def grouptables=&groupings
def joins='r=rule and p=placement'
def results='select u1.userid u, u2.userid t, u1.rule r, c.placement p from temp_click x join (select userid, targetuserid, placement, min(created) c from temp_impression group by userid, targetuserid, placement) y on y.userid=x.userid and y.targetuserid=x.targetuserid join &lhs u1 on u1.userid=x.userid join &rhs u2 on u2.userid=x.targetuserid where c < created'

def results='select u1.userid u, u2.userid t, u1.rule r, from temp_kiss x join (select userid, targetuserid, min(created) c from temp_click group by userid, targetuserid) y on y.userid=x.userid and y.targetuserid=x.targetuserid join &lhs u1 on u1.userid=x.userid join &rhs u2 on u2.userid=x.targetuserid where c < created'

def results='select u1.userid u, u2.userid t, u1.rule r, from temp_kiss x join (select userid, targetuserid, min(created) c from temp_click group by userid, targetuserid) y on y.userid=x.userid and y.targetuserid=x.targetuserid join &lhs u1 on u1.userid=x.userid join &rhs u2 on u2.userid=x.targetuserid where c < created and positivereply = 1'

def results='select u1.userid u, u2.userid t, u1.rule r, from temp_channel x join (select userid, targetuserid, min(created) c from temp_click group by userid, targetuserid) y on y.userid=x.userid and y.targetuserid=x.targetuserid join &lhs u1 on u1.userid=x.userid join &rhs u2 on u2.userid=x.targetuserid where c < created'

select &groupings, &measures from (select distinct &groupings from
  &grouptables) left join (select &fields from &x x join (
    select userid, targetuserid, min(created) c
    from &y group by userid, targetuserid
  ) y on y.userid=x.userid and y.targetuserid=x.targetuserid
  join &lhs u1 on u1.userid=x.userid
  join &rhs u2 on u2.userid=x.targetuserid
  where c < created
) on &joins group by &groupings order by &groupings;

select rule, placement, count(distinct u) nLHS, count(distinct t) nRHS, count(*) LHS2RHS
from (select distinct rule, placement from rule, placement)
left join (select u1.userid u, u2.userid t, u1.rule r, y.placement p
  from temp_channel x join (
    select userid, targetuserid, placement, min(created) c
    from temp_click group by userid, targetuserid, placement
  ) y on y.userid=x.userid
    and y.targetuserid=x.targetuserid
    and y.placement=x.placement
  join &lhs u1 on u1.userid=x.userid
  join &rhs u2 on u2.userid=x.targetuserid
  where c < created) on r=rule and p=placement
group by rule, placement;

def groupings='rule, placement'
def measures='count(distinct u) nLHS, count(distinct t) nRHS, count(*) LHS2RHS'
def grouptables=&groupings
def x=temp_click
def y=temp_impression
def lhs=act0
def rhs=act0
def cond=''
def joins='r=rule and p=placement'

select &groupings, &measures from (select distinct &groupings from
  &grouptables) left join (select u, t, u1.rule r, p from &x x
  join (select userid u, targetuserid t, placement p, min(created) c
    from &y group by userid, targetuserid, placement
  ) y on u=x.userid and t=targetuserid and p=placement
  join &lhs u1 on u1.userid=u join &rhs u2 on u2.userid=t
  where c < created &cond) on &joins
group by &groupings order by &groupings;


select rule, count(distinct u) nLHS, count(distinct t) nRHS, count(*) LHS2RHS
from rule left join (select x.userid u, targetuserid t, r
  from &recom x join userrule u on u.userid=x.userid and rule=r
  join (
    select userid, max(sent) s from &activity where sent < created
  ) y on y.userid=x.userid and interval2float(created-s) <= 28
) on r=rule group by rule order by rule;

select &groupings, &measures from (select distinct &groupings from
  &grouptables)

def groupings='rule, gender'
def groupingtables='rule, gender, placement'
def fields='x.userid u, targetuserid t, r, u1.gender g'
def aux=''
def grp=''
def joins='r=rule and g=gender'

def x=temp_recom
@@tailStats.sql
def x=temp_impression
@@tailStats.sql


def groupings='rule, gender'
def measures='count(distinct u) nLHS_New2New, count(distinct t) nRHS_New2New, count(*) New2New'
def groupingtables='rule, gender, placement'
def fields='x.userid u, targetuserid t, r, u1.gender g'
def x=temp_recom
def aux=''
def cond='where u1.created between x.created - 7 and x.created and u2.created between x.created - 7 and x.created'
def grp=''
def joins='r=rule and g=gender'

@@tailQuery.sql

def measures='count(distinct u) nLHS_New2all, count(distinct t) nRHS_New2all, count(*) New2ALL'
def cond='where u1.created between x.created - 7 and x.created'

@@tailQuery.sql

def measures='count(distinct u) nLHS_all2New, count(distinct t) nRHS_all2New, count(*) all2New'
def cond='where u2.created between x.created - 7 and x.created'

@@tailQuery.sql

def measures='count(distinct u) nLHS_act02act0, count(distinct t) nRHS_act02act0, count(*) act02act0'
def cond='where not exists (select * from temp_activity where userid in (x.userid, targetuserid) and sent between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_act02all, count(distinct t) nRHS_act02all, count(*) act02all'
def cond='where not exists (select * from temp_activity where userid=x.userid and sent between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_all2act0, count(distinct t) nRHS_all2act0, count(*) all2act0'
def cond='where not exists (select * from temp_activity where userid=targetuserid and sent between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_pop02pop0, count(distinct t) nRHS_pop02pop0, count(*) pop02pop0'
def cond='where not exists (select * from temp_activity where userid in (x.userid, targetuserid) and received between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_pop02all, count(distinct t) nRHS_pop02all, count(*) pop02all'
def cond='where not exists (select * from temp_activity where userid=x.userid and received between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_all2pop0, count(distinct t) nRHS_all2pop0, count(*) all2pop0'
def cond='where not exists (select * from temp_activity where userid=targetuserid and received between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_act0_pop02act0_pop0, count(distinct t) nRHS_act0_pop02act0_pop0, count(*) act0_pop02act0_pop0'
def cond='where not exists (select * from temp_activity where userid in (x.userid, targetuserid) and sent between x.created - 28 and x.created or received between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_act0_pop02all, count(distinct t) nRHS_act0_pop02all, count(*) act0_pop02all'
def cond='where not exists (select * from temp_activity where userid=x.userid and sent between x.created - 28 and x.created or received between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_all2act0_pop0, count(distinct t) nRHS_all2act0_pop0, count(*) all2act0_pop0'
def cond='where not exists (select * from temp_activity where userid=targetuserid and sent between x.created - 28 and x.created or received between x.created - 28 and x.created)'

@@tailQuery.sql

def groupings='rule, gender, placement'
def measures='count(distinct u) nLHS_New2New, count(distinct t) nRHS_New2New, count(*) New2New'
def fields='&fields, x.placement p'
def x=temp_impression
def cond='where u1.created between x.created - 7 and x.created and u2.created between x.created - 7 and x.created'
def joins='&joins and p=placement'

@@tailQuery.sql

def measures='count(distinct u) nLHS_New2all, count(distinct t) nRHS_New2all, count(*) New2all'
def cond='where u1.created between x.created - 7 and x.created'

@@tailQuery.sql

def measures='count(distinct u) nLHS_all2New, count(distinct t) nRHS_all2New, count(*) all2New'
def cond='where u2.created between x.created - 7 and x.created'

@@tailQuery.sql

def measures='count(distinct u) nLHS_act02act0, count(distinct t) nRHS_act02act0, count(*) act02act0'
def cond='where not exists (select * from temp_activity where userid in (x.userid, targetuserid) and sent between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_act02all, count(distinct t) nRHS_act02all, count(*) act02all'
def cond='where not exists (select * from temp_activity where userid=x.userid and sent between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_all2act0, count(distinct t) nRHS_all2act0, count(*) all2act0'
def cond='where not exists (select * from temp_activity where userid=targetuserid and sent between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_pop02pop0, count(distinct t) nRHS_pop02pop0, count(*) pop02pop0'
def cond='where not exists (select * from temp_activity where userid in (x.userid, targetuserid) and received between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_pop02all, count(distinct t) nRHS_pop02all, count(*) pop02all'
def cond='where not exists (select * from temp_activity where userid=x.userid and received between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_all2pop0, count(distinct t) nRHS_all2pop0, count(*) all2pop0'
def cond='where not exists (select * from temp_activity where userid=targetuserid and received between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_act0_pop02act0_pop0, count(distinct t) nRHS_act0_pop02act0_pop0, count(*) act0_pop02act0_pop0'
def cond='where not exists (select * from temp_activity where userid in (x.userid, targetuserid) and (sent between x.created - 28 and x.created or received between x.created - 28 and x.created))'

@@tailQuery.sql

def measures='count(distinct u) nLHS_act0_pop02all, count(distinct t) nRHS_act0_pop02all, count(*) act0_pop02all'
def cond='where not exists (select * from temp_activity where userid=x.userid and (sent between x.created - 28 and x.created or received between x.created - 28 and x.created))'

@@tailQuery.sql

def measures='count(distinct u) nLHS_all2act0_pop0, count(distinct t) nRHS_all2act0_pop0, count(*) all2act0_pop0'
def cond='where not exists (select * from temp_activity where userid=targetuserid and (sent between x.created - 28 and x.created or received between x.created - 28 and x.created))'

@@tailQuery.sql

def measures='count(distinct u) nLHS_New2New, count(distinct t) nRHS_New2New, count(*) New2New'
def x=temp_click
def cond='where u1.created between x.created - 28 and x.created and u2.created between x.created - 28 and x.created'

@@tailQuery.sql

def measures='count(distinct u) nLHS_New2all, count(distinct t) nRHS_New2all, count(*) New2all'
def cond='where u1.created between x.created - 28 and x.created'

@@tailQuery.sql

def measures='count(distinct u) nLHS_all2New, count(distinct t) nRHS_all2New, count(*) all2New'
def cond='where u2.created between x.created - 28 and x.created'

@@tailQuery.sql

def measures='count(distinct u) nLHS_act02act0, count(distinct t) nRHS_act02act0, count(*) act02act0'
def cond='where not exists (select * from temp_account where userid in (x.userid, targetuserid) and sent between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_act02all, count(distinct t) nRHS_act02all, count(*) act02all'
def cond='where not exists (select * from temp_account where userid=x.userid and sent between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_all2act0, count(distinct t) nRHS_all2act0, count(*) all2act0'
def cond='where not exists (select * from temp_account where userid=targetuserid and sent between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_pop02pop0, count(distinct t) nRHS_pop02pop0, count(*) pop02pop0'
def cond='where not exists (select * from temp_account where userid in (x.userid, targetuserid) and received between x.created - 28 and x.created'

@@tailQuery.sql

def measures='count(distinct u) nLHS_pop02all, count(distinct t) nRHS_pop02all, count(*) pop02pop0'
def cond='where not exists (select * from temp_account where userid=x.userid and received between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_all2pop0, count(distinct t) nRHS_all2pop0, count(*) all2pop0'
def cond='where not exists (select * from temp_account where userid=targetuserid and received between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_act0_pop02act0_pop0, count(distinct t) nRHS_act0_pop02act0_pop0, count(*) act0_pop02act0_pop0'
def cond='where not exists (select * from temp_account where userid in (x.userid, targetuserid) and (sent between x.created - 28 and x.created or received between x.created - 28 and x.created))'

@@tailQuery.sql

def measures='count(distinct u) nLHS_act0_pop02all, count(distinct t) nRHS_act0_pop02all, count(*) act0_pop02all'
def cond='where not exists (select * from temp_account where userid=x.userid and (sent between x.created - 28 and x.created or received between x.created - 28 and x.created))'

@@tailQuery.sql

def measures='count(distinct u) nLHS_all2act0_pop0, count(distinct t) nRHS_all2act0_pop0, count(*) all2act0_pop0'
def cond='where not exists (select * from temp_account where userid=targetuserid and (sent between x.created - 28 and x.created or received between x.created - 28 and x.created))'

@@tailQuery.sql

def measures='count(distinct u) nLHS_New2New, count(distinct t) nRHS_New2New, count(*) New2New'
def x=temp_kiss
def cond='where u1.created between x.created - 7 and x.created and u2.created between x.created - 7 and x.created'

@@tailQuery.sql

def measures='count(distinct u) nLHS_New2all, count(distinct t) nRHS_New2all, count(*) New2all'
def cond='where u1.created between x.created - 7 and x.created'

@@tailQuery.sql

def measures='count(distinct u) nLHS_all2New, count(distinct t) nRHS_all2New, count(*) all2New'
def cond='where u2.created between x.created - 7 and x.created'

@@tailQuery.sql

def measures='count(distinct u) nLHS_act02act0, count(distinct t) nRHS_act02act0, count(*) act02act0'
def cond='where not exists (select * from temp_activity where userid in (x.userid, targetuserid) and sent between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_act02all, count(distinct t) nRHS_act02all, count(*) act02all'
def cond='where not exists (select * from temp_activity where userid=x.userid and sent between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_all2act0, count(distinct t) nRHS_all2act0, count(*) all2act0'
def cond='where not exists (select * from temp_activity where userid=targetuserid and sent between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_pop02pop0, count(distinct t) nRHS_pop02pop0, count(*) pop02pop0'
def cond='where not exists (select * from temp_activity where userid in (x.userid, targetuserid) and received between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_pop02all, count(distinct t) nRHS_pop02all, count(*) pop02all'
def cond='where not exists (select * from temp_activity where userid=x.userid and received between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_all2pop0, count(distinct t) nRHS_all2pop0, count(*) all2pop0'
def cond='where not exists (select * from temp_activity where userid=targetuserid and received between x.created - 28 and x.created)'

@@tailQuery.sql

def measures='count(distinct u) nLHS_act0_pop02act0_pop0, count(distinct t) nRHS_act0_pop02act0_pop0, count(*) act0_pop02act0_pop0'
def cond='where not exists (select * from temp_activity where userid in (x.userid, targetuserid) and (sent between x.created - 28 and x.created and received between x.created - 28 and x.created))'

@@tailQuery.sql

def measures='count(distinct u) nLHS_act0_pop02all, count(distinct t) nRHS_act0_pop02all, count(*) act0_pop02all'
def cond='where not exists (select * from temp_activity where userid=x.userid and (sent between x.created - 28 and x.created and received between x.created - 28 and x.created))'

@@tailQuery.sql

def measures='count(distinct u) nLHS_all2act0_pop0, count(distinct t) nRHS_all2act0_pop0, count(*) all2act0_pop0'
def cond='where not exists (select * from temp_activity where userid=targetuserid (sent between x.created - 28 and x.created and received between x.created - 28 and x.created))'


def

def groupings='rule'
def measures='count(distinct u) nLHS, count(distinct t) nRHS, count(*) LHS2RHS'
def groupingtables='rule, placement'
def fields='x.userid u, targetuserid t, r'
def aux='join (select userid, max(sent) s from &activity where sent < created) y on y.userid=x.userid'
def cond='where interval2float(created-s) <= 28'
def grp=''
def joins='r=rule'

@@tailQuery.sql

-- Query template for the new, act0, pop0, act0_pop0 users
select &groupings, &measures from (select distinct &groupings from
  &groupingtables) left join (select &fields from (&x) x &aux
  join userrule u1 on u1.userid=x.userid
  join temp_user u2 on u2.userid=x.targetuserid
  &cond &grp) on &joins group by &groupings order by &groupings;
