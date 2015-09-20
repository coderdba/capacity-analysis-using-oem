set echo on
set lines 260
set pages 1000

spool list_metric_types_master.tsv

select
 TARGET_TYPE || '|' ||
 --TYPE_VERSION || '|' ||
 METRIC_NAME || '|' ||
 METRIC_COLUMN || '|' ||
 --METRIC_GUID || '|' ||
 --METRIC_CLASS_NAME || '|' ||
 METRIC_CATEGORY_NAME
 --|| '|' ||
 --METRIC_CATEGORY_NLSID
from MGMT$METRIC_CATEGORIES
order by 1;

spool off

-- SQL> desc MGMT$METRIC_CATEGORIES
--  Name                                      Null?    Type
--  ----------------------------------------- -------- ----------------------------
--  TARGET_TYPE                               NOT NULL VARCHAR2(64)
--  TYPE_VERSION                              NOT NULL VARCHAR2(8)
--  METRIC_NAME                                        VARCHAR2(64)
--  METRIC_COLUMN                                      VARCHAR2(64)
--  METRIC_GUID                                        RAW(16)
--  METRIC_CLASS_NAME                         NOT NULL VARCHAR2(64)
--  METRIC_CATEGORY_NAME                      NOT NULL VARCHAR2(64)
--  METRIC_CATEGORY_NLSID                              VARCHAR2(64)
--
