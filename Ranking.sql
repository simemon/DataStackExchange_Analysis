#Ranking of a user using UserId
#Example: userId = 5

select rownumber as Ranking from (select Id, @rowno := @rowno + 1 as rownumber, reputation from users, (select @rowno := 0) r
order by reputation desc) r1 where id = 5
