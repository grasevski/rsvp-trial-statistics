def groupings='rule, week, gender, placement'
def measures='count(r) delivered'
def fields='mod(x.userid, 10) r, created, u1.gender g, placement p'
def tbl=temp_impression
def aux=''
def cond=''
def joins='r=rule and getweek(created)=week and g=gender and p=placement'
def grp=''

@@query.sql

def measures='count(r) clicked'
def tbl=temp_click

@@query.sql

def measures='count(r) kisses'
def fields='mod(x.userid, 10) r, created, u1.gender g'
def tbl=temp_kiss
def joins='r=rule and getweek(created) = week and g=gender'

@@query.sql

def measures='count(r) kisses_t'
def cond='and positivereply = 1'

@@query.sql

def measures='count(r) recommendeekisses'
def cond='and u1.isrecommendee = 1'

@@query.sql

def measures='count(r) recommendeekisses_t'
def cond='&cond and positivereply = 1'

@@query.sql

def measures='count(r) recommendedkisses'
def fields='&fields, p'
def aux='join temp_unique_click y on y.userid=x.userid and y.targetuserid=x.targetuserid and c < created'
def cond=''
def joins='&joins and p=placement'

@@query.sql

def measures='count(r) recommendedkisses_t'
def cond='and positivereply = 1'

@@query.sql

def measures='count(r) channels'
def fields='mod(x.userid, 10) r, created, u1.gender g'
def tbl=temp_channel
def aux=''
def cond=''
def joins='r=rule and getweek(created) = week and g=gender'

@@query.sql

def measures='count(r) recommendeechannels'
def cond='and u1.isrecommendee = 1'

@@query.sql

def measures='count(r) recommendedchannels'
def fields='&fields, placement p'
def aux='join temp_unique_click y on y.userid=x.userid and y.targetuserid=x.targetuserid and c < created'
def cond=''
def joins='&joins and p=placement'

@@query.sql

def measures='avg(t) avgi2c, median(t) medi2c, stddev(t) stdi2c'
def fields='x.userid, x.targetuserid, mod(x.userid, 10) r, u1.gender g, placement p, interval2float(x.created-y.created) t, min(x.created) created'
def tbl=temp_click
def aux='join temp_unique_impression y on y.userid=x.userid and y.targetuserid=x.targetuserid'
def cond='and y.created < x.created'
def grp='group by x.userid, x.targetuserid, mod(x.userid, 10), u1.gender, placement, x.created-y.created'

@@query.sql

def measures='avg(t) avgc2k, median(t) medc2k, stddev(t) stdc2k'
def tbl=temp_kiss
def aux='join temp_unique_click y on y.userid=x.userid and y.targetuserid=x.targetuserid'

@@query.sql

def measures='avg(t) avgk2r, median(t) medk2r, stddev(t) stdk2r'
def fields='x.userid, x.targetuserid, mod(x.userid, 10) r, u1.gender g, interval2float(replydate-created) t'
def aux=''
def cond='and positivereply is not null'
def grp=''

@@query.sql

def measures='avg(t) avgc2k_t, median(t) medc2k_t, stddev(t) stdc2k_t'
def cond='and positivereply = 1'

@@query.sql

def measures='avg(t) avgi2ch, median(t) medi2ch, stddev(t) stdi2ch'
def fields='x.userid, x.targetuserid, mod(x.userid, 10) r, u1.gender g, placement p, interval2float(x.created-y.created) t, min(x.created) created'
def tbl=temp_channel
def aux='join temp_unique_impression y on y.userid=x.userid and y.targetuserid=x.targetuserid'
def cond='and y.created < x.created'
def grp='group by x.userid, x.targetuserid, mod(x.userid, 10), u1.gender, placement, x.created-y.created'

@@query.sql
