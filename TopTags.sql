#Top 5 tags overall (Not Related with any particular user at all)

select s,tagName from (
(select sum(score) as s, T.tagName from posts as P, posttags as PT, tags as T where
P.id = PT.PostId and T.id = PT.TagId
group by PT.tagid)
) t
order by s desc
limit 5