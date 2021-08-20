-- Querying top 10 twitch channels by amount of watch and stream time, ordered by watch time
SELECT top 10 channel, [Followers], [Stream time(minutes)], [Watch time(Minutes)]
FROM ProjectPortfolio.dbo.twitchdata
ORDER BY [Watch time(Minutes)] DESC

-- Querying top 10 twitch channels by amount of watch and stream time, ordered by stream time
SELECT top 10 channel, [Watch time(Minutes)], [Stream time(minutes)] 
FROM ProjectPortfolio.dbo.twitchdata
ORDER BY [Stream time(minutes)] DESC

-- Querying top 10 twitch channels by amount of peak viewership
SELECT top 10 channel, [Peak viewers], [Average viewers]
FROM ProjectPortfolio.dbo.twitchdata
ORDER BY [Peak viewers] DESC

-- Querying top 10 twitch channels by amount of average viewership
SELECT top 10 channel, [Peak viewers], [Average viewers]
FROM ProjectPortfolio.dbo.twitchdata
ORDER BY [Average viewers] DESC

-- Querying top 10 twitch channels by amount of followers
SELECT top 10 channel, [Followers],  [Watch time(Minutes)]
FROM ProjectPortfolio.dbo.twitchdata
ORDER BY Followers DESC

--Querying the top channels where language is english
SELECT top 10 Channel, Followers, language
FROM ProjectPortfolio.dbo.twitchdata
WHERE Language = 'English'
ORDER BY followers DESC

--Querying the top channels where language is not english
SELECT top 10 Channel, Followers, language
FROM ProjectPortfolio.dbo.twitchdata
WHERE Language <> 'English'
ORDER BY followers DESC


