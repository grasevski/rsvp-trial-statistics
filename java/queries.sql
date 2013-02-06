--click
select score, count(*) numClick from temp_click x
join temp_user u on u.userid=x.userid
where gender = ? and getweek(created) = ?
group by score order by score;

--kiss
select score, count(*) numKiss from temp_kiss x
join temp_user u on u.userid=x.userid
join clickscores on u=x.userid and t=x.targetuserid and c < created
where gender = ? and getweek(created) = ?
group by score order by score;

--kiss_t
select score, count(*) numKiss_t from temp_kiss x
join temp_user u on u.userid=x.userid
join clickscores on u=x.userid and t=x.targetuserid and c < created
where gender = ? and getweek(created) = ? and positivereply = 1
group by score order by score;

--channel
select score, count(*) numChannel from temp_channel x
join temp_user u on u.userid=x.userid
join clickscores on u=x.userid and t=x.targetuserid and c < created
where gender = ? and getweek(created) = ?
group by score order by score;
