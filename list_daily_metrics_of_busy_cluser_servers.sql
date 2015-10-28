spool list_daily_metrics_of_busy_cluser_servers.tsv

set pages 1000
set lines 120

-- Load metrics of all servers of clusters with at least one node
-- of the cluster busy in CPU in the last few days
-- NOTE: Add other metric_names if necessary

prompt composite_target_name, target_name, metric_name, metric_column, date, key1, key2, key3, k3y4, key5, average, min, max, std_deviation
select
b.composite_target_name
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
mgmt_target_memberships b
where
a.target_type='host'
and a.rollup_timestamp >= sysdate-16
and a.metric_name='Load'
--and a.metric_column in ('cpuUtil')
and a.target_name = b.member_target_name
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


