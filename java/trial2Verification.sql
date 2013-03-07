---================== RESULTS sheet =======================================
--- NOTE: decided (27 feb 2013) not to exclude kisses from other methods (0 and 3) because
--- - we have only two group of users to analyse: those who are involved in method's recommendations (u1 and u2)
---   and thos outside recommendations. It does not matter if other methods provided recommendations to these users or recommended them
---   we only want to know how recommendation and non recommendations interaction are different FOR GIVEN METHOD
--- trial 2 verification 
define trial_start_date=to_date('30apr12');
-- 11 june 2012
define trial_end_date=to_date('12jun12');
define interval_days=28;
define max_dt_rank=200;
define max_final_rank=50;
-- this is 2 weeks after trial for result collection
define currenttime=to_date('27jun12');

define pos_reply_table=ALFREDK.POSITIVE_REPLIES;
define reply_table=RSVP_0612.KISSREPLYMESSAGE;
define account_table=RSVP_0612.UA_USERACCOUNT;
define kiss_table=RSVP_0612.SR_KISS;
define channel_table=RSVP_0612.SR_channel;
define view_table=RSVP_0612.USERVIEW;
define impressions=RSVP_0612.RecommendationImpression;
define clicks=RSVP_0612.RecommendationClick;
define all_recom=RSVP_0612_CRC.CRC_ALL_RECOMMENDATIONS;

define u1_gender=(134);
define u2_gender=(135);
--- this is only for display, manual adjustment is required to select feature
-- isRecommendee
define u1_feature=1;
-- isCandidate
define u2_feature=1;

--- recom table for 0-3 is impression table, for 4-9 is recommendation table
define method=7;
define recom_table=RSVP_0612_CRC.CRC_ALL_RECOMMENDATIONS;
define recom_date_col=DATERECOMMENDED;
define recom_u1=userid;
define recom_u2=candidate_userid;
define method_col=methodnumber;

 create table temp_ks_excl as (
  select initiatinguserid, targetuserid, created from &kiss_table ks
  where created between &trial_start_date and &trial_end_date
  and (initiatinguserid, targetuserid) in 
    (select userid, targetuserid from &clicks cl
    where cl.created between &trial_start_date and &trial_end_date
    and cl.created <= ks.created
    and mod(userid, 10) = &method and rule <> &method)
  and (initiatinguserid, targetuserid) not in 
    (select userid, targetuserid from &clicks cl
    where cl.created between &trial_start_date and &trial_end_date
    and cl.created <= ks.created
    and mod(userid, 10) = &method and rule = &method));
create index temp_ks_exclx1 on temp_ks_excl(initiatinguserid);
create index temp_ks_exclx2 on temp_ks_excl(targetuserid);

 create table temp_kisses as (
  select initiatinguserid, targetuserid, replymessageid, created,
  ac1.gender_prid u1_gender_prid, ac2.gender_prid u2_gender_prid
  from &kiss_table ks, &account_table ac1, &account_table ac2
  where initiatinguserid=ac1.userid and targetuserid=ac2.userid
  and ac1.hlastAction > trunc(&trial_start_date-28)
  and ac2.hlastAction > trunc(&trial_start_date-28)
  and ac1.creationdate < &trial_end_date
  and ac2.creationdate < &trial_end_date
  and created between &trial_start_date and &trial_end_date
  and mod(initiatinguserid, 10)=&method
  and (initiatinguserid, targetuserid) not in (select initiatinguserid, targetuserid from temp_ks_excl));

drop table temp_ks_excl purge;

create table temp_recommend as (
  select &recom_u1, &recom_u2, min(&recom_date_col) &recom_date_col, &method_col  
  from &recom_table where &recom_date_col between &trial_start_date and &trial_end_date 
  and &method_col=&method and mod(&recom_u1,10)=&method group by &recom_u1, &recom_u2, &method_col
);
create index temp_recommend_x1 on temp_recommend(&recom_u1);
create index temp_recommend_x2 on temp_recommend(&recom_u2);

