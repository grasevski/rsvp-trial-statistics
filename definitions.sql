-- trial 2 definitions

define trial_start_date=to_date('30apr12')
-- 11 june 2012
define trial_end_date=to_date('12jun12')
define interval_days=28
define max_dt_rank=200
define max_final_rank=50
-- this is 2 weeks after trial for result collection
define currenttime=to_date('27jun12')

define positive_reply_table=RSVP_0612.CRC_POSITIVE_REPLIES
define reply_table=RSVP_0612.KISSREPLYMESSAGE
define account_table=RSVP_0612.UA_USERACCOUNT
define kiss_table=RSVP_0612.SR_KISS
define channel_table=RSVP_0612.SR_channel
define view_table=RSVP_0612.USERVIEW
define impressions=RSVP_0612.RecommendationImpression
define clicks=RSVP_0612.RecommendationClick
define all_recom=RSVP_0612_CRC.CRC_ALL_RECOMMENDATIONS
define no_recom=RSVP_0612_CRC.CRC_NO_RECOMMENDATIONS
define score_table=RSVP_0612_CRC.CRC_SCORES
define stats_table=RSVP_0612_CRC.CRC_OTHER_STATS
