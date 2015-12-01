#Ranking of a user using UserId
#Example: userId = 5

select rownumber as Ranking from (select Id, @rowno := @rowno + 1 as rownumber, reputation from users, (select @rowno := 0) r
order by reputation desc) r1 where id = 5


#Expert (Top Users) by tags 
#Example: TagId = 1 and keep limit to 5 users

select Repute, DisplayName from (
select sum(Rep) as Repute,OwnerUserId from (
(select sum(Score*10) as Rep, P.OwnerUserId  from posts as P, posttags as PT
where
PostTypeId = 2 and P.ParentId = PT.PostId and PT.TagId = 1
group by OwnerUserId
)
union all
(select sum(Score*5) as Rep, P.OwnerUserId  from posts as P, posttags as PT
where
PostTypeId = 1 and P.Id = PT.PostId and PT.TagId = 1
group by P.OwnerUserId
)
union all
(select sum(15) as Rep,P.OwnerUserId from posts as P where
P.PosttypeId = 1  and AcceptedAnswerId != 0
and AcceptedAnswerId in  (select id from posts where PostTypeId = 2) and Id = any(select PostId from posttags where TagId  = 1)
group by P.OwnerUserId)
) T
group by OwnerUserId
order by Repute desc
)T1, users as U
where OwnerUserId = U.Id
limit 5

#Top 5 tags overall (Not Related with any particular user at all)

select s,tagName from (
(select sum(score) as s, T.tagName from posts as P, posttags as PT, tags as T where
P.id = PT.PostId and T.id = PT.TagId
group by PT.tagid)
) t
order by s desc
limit 5


#Top Posts according to Tags
#TagId = 1

SELECT
    P.Title, count(VoteTypeId) as counter
FROM
    votes as V, posts as P
where VoteTypeId = 2 and V.PostId = P.Id and postId in

 (select PostId from posttags where tagid = 1)
group by postid
order by counter desc
limit 5



#User performance over the time by tags
# Example: UserId = 5, TagId = 1

select Rep, date_format(CreateDate, '%M %Y') as CDate from (
(select Score*10 as Rep, P.CreationDate as CreateDate  from posts as P, posttags as PT
where
OwnerUserId = 5 and PostTypeId = 2 and P.ParentId = PT.PostId and PT.TagId = 1)
union all
(select Score*5 as Rep, P.CreationDate as CreateDate  from posts as P, posttags as PT
where
OwnerUserId = 5 and PostTypeId = 1 and P.Id = PT.PostId and PT.TagId = 1)
union all
(select 15 as Rep, P.CreationDate as CreateDate from posts as P where
P.PosttypeId = 1  and AcceptedAnswerId != 0
and AcceptedAnswerId in  (select id from posts where OwnerUserId = 5 and
PostTypeId = 2) and Id = any(select PostId from posttags where TagId  = 1))
) t
group by Year(CreateDate), Month(CreateDate)
order by Year(CreateDate), Month(CreateDate)



#User performance from the beginning (Generic)
#Example: UserId = 5

select (score * 10) as Rep,CreationDate from posts where
PostTypeId = 2 and OwnerUserId = 5
union
select (score * 5),CreationDate from posts where
PostTypeId = 1 and OwnerUserId = 5
union
select 15,CreationDate from posts where
AcceptedAnswerId in (select id from posts where OwnerUserId = 5)
order by CreationDate desc
 

# My Top 5 Tags (Tagname, TagId) with Reputation
#Example: UserId = 5

select sum(Rep) as Repute, TagName, Id from
(

(select sum(Score*10) as Rep, T.TagName, T.id  from posts as P, posttags as PT, tags as T
where
OwnerUserId = 5 and PostTypeId = 2 and P.ParentId = PT.PostId and PT.TagId = T.Id
group by PT.TagId)

union all
(select sum(score * 5) as Rep, T.TagName, T.id from posts as P, posttags as PT,
tags as T
where
PostTypeId = 1 and OwnerUserId = 5 and P.id = PT.PostId and PT.TagId = T.Id
group by T.TagName)

union all
(select sum(15) as Rep, T.TagName, T.id from posts as P, posttags as PT,
tags as T where
AcceptedAnswerId in (select P.id from posts as P where OwnerUserId = 5)
and P.id = PT.PostId and PT.TagId = T.Id
group by T.TagName)
) t
group by TagName
order by Repute desc
limit 5


#Tag Performance Over the time (for Dashboard)
#Example: Plotting

select sum(score) as S, date_format(P.CreationDate, '%M %Y') as CreateDate from posts as P, posttags as PT
where PT.TagId = (select Id from tags where TagName = 'plotting')
and PT.PostId = P.Id
group by Year(CreationDate), Month(CreationDate)
order by Year(CreationDate), Month(CreationDate)



#Rising Stars (Top 5) by Tag (last 1 year)
#Example TagId = 1

select Repute, DisplayName from (
select sum(Rep) as Repute,OwnerUserId from (
(select sum(Score*10) as Rep, P.OwnerUserId  from posts as P, posttags as PT
where
PostTypeId = 2 and P.ParentId = PT.PostId and PT.TagId = 1
and DATE_SUB(CURDATE(),INTERVAL 365 DAY) <= P.CreationDate
group by OwnerUserId
)
union all
(select sum(Score*5) as Rep, P.OwnerUserId  from posts as P, posttags as PT
where
PostTypeId = 1 and P.Id = PT.PostId and PT.TagId = 1
and DATE_SUB(CURDATE(),INTERVAL 365 DAY) <= P.CreationDate
group by P.OwnerUserId
)
union all
(select sum(15) as Rep,P.OwnerUserId from posts as P where
P.PosttypeId = 1  and AcceptedAnswerId != 0
and AcceptedAnswerId in  (select id from posts where PostTypeId = 2) and Id = any(select PostId from posttags where TagId  = 1)
and DATE_SUB(CURDATE(),INTERVAL 365 DAY) <= P.CreationDate
group by P.OwnerUserId)
) T
group by OwnerUserId
order by Repute desc
) T1, users as U
where U.id = OwnerUserId
limit 5


# Accepted Answer Percentage Rate:
# Owner User ID = 5

select
    (CAST(count(a.Id) as decimal) / (select count(*) from posts WHERE OwnerUserId = 5 AND PostTypeId = 2) * 100) as AcceptPerc
from
    posts q
  INNER JOIN
    posts a ON q.AcceptedAnswerId = a.Id
where
    a.OwnerUserId = 5
  and
    a.PostTypeId = 2

