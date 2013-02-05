-- Query template for the trial 2 summary statistics
select &groupings, &measures from (select distinct &groupings
  from rg) left join (select &fields from &tbl x &aux
  join userrule u1 on u1.userid=x.userid
  join temp_user u2 on u2.userid=x.targetuserid
  where u1.gender != u2.gender &cond &grp) on &joins
group by &groupings;
