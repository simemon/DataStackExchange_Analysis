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
