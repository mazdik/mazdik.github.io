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

/* Sessions */
SELECT query_id, user, address, elapsed, query   FROM system.processes ORDER BY query_id;
SELECT * FROM system.metrics WHERE metric LIKE '%Connection';

/* Lock (UPDATE and DELETE) */
SELECT * FROM system.mutations; 

/* ReplacingMergeTree and PARTITION */
CREATE TABLE tm_measure
(
    well_id UInt64,
    param_id UInt16,
    dt DateTime,
    val Nullable(Float64)
)
ENGINE = ReplacingMergeTree
PARTITION BY toYYYYMM(dt)
ORDER BY (well_id, param_id, dt)
SETTINGS index_granularity = 8192;

OPTIMIZE TABLE tm_measure PARTITION '202004';

ALTER TABLE tm_measure DROP PARTITION '202005';

/* Размер таблиц */
select concat(database, '.', table)                         as table,
       formatReadableSize(sum(bytes))                       as size,
       sum(rows)                                            as rows,
       max(modification_time)                               as latest_modification,
       sum(bytes)                                           as bytes_size,
       any(engine)                                          as engine,
       formatReadableSize(sum(primary_key_bytes_in_memory)) as primary_keys_size
from system.parts
where active
group by database, table
order by bytes_size desc;

/* Принудительная очистка по TTL: */
OPTIMIZE TABLE system.query_log FINAL;
OPTIMIZE TABLE system.query_thread_log FINAL;
