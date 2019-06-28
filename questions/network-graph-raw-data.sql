/*
 * For each Mattermost user, list the following information:
 * - username
 *
 * - Users Replied To
 *   --for each reply to another user's post, list each post's author's username
 *   --list of usernames is comma delimited. duplicate usernames may/will occur in list for multiple occurences
 *
 * - Users Reacted To
 *   --for each Reaction to another user's post, list each post's author's username
 *   --list of usernames is comma delimited. duplicate usernames may/will occur in list for multiple occurences
 *
 * - Users Direct Messaged
 *   --for each direct message sent, list each recipient's username
 *   --list of usernames is comma delimited. duplicate usernames may/will occur in list for multiple occurences
 *
 * - Users Mentioned
 *   --for each user mentioned using the @username syntax, list each mentionee's username
 *   --list of usernames is comma delimited. duplicate usernames may/will occur in list for multiple occurences
 *
 * - PLG Team Members
 *   --for each group chat with name prefix 'plg', that this user is a participant in,
 *   --list all other user's usernames that are participants in those group chats
 *   --list of usernames is comma delimited. duplicate usernames may/will occur in list for multiple occurences
 *
 * - Capstone Team Members
 *   --for each group chat with name prefix 'capstone', that this user is a participant in,
 *   --list all other user's usernames that are participants in those group chats
 *   --list of usernames is comma delimited. duplicate usernames may/will occur in list for multiple occurences
 *
 * Allow filtering by start and end times
 * Once you specify a start and end date, it filters the columns as follows:
 *   - Users Replied To - filters by the reply(Post) by the time it was created
 *   - Users Reacted To - filters by the Reaction by the time it was created
 *   - Users Direct Messaged - filters by the direct message(Post) by the time it was created
 *   - Users Mentioned - filters by the Post containing the mention by the time it was created
 *   - PLG Team Members - not currently filtered
 *   - Capstone Team Members - not currently filtered
 *
 */
SELECT Username,

(SELECT GROUP_CONCAT(Replies_Query_Users.Username) -- Replies
  FROM Posts Replies_Query_Posts

  JOIN Users Replies_Query_Users
  ON Replies_Query_Users.Id = (SELECT UserId FROM Posts WHERE Id = Replies_Query_Posts.ParentId)

WHERE ParentId != ''
AND Replies_Query_Posts.UserId = MainUserReference.Id
[[AND Replies_Query_Posts.CreateAt >= UNIX_TIMESTAMP({{start_date}}) * 1000
AND Replies_Query_Posts.CreateAt <= UNIX_TIMESTAMP({{end_date}}) * 1000]]
) AS 'Users Replied To',

(SELECT GROUP_CONCAT(Reactions_Query_Users.Username) -- Reactions
  FROM Reactions Reactions_Query_Reactions

  JOIN Users Reactions_Query_Users
  ON Reactions_Query_Users.Id = (SELECT UserId FROM Posts WHERE Id = Reactions_Query_Reactions.PostId)

WHERE Reactions_Query_Reactions.UserId = MainUserReference.Id
[[AND Reactions_Query_Reactions.CreateAt >= UNIX_TIMESTAMP({{start_date}}) * 1000 -- filter by time of reaction
AND Reactions_Query_Reactions.CreateAt <= UNIX_TIMESTAMP({{end_date}}) * 1000]]
) AS 'Users Reacted To',

(SELECT GROUP_CONCAT(DirectMessages_Query_Users.Username) -- Direct Messages
  FROM Posts DirectMessages_Query_Posts

  JOIN Channels DirectMessages_Query_Channels -- direct message channels only
  ON DirectMessages_Query_Channels.Type = 'D'
  AND DirectMessages_Query_Posts.ChannelId = DirectMessages_Query_Channels.Id

  JOIN ChannelMembers DirectMessages_Query_ChannelMembers -- get channelmembers that aren't main reference user
  ON DirectMessages_Query_ChannelMembers.ChannelId = DirectMessages_Query_Channels.Id

  JOIN Users DirectMessages_Query_Users -- get usernames of direct message recipients
  ON DirectMessages_Query_Users.Id = DirectMessages_Query_ChannelMembers.UserId

WHERE DirectMessages_Query_Posts.UserId = MainUserReference.Id
AND DirectMessages_Query_ChannelMembers.UserId != MainUserReference.Id -- exclude self in results
[[AND DirectMessages_Query_Posts.CreateAt >= UNIX_TIMESTAMP({{start_date}}) * 1000 -- filter by time of direct message
AND DirectMessages_Query_Posts.CreateAt <= UNIX_TIMESTAMP({{end_date}}) * 1000]]
) AS 'Users Direct Messaged',

(SELECT GROUP_CONCAT(Mentionee.Username) -- mentions
  FROM Users Mentionee

  JOIN Posts
  ON Message LIKE (CONCAT('%@',Mentionee.Username,'%'))

  JOIN Users Mentioner
  ON Mentioner.Id = Posts.UserId

WHERE Mentioner.Id = MainUserReference.Id
[[AND Posts.CreateAt >= UNIX_TIMESTAMP({{start_date}}) * 1000 -- filter by time of mention
AND Posts.CreateAt <= UNIX_TIMESTAMP({{end_date}}) * 1000]]
) AS 'Users Mentioned',
(
SELECT GROUP_CONCAT(DISTINCT Users.Username)
  FROM Channels

  JOIN ChannelMembers
  ON ChannelMembers.ChannelId = Channels.Id

  JOIN ChannelMembers B
  ON B.ChannelId = Channels.Id

  JOIN Users
  ON Users.Id = B.UserId

WHERE LEFT(Channels.Name,3) = 'plg'
AND ChannelMembers.UserId = MainUserReference.Id
AND Users.Id != MainUserReference.Id
) AS 'PLG Team Members',
(
SELECT GROUP_CONCAT(DISTINCT Users.Username)
  FROM Channels

  JOIN ChannelMembers
  ON ChannelMembers.ChannelId = Channels.Id

  JOIN ChannelMembers B
  ON B.ChannelId = Channels.Id

  JOIN Users
  ON Users.Id = B.UserId

WHERE LEFT(Channels.Name,8) = 'capstone'
AND ChannelMembers.UserId = MainUserReference.Id
AND Users.Id != MainUserReference.Id
) AS 'Capstone Team Members'

FROM Users MainUserReference
