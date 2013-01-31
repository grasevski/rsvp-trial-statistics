create or replace view rg as
select r.rule rule, w.rule week, boolid+134 gender, p.rule placement
from temp_rule r, temp_rule w, temp_bool, temp_rule p
where w between 1 and 6 and p < 4;

create or replace view temp_unique_impression as
select userid, targetuserid, p, min(created) c
from temp_impression group by userid, targetuserid, p;

create or replace view temp_unique_click as
select userid, targetuserid, p, min(created) c
from temp_click group by userid, targetuserid, p;

create or replace function getweek(t in timestamp) return integer as
begin
  return trunc(extract(day from t - &trial_start_date)/7) + 1;
end;
.
/

create or replace function interval2float
(t in interval day to second) return float as begin
  return extract(day from t) + (extract(hour from t)
      + (extract(minute from t) + extract(second from t)/60)/60)/24;
end;
.
/


def groupings='rule, week, gender, placement'
def measures='count(r) delivered'
def fields='u1.rule r, created, u1.gender g, p'
def tbl=temp_impression
def aux=''
def cond=''
def joins='r=rule and getweek(created)=week and g=gender and p=placement'
def grp=''

@query.sql

def measures='count(r) clicked'
def tbl=temp_click

@query.sql

def measures='count(r) kisses'
def fields='u1.rule r, created, u1.gender g'
def tbl=temp_kiss
def joins='r=rule and getweek(created) = week and g=gender'

@query.sql

def measures='count(r) kisses_t'
def cond='and positivereply = 1'

@query.sql

def measures='count(r) recommendeekisses'
def cond='and u1.isrecommendee = 1'

@query.sql

def measures='count(r) recommendeekisses_t'
def cond='&cond and positivereply = 1'

@query.sql

def measures='count(r) recommendedkisses'
def fields='&fields, p'
def aux='join temp_unique_click y on y.userid=x.userid and y.targetuserid=x.targetuserid and c < created'
def cond=''
def joins='&joins and p=placement'

@query.sql

def measures='count(r) recommendedkisses_t'
def cond='and positivereply = 1'

@query.sql

def measures='count(r) channels'
def fields='u1.rule r, created, u1.gender g'
def tbl=temp_channel
def aux=''
def cond=''
def joins='r=rule and getweek(created) = week and g=gender'

@query.sql

def measures='count(r) recommendeechannels'
def cond='and u1.isrecommendee = 1'

@query.sql

def measures='count(r) recommendedchannels'
def fields='&fields, x.p p'
def aux='join temp_unique_click y on y.userid=x.userid and y.targetuserid=x.targetuserid and c < created'
def cond=''
def joins='&joins and p=placement'

@query.sql

def measures='avg(t) avgi2c, median(t) medi2c, stddev(t) stdi2c'
def fields='x.userid, x.targetuserid, u1.rule r, u1.gender g, p, interval2float(x.created-y.created) t, min(x.created) created'
def tbl=temp_click
def aux='join temp_unique_impression y on y.userid=x.userid and y.targetuserid=x.targetuserid'
def cond='and y.created < x.created group by x.userid, x.targetuserid, u1.rule, u1.gender, p, x.created-y.created'

@query.sql

def measures='avg(t) avgc2k, median(t) medc2k, stddev(t) stdc2k'
def tbl=temp_kiss
def aux='join temp_unique_impression y on y.userid=x.userid and y.targetuserid=x.targetuserid'

@query.sql

def measures='avg(t) avgc2k_r, median(t) medc2k_r, stddev(t) stdc2k_r'
def cond='&cond and positivereply is not null'

@query.sql

def measures='avg(t) avgc2k_t, median(t) medc2k_t, stddev(t) stdc2k_t'
def cond='and y.created < x.created and positivereply = 1'

@query.sql

def measures='avg(t) avgi2ch, median(t) medi2ch, stddev(t) stdi2ch'
def tbl=temp_channel
def aux='join temp_unique_impression y on y.userid=x.userid and y.targetuserid=x.targetuserid'
def cond='and y.created < x.created'

@query.sql
