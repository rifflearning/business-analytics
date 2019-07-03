/*
 * Count the number of Posts with replies in Mattermost
 *
 * Allow filtering by start and end times
 * - It filters by Post by the time it was created. It will only return results
 * for Posts for which its replies are between the specified start and end date.
 */
SELECT COUNT(DISTINCT ParentId)
  FROM Posts
WHERE ParentId != ''
[[AND CreateAt >= UNIX_TIMESTAMP({{start_time}}) * 1000
AND CreateAt <= UNIX_TIMESTAMP({{end_time}}) * 1000]]
