-- Global constants
def groupings='rule, week, gender, placement'

-- #recommendations generated

def measures='count(r) generated'
def fields='r, x.created created, u1.gender g'
def tbl=temp_recom
def aux=''
def cond=''
def joins='r=rule and getweek(created)=week and g=gender'

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
def fields='r, x.created created, u1.gender g'
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
def aux='join temp_unique_click y on y.userid=x.userid and y.targetuserid=x.targetuserid'
def cond='and c <= x.created'
def joins='&joins and p=placement'

@@query.sql

-- #positive kisses from recommendations (after clicks)

def measures='count(r) recommendedkisses_t'
def cond='&cond and positivereply = 1'

@@query.sql

-- #slice channels

def measures='count(r) channels'
def fields='r, x.created created, u1.gender g'
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
def aux='join temp_unique_click y on y.userid=x.userid and y.targetuserid=x.targetuserid'
def cond='and c <= x.created'
def joins='&joins and p=placement'

@@query.sql

-- days from recommendation to impression

def measures='nvl(avg(t), 0) avgr2i, nvl(median(t), 0) medr2i, nvl(stddev(t), 0) stdr2i'
def fields='x.userid, x.targetuserid, r, u1.gender g, x.placement p, interval2float(x.c-y.c) t, x.c created'
def tbl=temp_unique_impression
def aux='join temp_unique_recom y on y.userid=x.userid and y.targetuserid=x.targetuserid'
def cond='and y.c <= x.c'

@@query.sql

-- days from impression to click

def measures='nvl(avg(t), 0) avgi2c, nvl(median(t), 0) medi2c, nvl(stddev(t), 0) stdi2c'
def tbl=temp_unique_click
def aux='join temp_unique_impression y on y.userid=x.userid and y.targetuserid=x.targetuserid and y.placement=x.placement'

@@query.sql

-- days from click to contact sent

def measures='nvl(avg(t), 0) avgc2k, nvl(median(t), 0) medc2k, nvl(stddev(t), 0) stdc2k'
def fields='x.userid, x.targetuserid, r, u1.gender g, interval2float(x.c-y.c) t, x.c created'
def tbl=temp_unique_kiss
def aux='join temp_unique_click y on y.userid=x.userid and y.targetuserid=x.targetuserid'
def joins='r=rule and getweek(created) = week and g=gender'

@@query.sql

-- days from contact sent to reply received
-- (only for not null replies)

def measures='nvl(avg(t), 0) avgk2r, nvl(median(t), 0) medk2r, nvl(stddev(t), 0) stdk2r'
def fields='x.userid, x.targetuserid, r, x.created, u1.gender g, interval2float(replydate-x.created) t'
def tbl=temp_kiss
def aux=''
def cond='and positivereply is not null'

@@query.sql

-- days from contact sent to positive reply received
-- (only for not null replies)

def measures='nvl(avg(t), 0) avgk2r_t, nvl(median(t), 0) medk2r_t, nvl(stddev(t), 0) stdk2r_t'
def cond='and positivereply = 1'

@@query.sql

-- days from contact sent to negative reply received
-- (only for not null replies)

def measures='nvl(avg(t), 0) avgk2r_f, nvl(median(t), 0) medk2r_f, nvl(stddev(t), 0) stdk2r_f'
def cond='and positivereply = 0'

@@query.sql

-- days from impression to channel opened

def measures='nvl(avg(t), 0) avgi2ch, nvl(median(t), 0) medi2ch, nvl(stddev(t), 0) stdi2ch'
def fields='x.userid, x.targetuserid, r, u1.gender g, placement p, interval2float(x.c-y.c) t, x.c created'
def tbl=temp_unique_channel
def aux='join temp_unique_impression y on y.userid=x.userid and y.targetuserid=x.targetuserid'
def cond='and y.c <= x.c'
def joins='&joins and p=placement'

@@query.sql
