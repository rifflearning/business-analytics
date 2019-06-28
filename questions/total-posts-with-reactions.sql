/*
 * Count the number of Posts with reactions in Mattermost
 *
 * Allow filtering by start and end times
 * - It filters by Post by the time it was created.
 */
SELECT COUNT(*)
  FROM Posts
WHERE HasReactions
AND OriginalId = '' -- omit post edits
[[AND CreateAt >= UNIX_TIMESTAMP({{start_time}}) * 1000
AND CreateAt <= UNIX_TIMESTAMP({{end_time}}) * 1000]]