--- U1 to U2 (LHS2RHS), LHS, RHS are recommendation pair only
select &u1_gender, &u2_gender, &u1_feature, &u2_feature, 
		nLHS_LHS2RHS, nRHS_LHS2RHS, LHS2RHS, nLHS_LHS2RHS_T, nRHS_LHS2RHS_T, LHS2RHS_T from
 (select count(unique initiatinguserid) nLHS_LHS2RHS, 
  count(unique targetuserid) nRHS_LHS2RHS,
  count(*) LHS2RHS from temp_kisses ks
	where u1_gender_prid in &u1_gender and u2_gender_prid in &u2_gender
	and (initiatinguserid, targetuserid) in (select &recom_u1, &recom_u2 
		from temp_recommend rec where ks.created >= rec.&recom_date_col)),
 (select count(unique initiatinguserid) nLHS_LHS2RHS_T, 
  count(unique targetuserid) nRHS_LHS2RHS_T,
  count(*) LHS2RHS_T from temp_kisses ks
	where u1_gender_prid in &u1_gender and u2_gender_prid in &u2_gender
	and (initiatinguserid, targetuserid) in (select &recom_u1, &recom_u2 
		from temp_recommend rec where ks.created >= rec.&recom_date_col)
		and replymessageid in (select replymessageid from &pos_reply_table));
   
-- u1 to all (LHS2Q), 
---- LHS are users to whom recom was delivered before the kiss, otherwise it might be that that user had kisses
--- before method delivered recom, but there was something different about that user, e.g. was not active before or new
---- so at that time 0 or 3 could have had recom for the user
-- Q are all active users)
select &u1_gender, &u2_gender, &u1_feature, &u2_feature, 
		nLHS_LHS2Q, nQ_LHS2Q, LHS2Q, nLHS_LHS2Q_T, nQ_LHS2Q_T, LHS2Q_T from
 (select count(unique initiatinguserid) nLHS_LHS2Q,
  count(unique targetuserid) nQ_LHS2Q,
  count(*) LHS2Q from temp_kisses ks
	where u1_gender_prid in &u1_gender and u2_gender_prid in &u2_gender
 	and initiatinguserid in (select &recom_u1
		from temp_recommend rec where ks.created >= rec.&recom_date_col)),
 (select count(unique initiatinguserid) nLHS_LHS2Q_T,
  count(unique targetuserid) nQ_LHS2Q_T, 
  count(*) LHS2Q_T from temp_kisses ks
	where u1_gender_prid in &u1_gender and u2_gender_prid in &u2_gender
   and replymessageid in (select replymessageid from &pos_reply_table)
 	and initiatinguserid in (select &recom_u1
		from temp_recommend rec where ks.created >= rec.&recom_date_col));
   
--- all to U2 (P2RHS)
--- P are active slice users, filtering done in temp_kisses
--- RHS are active users who were candidates of recom from this method after recom were delivered
select &u1_gender, &u2_gender, &u1_feature, &u2_feature, 
		nP_P2RHS, nRHS_P2RHS, P2RHS, nP_P2RHS_T, nRHS_P2RHS_T, P2RHS_T from
 (select count(unique initiatinguserid) nP_P2RHS,
  count(unique targetuserid) nRHS_P2RHS, 
  count(*) P2RHS from temp_kisses ks
	where u1_gender_prid in &u1_gender and u2_gender_prid in &u2_gender
 	and targetuserid in (select &recom_u2
		from temp_recommend rec where ks.created >= rec.&recom_date_col)),
 (select count(unique initiatinguserid) nP_P2RHS_T, 
  count(unique targetuserid) nRHS_P2RHS_T,
  count(*) P2RHS_T from temp_kisses ks
	where u1_gender_prid in &u1_gender and u2_gender_prid in &u2_gender
   and replymessageid in (select replymessageid from &pos_reply_table)
 	and targetuserid in (select &recom_u2
		from temp_recommend rec where ks.created >= rec.&recom_date_col));

