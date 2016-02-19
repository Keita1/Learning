-- Question 1

select date_trunc('day', tmstmp) as date, count(*) as number_of_reg from registrations
group by date_trunc('day', tmstmp)
order by date_trunc('day', tmstmp)
limit 10;


-- Question 2

select date_part('dow', tmstmp) , count(*) as number_of_reg from registrations
group by date_part('dow', tmstmp)
order by count(*) desc
limit 1;

-- Question 3
select optout.userid from optout inner join logins on logins.userid = optout.userid
where logins.tmstmp <= date(2014-08-14);

select distinct optout.userid from optout inner join logins on logins.userid = optout.userid
where logins.tmstmp <= to_timestamp('2014-08-14', 'yyyy-mm-dd')
and logins.tmstmp > to_timestamp('2014-08-07', 'yyyy-mm-dd');

-- Question 4

select a.userid,  count(*)
from registrations a, registrations b
where date_trunc('day', a.tmstmp) = date_trunc('day', b.tmstmp)
group by a.userid;

-- Question 5

select type, test_group.userid, count(*)
from logins inner join test_group
on logins.userid = test_group.userid
where test_group.grp = 'A'
group by type, test_group.userid
order by userid;

create temporary table logins_by_type as (
  select userid, sum(case when type = 'web' then 1 else 0 end) as web_count,
  sum(case when type = 'mobile' then 1 else 0 end) as mobile_count
  from logins
  group by userid
);


create temporary table mobile_users as (
  select userid
  from logins_by_type
  where web_count < mobile_count
);

select distinct test_group.userid
from test_group
inner join mobile_users
on mobile_users.userid = test_group.userid
where test_group.grp = 'A';

-- Question 6

create temporary table outgoing as (
  select sender, count(*) as outgoing_count
  from messages
  group by sender
);

create temporary table incoming as (
  select recipient, count(*) as incoming_count
  from messages
  group by recipient
);

select sender as userid, (outgoing.outgoing_count + incoming.incoming_count) as total_msg
from outgoing
full outer join incoming
on outgoing.sender = incoming.recipient;
