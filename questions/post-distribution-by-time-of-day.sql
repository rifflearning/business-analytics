/*
 * Count the number of Posts in Mattermost grouped by each hour of the day
 *
 * The Mattermost database stores timestamps in UNIX time (milliseconds) in the UTC timezone.
 * The FROM_UNIXTIME function was used to convert timestamps to a readable time. Since FROM_UNIXTIME
 * requires a time in seconds, division by 1000 was used to convert the milliseconds to seconds.
 * Since the current course run is in the EDT/EST timezone, the CONVERT_TZ function was then used
 * to subtract 4 hours from every timestamp.
 *
 * Allow filtering by start and end times
 * - It filters by Post by the time it was created.
 */
SELECT TIME_FORMAT(CONCAT(Time,":00:00"),"%r") AS 'Time of Day', -- convert back to 12hour format for readability
Count AS '# of Posts'
  FROM (
    SELECT DATE_FORMAT(CONVERT_TZ(FROM_UNIXTIME(CreateAt / 1000),"+00:00","-04:00"), "%H") AS Time, -- convert from UTC to -4 (AS 24 hour format for easy grouping)
    COUNT(*) AS Count
      FROM Posts
    WHERE OriginalId = '' -- ignore post edits
    [[AND CreateAt >= UNIX_TIMESTAMP({{start_date}}) * 1000
    AND CreateAt <= UNIX_TIMESTAMP({{end_date}}) * 1000]]
    GROUP BY Time
    ) RawData
