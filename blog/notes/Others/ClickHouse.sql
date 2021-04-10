/* Мат. вьюшка, которая обновляться с агрегированием в 5-минутный диапазон */
CREATE MATERIALIZED VIEW CURRENT_events
ENGINE = SummingMergeTree
PARTITION BY toYYYYMM(ts)
ORDER BY ts 
AS
SELECT
    toStartOfFiveMinute(ts) AS ts,
    count() AS numbers
FROM events
GROUP BY ts
