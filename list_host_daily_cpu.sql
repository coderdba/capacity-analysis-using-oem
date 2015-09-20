spool list_daily_host_metrics

set pages 1000
set lines 120

select
target_name
|| '|' ||
metric_name
|| '|' ||
metric_column
|| '|' ||
metric_label
|| '|' ||
rollup_timestamp
|| '|' ||
round(average,2)
|| '|' ||
round(minimum,2)
|| '|' ||
round(maximum,2)
|| '|' ||
round(standard_deviation,2)
from
mgmt$metric_daily
where
target_type='host'
and metric_name='Load'
and metric_column in ('cpuUtil')
--
and target_name like 'd-g0l88r1%'
and rollup_timestamp >= sysdate-30
order by 1;

spool off
