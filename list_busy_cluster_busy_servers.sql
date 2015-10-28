set echo on
set lines 120
set pages 1000

-- Clusters and servers (with at least one server in the cluster beyond CPU threshold in the last few days)

alter session set current_schema=sysman;

spool list_busy_cluster_servers.tsv

    select distinct b.composite_target_type || '|' ||  b.composite_target_name || '|' ||  a.target_name
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
  order by 1;

spool off

