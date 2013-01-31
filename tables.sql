-- Temporary tables, containing the relevant subset of information
-- from the rsvp database

@@definitions.sql;

-- Delete existing tables
drop table temp_impression purge;
drop table temp_click purge;
drop table temp_kiss purge;
drop table temp_user purge;
drop table temp_bool purge;
drop table temp_rule purge;

-- Active trial users
create table temp_user (
  userid integer primary key,
  gender integer not null,
  rule integer not null,
  isrecommendee integer not null
);

-- Table of candidate users
create table temp_impression (
  targetuserid integer references temp_user(userid),
  rule integer,
  primary key (targetuserid, rule)
);

-- Recommendation clicks
create table temp_click (
  clickid integer primary key,
  initiatinguserid integer not null references temp_user(userid),
  targetuserid integer not null references temp_user(userid),
  created date not null
);

-- Kisses during the trial period
create table temp_kiss (
  kissid integer primary key,
  initiatinguserid integer not null references temp_user(userid),
  targetuserid integer not null references temp_user(userid),
  reply integer not null,
  created date not null
);

-- These tables are used to generate all combinations
create table temp_bool (boolid integer primary key);
create table temp_rule (rule integer primary key);

-- Used for gender, recommendee status, candidate status etc
insert into temp_bool values (0);
insert into temp_bool values (1);

-- A rule is a number between 0 and 9 inclusive
insert into temp_rule values (0);
insert into temp_rule values (1);
insert into temp_rule values (2);
insert into temp_rule values (3);
insert into temp_rule values (4);
insert into temp_rule values (5);
insert into temp_rule values (6);
insert into temp_rule values (7);
insert into temp_rule values (8);
insert into temp_rule values (9);
