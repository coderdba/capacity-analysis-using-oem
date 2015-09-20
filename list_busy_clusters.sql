set echo on
set lines 60
set pages 1000

--  Clusters that have at least one of their servers busy in cpu utilization in the last few days

spool list_busy_clusters.tsv

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
  order by 1;

spool off