-- U1, U2 in user pool
--- NOTE: user pool definition will change if LHS or RHS changes,
select &u1_gender, &u2_gender, &u1_feature, &u2_feature, 
		nLHS_POOL, nRHS_POOL from
 (select count(*) nLHS_POOL from &account_table 
	where GENDER_PRID in &u1_gender and hlastAction > trunc(&trial_start_date-28)
   and mod(userid, 10)=&method and creationdate < &trial_end_date
   and userid in (select &recom_u1 from temp_recommend)),
 (select count(*) nRHS_POOL from &account_table 
	where GENDER_PRID in &u2_gender and hlastAction > trunc(&trial_start_date-28)
   and creationdate < &trial_end_date
   and userid in (select &recom_u2 from temp_recommend));

drop table temp_recommend purge;
drop table temp_kisses purge;

------------------------- SUMMARY sheet verification

define trial_start_date=to_date('30apr12');
define trial_end_date=to_date('12jun12');
define pos_reply_table=ALFREDK.POSITIVE_REPLIES;
define reply_table=RSVP_0612.KISSREPLYMESSAGE;
define account_table=RSVP_0612.UA_USERACCOUNT;
define kiss_table=RSVP_0612.SR_KISS;
define channel_table=RSVP_0612.SR_channel;
define all_recom=RSVP_0612_CRC.CRC_ALL_RECOMMENDATIONS;
define impressions=RSVP_0612.RecommendationImpression;
define clicks=RSVP_0612.RecommendationClick;
define u1_gender=(134);
define u2_gender=(135);
define week_date_from=to_date('30apr12');
define week_date_to=to_date('07may12');
define methodnumber=7;

 create table temp_ks_excl as (
  select initiatinguserid, targetuserid, created from &kiss_table ks
  where created between &week_date_from and &week_date_to
  and (initiatinguserid, targetuserid) in 
    (select userid, targetuserid from &clicks cl
    where cl.created between &week_date_from and &week_date_to
    and cl.created <= ks.created
    and mod(userid, 10) = &methodnumber and rule <> &methodnumber)
  and (initiatinguserid, targetuserid) not in 
    (select userid, targetuserid from &clicks cl
    where cl.created between &week_date_from and &week_date_to
    and cl.created <= ks.created
    and mod(userid, 10) = &methodnumber and rule = &methodnumber));
create index temp_ks_exclx1 on temp_ks_excl(initiatinguserid);
create index temp_ks_exclx2 on temp_ks_excl(targetuserid);

 create table temp_kisses as (
  select initiatinguserid, targetuserid, replymessageid, created, replydate,
  ac1.gender_prid u1_gender_prid, ac2.gender_prid u2_gender_prid
  from &kiss_table ks, &account_table ac1, &account_table ac2
  where initiatinguserid=ac1.userid and targetuserid=ac2.userid
  and ac1.hlastAction > trunc(&trial_start_date-28)
  and ac2.hlastAction > trunc(&trial_start_date-28)
  and ac1.creationdate < &trial_end_date
  and ac2.creationdate < &trial_end_date
  and created between &week_date_from and &week_date_to
  and mod(initiatinguserid, 10)=&methodnumber
  and (initiatinguserid, targetuserid) not in (select initiatinguserid, targetuserid from temp_ks_excl));

--- store recom users
create table temp_recommend_users as (
------ for 4-9
  select * from &all_recom 
  where mod(userid,10)=&methodnumber
  and userid in (select userid from &account_table where gender_prid in &u1_gender)
  and candidate_userid in (select userid from &account_table where gender_prid in &u2_gender)
  and daterecommended between &week_date_from and &week_date_to
----- for 0-3
--  select unique userid from &impressions 
--  where mod(userid,10)=rule
--  and userid in (select userid from &account_table where gender_prid in &u1_gender)
--  and targetuserid in (select userid from &account_table where gender_prid in &u2_gender)
--  and created between &week_date_from and &week_date_to
--  and rule=&methodnumber
);

