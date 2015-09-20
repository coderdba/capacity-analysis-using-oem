set echo on
set pages 1000
set lines 250


spool list_metric_types
column target_type format a55
column metric_name format a55
column metric_label format a55
column column_label format a70

select distinct target_type, metric_name, metric_label, column_label
from  mgmt$metric_current
order by 1,2,3,4;

spool off

spool list_metric_types.tsv

set lines 500

select distinct target_type || '|' || metric_name || '|' || metric_label || '|' || column_label
from  mgmt$metric_current
order by 1;

spool off
