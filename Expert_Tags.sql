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