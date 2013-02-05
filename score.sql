select rule, avg(score) avgscore, median(score) medscore, stddev(score) stdscore
from temp_impression i join userrule u on u.userid=i.userid
group by rule;

select getweek(created) week, rule, avg(score) avgscore, median(score) medscore, stddev(score) stdscore
from temp_impression i join userrule u on u.userid=i.userid
group by getweek(created), rule;
