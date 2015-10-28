set echo on
set lines 120
set pages 1000

alter session set current_schema=sysman;

-- Clusters and all servers of the cluster
-- (with at least one server in the cluster beyond CPU threshold in the last few days)

spool list_busy_cluster_all_servers.tsv

select distinct composite_target_type || '|' ||  composite_target_name || '|' ||  member_target_type || '|' || member_target_name
from
mgmt_target_memberships
where member_target_type='host'
and   composite_target_name in
(
    select distinct b.composite_target_name
      from mgmt$metric_hourly a,
           mgmt_target_memberships b
     where b.composite_target_type = 'cluster'
       and a.target_type = 'host'
       and b.member_target_type = 'host'
       and a.metric_name='Load'
       and a.metric_column='cpuUtil'
       and a.rollup_timestamp >= sysdate-7
       and a.maximum > 40
       and a.target_name = b.member_target_name
)
order by 1;

spool off
