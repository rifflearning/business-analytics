/*
 * For each Mattermost channel list the following information:
 * - channel name
 * - channel type (Public, Private, Direct Msg, Group Msg)
 * - channel creator's username
 * - number of posts in channel
 * - number of users in channel
 *
 * Allow filtering by start and end times
 */
SELECT Channels.Name AS 'Channel Name',
Users.Username AS 'Creator',
CASE 
    WHEN Channels.Type = 'P' THEN 'Private Channel'
    WHEN Channels.Type = 'D' THEN 'Direct Message'
    WHEN Channels.Type = 'G' THEN 'Group Message'
    WHEN Channels.Type = 'O' THEN 'Public Channel'
END AS 'Channel Type',
COUNT(Posts.Id) AS '# of Posts',
(SELECT COUNT(*) FROM ChannelMembers WHERE ChannelMembers.ChannelId = Channels.Id) '# of Members'
    FROM Posts
        JOIN Channels
        ON Posts.ChannelId = Channels.Id
        LEFT JOIN Users
        ON Channels.CreatorId = Users.Id
       
WHERE OriginalId = '' -- omit post edits
[[AND Posts.CreateAt >= UNIX_TIMESTAMP({{start_date}}) * 1000
AND Posts.CreateAt <= UNIX_TIMESTAMP({{end_date}}) * 1000]]
GROUP BY Channels.Id
ORDER BY 4 DESC
