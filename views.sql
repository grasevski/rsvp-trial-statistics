-- Temporary views are used to simplify queries

@@definitions;

-- Delete existing temporary views
drop view rulegroup;
drop view lhs2rhs0;
drop view lhs2rhs1;
drop view lhs2q;
drop view p2rhs;

-- Combinations of rule, genders etc
create view rulegroup as
select rule, c.boolid c, g1.boolid+134 gender1, g2.boolid+134 gender2
from temp_rule, temp_bool c, temp_bool g1, temp_bool g2;

-- lhs2rhs kiss interactions for non-recommendees
create view lhs2rhs0 as
select reply, u1.rule r, u1.gender g1, u2.gender g2, u1.userid u, u2.userid t, case when i.targetuserid is not null then 1 else 0 end c
from temp_kiss
join temp_user u1 on u1.userid=initiatinguserid
join temp_user u2 on u2.userid=targetuserid
left join temp_impression i on i.targetuserid=u2.userid
  and i.rule=u1.rule
where u1.isrecommendee = 0;

-- lhs2rhs kiss interactions for recommendees
create view lhs2rhs1 as
select reply, u1.rule r, u1.gender g1, u2.gender g2, u1.userid u, u2.userid t, case when c.targetuserid is not null then 1 else 0 end c
from temp_kiss k
join temp_user u1 on u1.userid=k.initiatinguserid
join temp_user u2 on u2.userid=k.targetuserid
left join (select initiatinguserid, targetuserid, min(created) c
  from temp_click group by initiatinguserid, targetuserid) c
on c.initiatinguserid=u1.userid
  and c.targetuserid=u2.userid
  and c.c < k.created;

-- lhs2q kiss interactions
create view lhs2q as
select reply, u1.rule r, u1.gender g1, u2.gender g2, u2.isrecommendee c, u1.userid u, u2.userid t
from temp_kiss
join temp_user u1 on u1.userid=initiatinguserid
join temp_user u2 on u2.userid=targetuserid;

-- p2rhs kiss interactions
create view p2rhs as
select reply, u1.rule r, u1.gender g1, u2.gender g2, u1.userid u, u2.userid t, case when i.targetuserid is not null then 1 else 0 end c
from temp_kiss
join temp_user u1 on u1.userid=initiatinguserid
join temp_user u2 on u2.userid=targetuserid
left join temp_impression i on i.targetuserid=u2.userid
  and i.rule=u1.rule;
