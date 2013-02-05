-- Global constants
def groupings='rule, week, gender, placement'

-- #recommendations generated

def measures='count(r) generated'
def fields='r, created, u1.gender g'
def tbl=temp_recom
def aux=''
def cond=''
def joins='r=rule and getweek(created)=week and g=gender'
def grp=''

@@query.sql

-- #recommendations delivered (impressions)

def measures='count(r) delivered'
def fields='&fields, placement p'
def tbl=temp_impression
def joins='&joins and p=placement'

@@query.sql

-- #recommendations clicked

def measures='count(r) clicked'
def tbl=temp_click

@@query.sql

-- #slice kisses

def measures='count(r) kisses'
def fields='r, created, u1.gender g'
def tbl=temp_kiss
def joins='r=rule and getweek(created) = week and g=gender'

@@query.sql

-- #positive slice kisses

def measures='count(r) kisses_t'
def cond='and positivereply = 1'

@@query.sql

-- #kisses for users to whom recommendations was delivered

def measures='count(r) recommendeekisses'
def cond='and u1.isrecommendee = 1'

@@query.sql

-- #positive kisses for users to whom recommendations was delivered

def measures='count(r) recommendeekisses_t'
def cond='&cond and positivereply = 1'

@@query.sql

-- #kisses from recommendations (after clicks)

def measures='count(r) recommendedkisses'
def fields='&fields, placement p'
def aux='join temp_unique_click y on y.userid=x.userid and y.targetuserid=x.targetuserid and c < created'
def cond=''
def joins='&joins and p=placement'

@@query.sql

-- #positive kisses from recommendations (after clicks)

def measures='count(r) recommendedkisses_t'
def cond='and positivereply = 1'

@@query.sql

-- #slice channels

def measures='count(r) channels'
def fields='r, created, u1.gender g'
def tbl=temp_channel
def aux=''
def cond=''
def joins='r=rule and getweek(created) = week and g=gender'

@@query.sql

-- #channels for users to whom recommendations was delivered

def measures='count(r) recommendeechannels'
def cond='and u1.isrecommendee = 1'

@@query.sql

-- #channels from recommendations (after clicks)

def measures='count(r) recommendedchannels'
def fields='&fields, placement p'
def aux='join temp_unique_click y on y.userid=x.userid and y.targetuserid=x.targetuserid and c < created'
def cond=''
def joins='&joins and p=placement'

@@query.sql

-- days from recommendation to impression

def measures='avg(t) avgr2i, median(t) medr2i, stddev(t) stdr2i'
def fields='x.userid, x.targetuserid, r, u1.gender g, interval2float(x.created-y.c) t, min(x.created) created'
def tbl=temp_impression
def aux='join temp_unique_recom y on y.userid=x.userid and y.targetuserid=x.targetuserid'
def cond='and y.c < x.created'
def grp='group by x.userid, x.targetuserid, r, u1.gender, x.created-y.c'
def joins='r=rule and getweek(created) = week and g=gender'

@@query.sql

-- days from impression to click

def measures='avg(t) avgi2c, median(t) medi2c, stddev(t) stdi2c'
def fields='x.userid, x.targetuserid, r, u1.gender g, y.placement p, interval2float(x.created-y.c) t, min(x.created) created'
def tbl=temp_click
def aux='join temp_unique_impression y on y.userid=x.userid and y.targetuserid=x.targetuserid and y.placement=x.placement'
def grp='group by x.userid, x.targetuserid, r, u1.gender, y.placement, x.created-y.c'
def joins='&joins and p=placement'

@@query.sql

-- days from click to contact sent

def measures='avg(t) avgc2k, median(t) medc2k, stddev(t) stdc2k'
def tbl=temp_kiss
def aux='join temp_unique_click y on y.userid=x.userid and y.targetuserid=x.targetuserid'

@@query.sql

-- days from contact sent to reply received
-- (only for not null replies)

def measures='avg(t) avgk2r, median(t) medk2r, stddev(t) stdk2r'
def fields='x.userid, x.targetuserid, r, created, u1.gender g, interval2float(replydate-created) t'
def aux=''
def cond='and positivereply is not null'
def grp=''
def joins='r=rule and getweek(created) = week and g=gender'

@@query.sql

-- days from contact sent to positive reply received
-- (only for not null replies)

def measures='avg(t) avgc2k_t, median(t) medc2k_t, stddev(t) stdc2k_t'
def cond='and positivereply = 1'

@@query.sql

-- days from impression to channel opened

def measures='avg(t) avgi2ch, median(t) medi2ch, stddev(t) stdi2ch'
def fields='x.userid, x.targetuserid, r, u1.gender g, placement p, interval2float(x.created-y.c) t, min(x.created) created'
def tbl=temp_channel
def aux='join temp_unique_impression y on y.userid=x.userid and y.targetuserid=x.targetuserid'
def cond='and y.c < x.created'
def grp='group by x.userid, x.targetuserid, r, u1.gender, placement, x.created-y.c'
def joins='&joins and p=placement'

@@query.sql
