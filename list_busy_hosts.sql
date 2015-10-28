set echo on
set lines 60
set pages 1000

spool list_busy_hosts

    select distinct target_name
      from mgmt$metric_hourly
     where target_type = 'host'
       and metric_name='Load'
       and metric_column='cpuUtil'
       and rollup_timestamp >= sysdate-7
       and maximum > 40
       and target_name not like 'fss%'
  order by 1;

spool off
