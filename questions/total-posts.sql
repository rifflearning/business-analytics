/*
 * Count the number of Posts in Mattermost
 *
 * Allow filtering by start and end times
 * - It filters by Post by the time it was created.
 */
SELECT COUNT(*)
  FROM Posts
WHERE OriginalId = '' -- omit post edits
[[AND CreateAt >= UNIX_TIMESTAMP({{start_date}}) * 1000
AND CreateAt <= UNIX_TIMESTAMP({{end_date}}) * 1000]]
