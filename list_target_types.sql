set echo on
set pages 1000
set lines 80


spool list_target_types

--select distinct target_type from  mgmt$metric_current order by 1;

select distinct target_type
from mgmt$target
order by 1;


spool off
