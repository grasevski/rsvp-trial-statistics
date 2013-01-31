select &groupings, &measures from rg left join (
  select &fields from &tbl x &aux
  join temp_user u1 on u1.userid=x.userid
  join temp_user u2 on u2.userid=x.targetuserid
  where u1.gender <> u2.gender &cond &grp) on &joins
group by &groupings;
