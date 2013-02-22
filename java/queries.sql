--click
select gender, getweek(x.created), r, score, count(*)
from temp_click x join userrule u on u.userid=x.userid
group by gender, getweek(x.created), r, score
order by gender, getweek(x.created), r, score;

--kiss
select gender, getweek(x.created), r, score, count(*)
from temp_kiss x join userrule u on u.userid=x.userid
join clickscore on u=x.userid and t=x.targetuserid
where c < x.created
group by gender, getweek(x.created), r, score
order by gender, getweek(x.created), r, score;

--kiss_t
select gender, getweek(x.created), r, score, count(*)
from temp_kiss x join userrule u on u.userid=x.userid
join clickscore on u=x.userid and t=x.targetuserid
where c < x.created and positivereply = 1
group by gender, getweek(x.created), r, score
order by gender, getweek(x.created), r, score;

--channel
select gender, getweek(x.created), r, score, count(*)
from temp_channel x join userrule u on u.userid=x.userid
join clickscore on u=x.userid and t=x.targetuserid
where c < x.created
group by gender, getweek(x.created), r, score
order by gender, getweek(x.created), r, score;

--impression
select gender, getweek(x.created), r, score, count(*)
from temp_impression x join userrule u on u.userid=x.userid
group by gender, getweek(x.created), r, score
order by gender, getweek(x.created), r, score;
