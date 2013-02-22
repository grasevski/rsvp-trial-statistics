-- unittest
-- Script for checking test cases

-- Definitions (ie test cases)
def rule=7
def gender=134
def isrecommendee=1
def iscandidate=1
def r=8
def g1=134
def g2=135
def c=1
def week=2

-- Results

-- pool
select count(*) pool from (
  select case when targetuserid is not null then 1 else 0 end c
  from userrule left join candidates on rule=r
  where r=&rule and gender=&gender and isrecommendee=&isrecommendee
) where c=&iscandidate;

-- lhs2rhs 00, 01
-- 00: !recoms -> !candids
-- 01: !recoms -> candids
select count(distinct u) nLHS, count(distinct t) nRHS, count(*) LHS2RHS
from lhs2rhs0 where r = &r and g1 = &g1 and g2 = &g2 and c = &c;
select count(distinct u) nLHS_T, count(distinct t) nRHS_T, count(*) LHS2RHS_T
from lhs2rhs0 where r = &r and g1 = &g1 and g2 = &g2 and c = &c
  and positivereply = 1;

-- lhs2rhs 10, 11
-- 10: recom -> !candid
-- 11: recom -> candid
select count(distinct u) nLHS, count(distinct t) nRHS, count(*) LHS2RHS
from lhs2rhs1 where r = &r and g1 = &g1 and g2 = &g2 and c = &c;
select count(distinct u) nLHS_T, count(distinct t) nRHS_T, count(*) LHS2RHS_T
from lhs2rhs1 where r = &r and g1 = &g1 and g2 = &g2 and c = &c
  and positivereply = 1;

-- lhs2q 00, 01, 10, 11
-- 00, 01: !recoms -> all
-- 10, 11: recoms -> all
select count(distinct u) nLHS, count(distinct t) nQ, count(*) LHS2Q
from lhs2q where r = &r and g1 = &g1 and g2 = &g2 and c = &c;
select count(distinct u) nLHS_T, count(distinct t) nQ_T, count(*) LHS2Q_T
from lhs2q where r = &r and g1 = &g1 and g2 = &g2 and c = &c
  and positivereply = 1;

-- p2rhs 00, 01, 10, 11
-- 00, 10: all -> !candids
-- 01, 11: all -> candids
select count(distinct u) nP, count(distinct t) nRHS, count(*) P2RHS
from p2rhs where r = &r and g1 = &g1 and g2 = &g2 and c = &c;
select count(distinct u) nP_T, count(distinct t) nRHS_T, count(*) P2RHS_T
from p2rhs where r = &r and g1 = &g1 and g2 = &g2 and c = &c
  and positivereply = 1;


-- Summary




--click
select score, count(*)
from temp_click x join userrule u on u.userid=x.userid
where gender = &gender and getweek(x.created) = &week and r = &rule
group by score order by score;

--kiss
select score, count(*)
from temp_kiss x join userrule u on u.userid=x.userid
join clickscore on u=x.userid and t=x.targetuserid
where gender = &gender and getweek(x.created) = &week and r = &rule
  and c < x.created
group by score order by score;

--kiss_t
select score, count(*)
from temp_kiss x join userrule u on u.userid=x.userid
join clickscore on u=x.userid and t=x.targetuserid
where gender = &gender and getweek(x.created) = &week and r = &rule
  and c < x.created and positivereply = 1
group by score order by score;

--channel
select score, count(*)
from temp_channel x join userrule u on u.userid=x.userid
join clickscore on u=x.userid and t=x.targetuserid
where gender = &gender and getweek(x.created) = &week and r = &rule
  and c < x.created
group by score order by score;

--impression
select score, count(*)
from temp_impression x join userrule u on u.userid=x.userid
where gender = &gender and getweek(x.created) = &week and r = &rule
group by score order by score;
