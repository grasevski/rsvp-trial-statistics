-- Avg, median, stddev score by method
select rule, nvl(avg(score), 0) avgscore, nvl(median(score), 0) medscore, nvl(stddev(score), 0) stdscore
from temp_rule left join (select r, score from temp_impression i
  join userrule u on u.userid=i.userid) on r=rule
group by rule order by rule;

-- Score each week of trial
select rule, week, nvl(avg(score), 0) avgscore, nvl(median(score), 0) medscore, nvl(stddev(score), 0) stdscore
from (select r.rule rule, w.rule week from temp_rule r, temp_rule w
  where w.rule between 1 and 6) left join (
  select getweek(i.created) w, r, score from temp_impression i
  join userrule u on u.userid=i.userid) on r=rule and w=week
group by rule, week order by rule, week;