--- kisses
select count(*) from temp_kisses where u1_gender_prid in &u1_gender and u2_gender_prid in &u2_gender;
select count(*) from temp_kisses where u1_gender_prid in &u1_gender and u2_gender_prid in &u2_gender 
and replymessageid is not null and replymessageid in (select id from &reply_table where positivereply=1);

--- recommendee kisses
select count(*) from temp_kisses where u1_gender_prid in &u1_gender and u2_gender_prid in &u2_gender
and initiatinguserid in (select userid from temp_recommend_users);
select count(*) from temp_kisses where u1_gender_prid in &u1_gender and u2_gender_prid in &u2_gender 
and initiatinguserid in (select userid from temp_recommend_users)
and replymessageid is not null and replymessageid in (select id from &reply_table where positivereply=1);

--- recommended kisses
select count(*) from 
  (select ks.*, row_number() over (partition by initiatinguserid, targetuserid, ks_created order by cl_created desc) position from 
    (select ks.initiatinguserid, ks.targetuserid, ks.created ks_created, cl.created cl_created, cl.placement 
    from temp_kisses ks, &clicks cl
    where cl.created between &week_date_from and &week_date_to
    and mod(userid,10)=&methodnumber
    and mod(userid,10)=rule
    and u1_gender_prid in &u1_gender and u2_gender_prid in &u2_gender
    and userid=initiatinguserid and cl.targetuserid=ks.targetuserid
    and cl.created <= ks.created) ks ) 
where position=1 group by placement order by placement;

select count(*) from 
  (select ks.*, row_number() over (partition by initiatinguserid, targetuserid, ks_created order by cl_created desc) position from 
    (select ks.initiatinguserid, ks.targetuserid, ks.replymessageid, ks.created ks_created, cl.created cl_created, cl.placement 
    from temp_kisses ks, &clicks cl
    where cl.created between &week_date_from and &week_date_to
    and mod(userid,10)=&methodnumber
    and mod(userid,10)=rule
    and u1_gender_prid in &u1_gender and u2_gender_prid in &u2_gender
    and userid=initiatinguserid and cl.targetuserid=ks.targetuserid
    and cl.created <= ks.created) ks ) 
where position=1
and replymessageid is not null and replymessageid in (select id from &reply_table where positivereply=1)
 group by placement order by placement;

--- channels will be similar


------ timimg verification ---------------
--- to speed it up we need to create temp tables
create table temp_recommend as (
  select userid, candidate_userid, min(daterecommended) daterecommended from &all_recom 
  where mod(userid,10)=&methodnumber
  and userid in (select userid from &account_table where gender_prid in &u1_gender)
  and candidate_userid in (select userid from &account_table where gender_prid in &u2_gender)
  and daterecommended between &week_date_from and &week_date_to
  group by userid, candidate_userid
);
create index temp_recommend_x1 on temp_recommend(userid);
create index temp_recommend_x2 on temp_recommend(candidate_userid);
create index temp_recommend_x3 on temp_recommend(daterecommended);

create table temp_impr as (
  select userid, targetuserid, placement, min(created) created from &impressions 
  where mod(userid,10)=&methodnumber and rule=&methodnumber
  and userid in (select userid from &account_table where gender_prid in &u1_gender)
  and targetuserid in (select userid from &account_table where gender_prid in &u2_gender)
  and created between &week_date_from and &week_date_to
  group by userid, targetuserid, placement
);
create index temp_impr_x1 on temp_impr(userid);
create index temp_impr_x2 on temp_impr(targetuserid);
create index temp_impr_x3 on temp_impr(created);

create table temp_cl as (
  select userid, targetuserid, placement, min(created) created from &clicks 
  where mod(userid,10)=&methodnumber and rule=&methodnumber
  and userid in (select userid from &account_table where gender_prid in &u1_gender)
  and targetuserid in (select userid from &account_table where gender_prid in &u2_gender)
  and created between &week_date_from and &week_date_to
  group by userid, targetuserid, placement
);
create index temp_cl_x1 on temp_cl(userid);
create index temp_cl_x2 on temp_cl(targetuserid);
create index temp_cl_x3 on temp_cl(created);

