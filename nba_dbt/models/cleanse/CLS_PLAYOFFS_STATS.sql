with source as (
    select * 
    from {{ source('STAGING_NBA_DATA', 'STG_PLAYOFFS_STATS') }}
),

CLS_PLAYOFFS_STATS as (
    SELECT 
        CAST(PERSONID AS NUMBER) AS PLAYER_ID
        , CAST(GAMEID AS NUMBER) AS GAME_ID
        , CAST(TEAMID AS NUMBER) AS TEAM_ID
        , SEASON_YEAR
        , TO_DATE(GAME_DATE) AS GAME_DATE
        , TEAMCITY AS TEAM_CITY
        , TEAMNAME AS TEAM_NAME
        , TEAMTRICODE AS TEAM_ABBREVATION
        , PERSONNAME AS PLAYER_NAME
        , COALESCE(POSITION, 'Unknown') AS POSITION
        , COALESCE(COMMENT, 'Unknown') AS COMMENT
        , CASE 
            WHEN LEFT(MINUTES, 2) LIKE '%:%' THEN TO_NUMBER(LEFT(MINUTES,1))
            WHEN LEFT(MINUTES, 2) NOT LIKE '%:%' THEN TO_NUMBER(LEFT(MINUTES, 2))
        END AS MINUTES
        , TO_NUMBER(RIGHT(MINUTES, 2)) AS SECONDS 
        , FIELDGOALSMADE AS FG_MADE
        , FIELDGOALSATTEMPTED AS  FG_ATTEMPTED
        , FIELDGOALSPERCENTAGE AS FG_PCT
        , THREEPOINTERSMADE AS FG3_MADE
        , THREEPOINTERSATTEMPTED AS FG3_ATTEMPTED
        , THREEPOINTERSPERCENTAGE AS FG3_PCT
        , FREETHROWSMADE AS FT_MADE
        , FREETHROWSATTEMPTED AS FT_ATTEMPTED
        , FREETHROWSPERCENTAGE AS FT_PCT
        , REBOUNDSOFFENSIVE AS OREB
        , REBOUNDSDEFENSIVE AS DREB
        , REBOUNDSTOTAL AS REB_TOTAL
        , ASSISTS AS AST
        , STEALS AS STL
        , BLOCKS AS BLK
        , TURNOVERS AS TOV
        , FOULSPERSONAL AS FOULS
        , POINTS AS PTS
        , PLUSMINUSPOINTS AS PLUS_MINUS
        , CURRENT_TIMESTAMP() as LOAD_DATE
    from source
)

select * from CLS_PLAYOFFS_STATS
