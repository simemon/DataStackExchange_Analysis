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