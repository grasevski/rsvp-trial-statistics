-- Avg, median, stddev score by method
select rule, avg(score) avgscore, median(score) medscore, stddev(score) stdscore
from rule left join (select r, score from temp_impression i
  join userrule u on u.userid=i.userid) on r=rule
group by rule order by rule;

-- Score each week of trial
select rule, week, avg(score) avgscore, median(score) medscore, stddev(score) stdscore
from (select r.rule rule, w.rule week from rule r, rule w
  where w.rule between 1 and 6) left join (
  select getweek(created) w, r, score from temp_impression i
  join userrule u on u.userid=i.userid) on r=rule and w=week
group by rule, week order by rule, week;
