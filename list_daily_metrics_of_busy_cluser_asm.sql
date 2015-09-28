spool list_daily_metrics_of_busy_cluser_asm_duplicates.tsv

-- NOTE: Extract all key_value columns as they have finer metric attributes

set pages 1000
set lines 280

-- select TARGET_NAME, TARGET_TYPE, METRIC_NAME, METRIC_COLUMN, to_char(COLLECTION_TIMESTAMP, 'DD-MON-YYYY HH24:MI'), value, KEY_VALUE, KEY_VALUE2, KEY_VALUE3,
-- KEY_VALUE4, KEY_VALUE5 from mgmt$metric_current where target_name = '+ASM_rclp16'

prompt composite_target_name, target_name, metric_name, metric_column, date, key1, key2, key3, key4, key5, average, min, max, std_deviation
select
b.composite_target_name
|| '|' ||
c.host_name
|| '|' ||
a.target_name
|| '|' ||
a.metric_name
|| '|' ||
a.metric_column
|| '|' ||
a.rollup_timestamp
|| '|' ||
a.key_value
|| '|' ||
a.key_value2
|| '|' ||
a.key_value3
|| '|' ||
a.key_value4
|| '|' ||
a.key_value5
|| '|' ||
round(a.average)
|| '|' ||
round(a.minimum)
|| '|' ||
round(a.maximum)
|| '|' ||
round(a.standard_deviation)
from
mgmt$metric_daily a,
mgmt_target_memberships b,
mgmt$target c
where
a.target_type='osm_cluster'
and a.rollup_timestamp = trunc(sysdate-16)
and c.target_name = a.target_name
and c.target_type = a.target_type
and b.member_target_name = c.host_name
and b.composite_target_name in
(
    select distinct  b.composite_target_name
      from mgmt$metric_hourly a,
           mgmt_target_memberships b
     where b.composite_target_type = 'cluster'
       and a.target_type = 'host'
       and a.metric_name='Load'
       and a.metric_column='cpuUtil'
       and a.rollup_timestamp >= sysdate-7
       and a.maximum > 40
       and a.target_name = b.member_target_name
)
order by 1;

spool off
