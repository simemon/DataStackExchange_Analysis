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