--- from recom to first impr
----- note: this will not inlcude 0-3, and will not include recommendations make on the last day of week, but this should not affect the result,as it is avg
select avg(extract(second from (created-daterecommended))
 + extract(minute from (created-daterecommended))*60
 + extract(hour from (created-daterecommended))*60*60
 + extract(day from (created-daterecommended))*24*60*60)/(24*60*60)
 timing FROM temp_recommend rec, temp_impr impr
 where rec.userid=impr.userid and rec.candidate_userid=impr.targetuserid
 and created >= daterecommended
group by placement order by placement;

--- from first impr to first click
select avg(extract(second from (cl.created-impr.created))
 + extract(minute from (cl.created-impr.created))*60
 + extract(hour from (cl.created-impr.created))*60*60
 + extract(day from (cl.created-impr.created))*24*60*60)/(24*60*60)
 timing FROM temp_cl cl, temp_impr impr
 where cl.userid=impr.userid and cl.targetuserid=impr.targetuserid
 and cl.created >= impr.created and cl.placement=impr.placement
group by cl.placement order by cl.placement;

--from first click to first kiss sent
create table temp_kisses1 as (
  select initiatinguserid, targetuserid, min(created) created from temp_kisses
  group by initiatinguserid, targetuserid
);
select avg(extract(second from (ks.created-cl.created))
 + extract(minute from (ks.created-cl.created))*60
 + extract(hour from (ks.created-cl.created))*60*60
 + extract(day from (ks.created-cl.created))*24*60*60)/(24*60*60)
 timing FROM temp_cl cl, temp_kisses1 ks
 where cl.userid=ks.initiatinguserid and cl.targetuserid=ks.targetuserid
 and cl.created <= ks.created
group by cl.placement order by cl.placement;

--- from kiss sent to any non null reply
select avg(extract(second from (replydate-created))
 + extract(minute from (replydate-created))*60
 + extract(hour from (replydate-created))*60*60
 + extract(day from (replydate-created))*24*60*60)/(24*60*60)
 timing FROM temp_kisses
 where replydate is not null;
 
--- from kiss sent to pos reply
select avg(extract(second from (replydate-created))
 + extract(minute from (replydate-created))*60
 + extract(hour from (replydate-created))*60*60
 + extract(day from (replydate-created))*24*60*60)/(24*60*60)
 timing FROM temp_kisses
 where replydate is not null
and replymessageid is not null and replymessageid in (select id from &reply_table where positivereply=1) ;
 
--- from kiss sent to neg reply
select avg(extract(second from (replydate-created))
 + extract(minute from (replydate-created))*60
 + extract(hour from (replydate-created))*60*60
 + extract(day from (replydate-created))*24*60*60)/(24*60*60)
 timing FROM temp_kisses
 where replydate is not null
and replymessageid is not null and replymessageid in (select id from &reply_table where positivereply=0) ;

--- from impr to first channel
---- since we are interested in channels after recom only, no need to exclude foreigh channels from the slice
 create table temp_ch as (
  select initiatinguserid, targetuserid, min(OPENDATE) OPENDATE
  from &channel_table ch, &account_table ac1, &account_table ac2
  where initiatinguserid=ac1.userid and targetuserid=ac2.userid
  and ac1.hlastAction > trunc(&trial_start_date-28)
  and ac2.hlastAction > trunc(&trial_start_date-28)
  and ac1.creationdate < &trial_end_date
  and ac2.creationdate < &trial_end_date
  and ac1.gender_prid in &u1_gender and ac2.gender_prid in &u2_gender
  and OPENDATE between &week_date_from and &week_date_to
  and mod(initiatinguserid, 10)=&methodnumber
  group by initiatinguserid, targetuserid);

