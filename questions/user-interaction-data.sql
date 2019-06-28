/*
 * For each Mattermost user, list the following information:
 * - username
 * - # of Original Posts
 * - # of Reactions to Other Posts
 * - # of Reactions Others Made to Own Posts
 * - # of Replies to Other Post
 * - # of Replies Others Made to Own Posts
 * - Total Impact (sum of all previous columns)
 *
 * Allow filtering by start and end times
 * Once you specify a start and end date, it filters the count in each column as follows:
 *   - # of Original Posts - filters by Post by the time it was created
 *   - # of Reactions to Other Posts - filters by Reaction by the time it was created
 *   - # of Reactions Others Made to Own Posts - filters by Reaction by the time it was created
 *   - # of Replies to Other Posts - filters by reply(Post) by the time it was created
 *   - # of Replies Others Made to Own Posts - filters by reply(Post) by the time it was created
 *
 */
SELECT Username,
OriginalPosts AS '# of Original Posts',
Reactions AS '# of Reactions to Other Posts',
ReactedTo AS '# of Reactions Others Made to Own Posts',
Replies AS '# of Replies to Other Posts',
RepliedTo AS '# of Replies Others Made to Own Posts',
OriginalPosts + Reactions + ReactedTo + Replies + RepliedTo AS TotalImpact

FROM (

SELECT Users.Username AS Username, -- username column, which everything gets grouped by in the end

(SELECT COUNT(*) -- OriginalPosts
  FROM Posts
WHERE ParentId = '' -- omit replies/comments
AND OriginalId = '' -- omit post edits
AND UserId = Users.Id
[[AND CreateAt >= UNIX_TIMESTAMP({{start_date}}) * 1000
AND CreateAt <= UNIX_TIMESTAMP({{end_date}}) * 1000]]
) AS OriginalPosts,

(SELECT COUNT(*) -- Reactions
  FROM Reactions

  JOIN Posts
  ON Reactions.PostId = Posts.Id

WHERE Reactions.UserId = Users.Id
[[AND Reactions.CreateAt >= UNIX_TIMESTAMP({{start_date}}) * 1000 -- filter by time of reaction
AND Reactions.CreateAt <= UNIX_TIMESTAMP({{end_date}}) * 1000]]
) AS Reactions,

(SELECT COUNT(*) -- ReactedTo
  FROM Reactions

  JOIN Posts
  ON Reactions.PostId = Posts.Id
  [[AND Reactions.CreateAt >= UNIX_TIMESTAMP({{start_date}}) * 1000 -- filter by time of reaction
  AND Reactions.CreateAt <= UNIX_TIMESTAMP({{end_date}}) * 1000]]

WHERE Posts.UserId = Users.Id
) AS ReactedTo,

(SELECT COUNT(*) -- Replies
    FROM Posts
WHERE ParentId != ''
AND Posts.UserId = Users.Id
AND Posts.OriginalId = '' -- omit post edits
[[AND Posts.CreateAt >= UNIX_TIMESTAMP({{start_date}}) * 1000 -- filter by the reply date
AND Posts.CreateAt <= UNIX_TIMESTAMP({{end_date}}) * 1000]]
) AS Replies,

(SELECT COUNT(*) -- RepliedTo, JOIN 2 Posts tables, A is a reply to a Post by the user in B
  FROM Posts A

  JOIN Posts B
  ON A.ParentId = B.Id

WHERE A.ParentId != ''
AND  B.UserId = Users.Id
[[AND A.CreateAt >= UNIX_TIMESTAMP({{start_date}}) * 1000 -- filter by the reply date
AND A.CreateAt <= UNIX_TIMESTAMP({{end_date}}) * 1000]]
) AS RepliedTo

  FROM Users -- this is the user that is referenced in previous selects
[[WHERE Users.Username = {{username}}]]
GROUP BY Users.Username, OriginalPosts, Reactions, ReactedTo, Replies, RepliedTo
) RawData

ORDER BY TotalImpact DESC
