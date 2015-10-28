spool list_daily_metrics_of_busy_cluser_asm.tsv

set pages 1000
set lines 280

-- ASM metrics of all servers of clusters with at least one node
-- of the cluster busy in CPU in the last few days

prompt composite_target_name, target_name, metric_name, metric_column, date, key1, key2, key3, key4, key5, average, min, max, std_deviation

select
a.composite_target_name
|| '|' ||
b.host_name
|| '|' ||
c.target_name
|| '|' ||
c.metric_name
|| '|' ||
c.metric_column
|| '|' ||
c.rollup_timestamp
|| '|' ||
c.key_value
|| '|' ||
c.key_value2
|| '|' ||
c.key_value3
|| '|' ||
c.key_value4
|| '|' ||
c.key_value5
|| '|' ||
round(c.average)
|| '|' ||
round(c.minimum)
|| '|' ||
round(c.maximum)
|| '|' ||
round(c.standard_deviation)
from
mgmt_target_memberships a,
mgmt$target b,
mgmt$metric_daily c
where
    a.member_target_type = 'host'
and b.target_type = 'osm_cluster'
and b.host_name = a.member_target_name
and c.target_type = b.target_type
and c.target_name = b.target_name
and c.rollup_timestamp >= trunc(sysdate-16)
--
--and a.composite_target_name in ('rclp09')
and a.composite_target_name in
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