select avg(extract(second from (ch.OPENDATE-cl.created))
 + extract(minute from (ch.OPENDATE-cl.created))*60
 + extract(hour from (ch.OPENDATE-cl.created))*60*60
 + extract(day from (ch.OPENDATE-cl.created))*24*60*60)/(24*60*60)
 timing FROM temp_cl cl, temp_ch ch
 where cl.userid=ch.initiatinguserid and cl.targetuserid=ch.targetuserid
 and cl.created <= ch.OPENDATE and OPENDATE is not null
group by cl.placement order by cl.placement;

drop table temp_ks_excl purge;
drop table temp_kscl purge;
drop table temp_kisses purge;
drop table temp_cl purge;
drop table temp_impr purge;
drop table temp_recommend purge;
drop table temp_kisses1 purge;
drop table temp_ch purge;

------------------------- SCORE verification

define trial_start_date=to_date('30apr12');
define trial_end_date=to_date('12jun12');
define pos_reply_table=ALFREDK.POSITIVE_REPLIES;
define reply_table=RSVP_0612.KISSREPLYMESSAGE;
define account_table=RSVP_0612.UA_USERACCOUNT;
define kiss_table=RSVP_0612.SR_KISS;
define channel_table=RSVP_0612.SR_channel;
define impressions=RSVP_0612.RecommendationImpression;
define clicks=RSVP_0612.RecommendationClick;
define u1_gender=(134);
define u2_gender=(135);
define week_date_from=to_date('30apr12');
define week_date_to=to_date('07may12');
define methodnumber=7;
define scorevalue=199;

--- impressions
select count(*) from &impressions 
where mod(userid,10)=rule
and userid in (select userid from &account_table where gender_prid in &u1_gender)
and targetuserid in (select userid from &account_table where gender_prid in &u2_gender)
and created between &week_date_from and &week_date_to
and rule=&methodnumber
and score=&scorevalue;

--- clicks
select count(*) from &clicks 
where mod(userid,10)=rule
and userid in (select userid from &account_table where gender_prid in &u1_gender)
and targetuserid in (select userid from &account_table where gender_prid in &u2_gender)
and created between &week_date_from and &week_date_to
and rule=&methodnumber
and score=&scorevalue;

--- kisses
create table temp_kscl as (
select ks.initiatinguserid, ks.targetuserid, ks.created ks_created, cl.created cl_created, cl.score 
  from &kiss_table ks, &clicks cl
  where cl.created between &week_date_from and &week_date_to
  and ks.created between &week_date_from and &week_date_to
  and mod(userid,10)=&methodnumber
  and mod(initiatinguserid,10)=&methodnumber
  and mod(userid,10)=rule
  and initiatinguserid in (select userid from &account_table where gender_prid in &u1_gender) 
  and ks.targetuserid in (select userid from &account_table where gender_prid in &u2_gender)
  and userid=initiatinguserid and cl.targetuserid=ks.targetuserid
  and cl.created <= ks.created
);

  select count(*) from 
  (select ks.*, row_number() over (partition by initiatinguserid, targetuserid, ks_created order by cl_created desc) position
  from temp_kscl ks) where position=1 and score=&scorevalue;

drop table temp_kscl purge;
drop table temp_recommend_users purge;

--- OR
select count(*) from 
  (select ks.*, row_number() over (partition by initiatinguserid, targetuserid, ks_created order by cl_created desc) position from 
    (select ks.initiatinguserid, ks.targetuserid, ks.created ks_created, cl.created cl_created, cl.score 
    from &kiss_table ks, &clicks cl
    where cl.created between &week_date_from and &week_date_to
    and ks.created between &week_date_from and &week_date_to
    and mod(userid,10)=&methodnumber
    and mod(initiatinguserid,10)=&methodnumber
    and mod(userid,10)=rule
    and initiatinguserid in (select userid from &account_table where gender_prid in &u1_gender) 
    and ks.targetuserid in (select userid from &account_table where gender_prid in &u2_gender)
    and userid=initiatinguserid and cl.targetuserid=ks.targetuserid
    and cl.created <= ks.created) ks ) 
where position=1 and score=&scorevalue;

--- pos kisses and channels will be similar
