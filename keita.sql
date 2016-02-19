Question 1

select count(userid), date_trunc('day', tmstmp) as date
from registrations
group by date_trunc('day', tmstmp)
order by date_trunc('day', tmstmp);


Question 2
select to_char(tmstmp, 'day'), count(to_char(tmstmp, 'day'))
from registrations
group by to_char(tmstmp, 'day')
order by count(to_char(tmstmp, 'day')) desc limit 1;

Question 3

select registrations.userid
from registrations
where registrations.userid not in
(select logins.userid from logins
where logins.tmstmp < '2014-08-14 00:00:00' and logins.tmstmp > '2014-08-07 00:00:00')

select registrations.userid 
from registrations
left join logins using (userid)
where (select logins.userid from logins
where logins.tmstmp < '2014-08-14 00:00:00' and logins.tmstmp > '2014-08-07 00:00:00') is null;
