-- 0 0
-- lhs2rhs: !recoms -> !candids
-- lhs2q: !recoms -> all
-- p2rhs: all -> !candids

-- 0 1
-- lhs2rhs: !recoms -> candids
-- lhs2q: !recoms -> all
-- p2rhs: all -> candids

-- 1 0
-- lhs2rhs: recom -> !candid
-- lhs2q: recoms -> all
-- p2rhs: all -> !candids

-- 1 1
-- lhs2rhs: recom -> candid
-- lhs2q: recoms -> all
-- p2rhs: all -> candids


-- pool
select r.rule rule, gender, isrecommendee, iscandidate, count(g) pool
from (
  select rule, g.boolid+134 gender, r.boolid isrecommendee, c.boolid iscandidate
  from temp_rule, temp_bool g, temp_bool r, temp_bool c
) r left join (
  select u.rule rule, gender g, isrecommendee r, case when targetuserid is not null then 1 else 0 end c
  from temp_user u left join temp_impression
  on targetuserid=userid and temp_impression.rule=u.rule) u
on u.rule=r.rule and g=gender and r=isrecommendee and c=iscandidate
group by r.rule, gender, isrecommendee, iscandidate
order by r.rule, gender, isrecommendee, iscandidate;


-- lhs2rhs 00, 01
-- 00: !recoms -> !candids
-- 01: !recoms -> candids
select rule, gender1, gender2,
  r.c iscandidate,
  count(distinct u) nLHS, count(distinct t) nRHS, count(u) LHS2RHS
from rulegroup r
left join lhs2rhs0 c
on c.r=rule and c.c=r.c and g1=gender1 and g2=gender2
group by rule, gender1, gender2, r.c
order by rule, gender1, gender2, r.c;

select rule, gender1, gender2,
  r.c iscandidate,
  count(distinct u) nLHS_T, count(distinct t) nRHS_T, count(u) LHS2RHS_T
from rulegroup r
left join (select * from lhs2rhs0 where reply = 1) c
on c.r=rule and c.c=r.c and g1=gender1 and g2=gender2
group by rule, gender1, gender2, r.c
order by rule, gender1, gender2, r.c;


-- lhs2rhs 10, 11
-- 10: recom -> !candid
-- 11: recom -> candid
select rule, gender1, gender2,
  r.c iscandidate,
  count(distinct u) nLHS, count(distinct t) nRHS, count(u) LHS2RHS
from rulegroup r
left join lhs2rhs1 c
on c.r=rule and c.c=r.c and g1=gender1 and g2=gender2
group by rule, gender1, gender2, r.c
order by rule, gender1, gender2, r.c;

select rule, gender1, gender2,
  r.c iscandidate,
  count(distinct u) nLHS_T, count(distinct t) nRHS_T, count(u) LHS2RHS_T
from rulegroup r
left join (select * from lhs2rhs1 where reply = 1) c
on c.r=rule and c.c=r.c and g1=gender1 and g2=gender2
group by rule, gender1, gender2, r.c
order by rule, gender1, gender2, r.c;


-- lhs2q 00, 01, 10, 11
-- 00, 01: !recoms -> all
-- 10, 11: recoms -> all
select rule, gender1, gender2,
  r.c isrecommendee,
  count(distinct u) nLHS, count(distinct t) nQ, count(u) LHS2Q
from rulegroup r
left join lhs2q c
on c.r=rule and c.c=r.c and g1=gender1 and g2=gender2
group by rule, gender1, gender2, r.c
order by rule, gender1, gender2, r.c;

select rule, gender1, gender2,
  r.c isrecommendee,
  count(distinct u) nLHS_T, count(distinct t) nQ_T, count(u) LHS2Q_T
from rulegroup r
left join (select * from lhs2q where reply = 1) c
on c.r=rule and c.c=r.c and g1=gender1 and g2=gender2
group by rule, gender1, gender2, r.c
order by rule, gender1, gender2, r.c;


-- p2rhs 00, 01, 10, 11
-- 00, 10: all -> !candids
-- 01, 11: all -> candids
select rule, gender1, gender2,
  r.c iscandidate,
  count(distinct u) nP, count(distinct t) nRHS, count(u) P2RHS
from rulegroup r
left join p2rhs c
on c.r=rule and c.c=r.c and g1=gender1 and g2=gender2
group by rule, gender1, gender2, r.c;

select rule, gender1, gender2,
  r.c iscandidate,
  count(distinct u) nP_T, count(distinct t) nRHS_T, count(u) P2RHS_T
from rulegroup r
left join (select * from p2rhs where reply = 1) c
on c.r=rule and c.c=r.c and g1=gender1 and g2=gender2
group by rule, gender1, gender2, r.c
order by rule, gender1, gender2, r.c;
