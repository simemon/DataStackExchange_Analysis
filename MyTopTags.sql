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
