spool list_hourly_metrics_of_busy_cluser_databases.tsv

set pages 1000
set lines 150

prompt composite_target_name, target_name, metric_name, metric_column, date, average, min, max, std_deviation
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
round(a.average)
|| '|' ||
round(a.minimum)
|| '|' ||
round(a.maximum)
|| '|' ||
round(a.standard_deviation)
from
mgmt$metric_hourly a,
mgmt_target_memberships b,
mgmt$target c
where
a.target_type='oracle_database'
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
