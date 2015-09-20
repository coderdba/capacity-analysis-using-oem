spool list_host_details_busy_cluster_servers.tsv

set pages 1000
set lines 120

prompt HOST_NAME ,SYSTEM_CONFIG ,FREQ ,MEM ,CPU_COUNT ,PHYSICAL_CPU_COUNT ,LOGICAL_CPU_COUNT ,TOTAL_CPU_CORES

select
a.host_name
|| '|' ||
a.system_config
|| '|' ||
a.freq
|| '|' ||
a.mem
|| '|' ||
a.cpu_count
|| '|' ||
a.physical_cpu_count
|| '|' ||
a.logical_cpu_count
|| '|' ||
a.total_cpu_cores
from
mgmt$os_hw_summary a,
mgmt_target_memberships b
where
    a.target_name = b.member_target_name
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
