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
