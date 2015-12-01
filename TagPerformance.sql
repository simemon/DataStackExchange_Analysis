#Tag Performance Over the time (for Dashboard)
#Example: Plotting

select sum(score) as S, date_format(P.CreationDate, '%M %Y') as CreateDate from posts as P, posttags as PT
where PT.TagId = (select Id from tags where TagName = 'plotting')
and PT.PostId = P.Id
group by Year(CreationDate), Month(CreationDate)
order by Year(CreationDate), Month(CreationDate)
