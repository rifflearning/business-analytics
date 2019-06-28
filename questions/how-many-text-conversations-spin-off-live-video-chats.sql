/*
 * Count the number of video chats that are a result of a text conversation
 *
 * More specifically, count the number of times a Post containing the text
 * 'I started a Riff meeting! Join here:' is posted after a minimum of y Posts
 * are posted, all of which occuring within a timeframe of x minutes.
 *
 *
 * Requires two parameters
 *   1. timeframe_threshold (default: 10)
 *     - the timeframe in minutes within which the text conversation happens and the
 *       subsequent video chat link is posted
 *
 *   2. previous_post_threshold (default: 10)
 *     - the minimum number of posts that the text conversation must contain
 *
 */
SELECT COUNT(*) AS '# of video chats created by text conversations'
  FROM
    (
    SELECT FROM_UNIXTIME(A.CreateAt / 1000) AS VideoLinkDate,
    Channels.Name AS ChannelName,
    (
    SELECT COUNT(*)
      FROM Posts
    WHERE OriginalId = '' -- omit post edits
    AND A.CreateAt > CreateAt -- message is previous to post with video link
    AND (A.CreateAt - CreateAt) / 60000 < {{timeframe_threshold}} -- message is less than 10 minutes previous to post with video link
    AND ChannelId = A.ChannelId
    ) AS PostsPreviousToVideoLink
      FROM Posts A

      JOIN Channels
      ON A.ChannelId = Channels.Id

    WHERE A.OriginalId = '' -- omit post edits
    AND A.Message LIKE('%I started a Riff meeting! Join here:%')
    ORDER BY 3 DESC
    ) RawData -- RawData query will show date/time and channel name pertaining to the posted video link (good for QA)
WHERE PostsPreviousToVideoLink >= {{previous_post_threshold}}
