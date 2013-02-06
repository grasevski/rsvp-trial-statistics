--uniqimpression
select score, count(*) uniqimpression from
(select distinct r, x.userid, targetuserid, score, getweek(created) week
  from temp_impression x join userrule u on u.userid=x.userid)
where r = ? and week = ?
group by score order by score;

--uniqclick
select score, count(*) uniqclick from
(select distinct r, x.userid, targetuserid, score, getweek(created) week
  from temp_click x join userrule u on u.userid=x.userid)
where r = ? and week = ?
group by score order by score;

--numKiss
select score, count(*) numKiss from temp_kiss x
join clickscore on u=x.userid and t=x.targetuserid and c < created
join userrule u on u.userid=x.userid
where r = ? and getweek(created) = ?
group by score order by score;

--numKiss_t
select score, count(*) numKiss_t from temp_kiss x
join clickscore on u=x.userid and t=x.targetuserid and c < created
join userrule u on u.userid=x.userid
where r = ? and getweek(created) = ? and positivereply = 1
group by score order by score;

--numChannel
select score, count(*) numChannel from temp_channel x
join clickscore on u=x.userid and t=x.targetuserid and c < created
join userrule u on u.userid=x.userid
where r = ? and getweek(created) = ?
group by score order by score;
