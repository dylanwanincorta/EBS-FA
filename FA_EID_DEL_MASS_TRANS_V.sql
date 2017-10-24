
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "APPS"."FA_EID_DEL_MASS_TRANS_V" ("MASS_SPEC", "RECORD_TYPE", "TRANS_NUM", "BOOK_CODE") AS 
  SELECT mt.CONCURRENT_REQUEST_ID
  ||'-'
  ||mt.MASS_TRANSFER_ID AS MASS_SPEC,
  'Asset Transfer' AS RECORD_TYPE ,
  MT.MASS_TRANSFER_ID TRANS_NUM ,
  BC.BOOK_TYPE_CODE BOOK_CODE 
FROM FA_MASS_TRANSFERS mt,
  FA_BOOK_CONTROLS bc,
  FND_CONC_REQ_SUMMARY_V rs ,
  (SELECT MAX (etl_run_start_date) etl_run_start_date
  FROM fnd_eid_etl_audits
  WHERE eid_data_store_name = 'fa'
  AND record_type           = 'fa'
  AND etl_run_status        = 'S'
  AND ETL_RUN_LANG=USERENV('LANG')
  ) last_run,
  (SELECT MAX (etl_run_start_date) etl_run_start_date
  FROM fnd_eid_etl_audits
  WHERE eid_data_store_name = 'fa'
  AND record_type           = 'fa'
  AND ETL_RUN_LANG=USERENV('LANG')
  ) current_run
WHERE mt.book_type_code                         = bc.book_type_code
AND bc.book_class                               = 'CORPORATE'
AND bc.date_ineffective                        IS NULL
AND mt.CONCURRENT_REQUEST_ID                    = rs.request_id
AND NVL(rs.USER_CONCURRENT_PROGRAM_NAME, '$$') = 'Mass Transfer'
And ( (Rs.Actual_Completion_Date               >= Last_Run.Etl_Run_Start_Date
AND rs.ACTUAL_COMPLETION_DATE                   < current_run.etl_run_start_date ))
UNION ALL
-- Asset Revaluation
SELECT NVL(mr.last_request_id,0)
  ||'-'
  ||mr.mass_reval_id
  ||'-'
  ||mrr.ASSET_ID AS MASS_SPEC,
  'Asset revaluation' AS RECORD_TYPE,
  MR.MASS_REVAL_ID TRANS_NUM,
  BC.BOOK_TYPE_CODE BOOK_CODE
FROM fa_mass_revaluations mr,
  FA_BOOK_CONTROLS bc,
   FA_MASS_REVALUATION_RULES  mrr,
  (SELECT MAX (etl_run_start_date) etl_run_start_date
  FROM fnd_eid_etl_audits
  WHERE eid_data_store_name = 'fa'
  AND record_type           = 'fa'
  AND etl_run_status        = 'S'
  AND ETL_RUN_LANG=USERENV('LANG')
  ) last_run,
  (SELECT MAX (etl_run_start_date) etl_run_start_date
  FROM fnd_eid_etl_audits
  WHERE eid_data_store_name = 'fa'
  AND record_type           = 'fa'
  AND ETL_RUN_LANG=USERENV('LANG')
  ) current_run
WHERE mr.book_type_code      = bc.book_type_code
AND bc.book_class            = 'CORPORATE'
AND bc.date_ineffective     IS NULL
AND mr.status              = ('COMPLETED')
and mr.mass_reval_id = mrr.mass_reval_id(+)
And ( ( Mr.Last_Update_Date >= Last_Run.Etl_Run_Start_Date
AND mr.last_update_date      < current_run.etl_run_start_date ))
UNION ALL
-- Asset Changes
SELECT 
  NVL(mc.concurrent_request_id,0)
  ||'-'
  ||mc.mass_change_id AS MASS_SPEC,
  'Asset Change' AS RECORD_TYPE,
  MC.MASS_CHANGE_ID TRANS_NUM,
  BC.BOOK_TYPE_CODE BOOK_CODE
From Fa_Mass_Changes Mc,
FA_BOOK_CONTROLS bc,
  (SELECT MAX (etl_run_start_date) etl_run_start_date
  FROM fnd_eid_etl_audits
  WHERE eid_data_store_name = 'fa'
  AND record_type           = 'fa'
  AND etl_run_status        = 'S'
  AND ETL_RUN_LANG=USERENV('LANG')
  ) last_run,
  (SELECT MAX (etl_run_start_date) etl_run_start_date
  FROM fnd_eid_etl_audits
  WHERE eid_data_store_name = 'fa'
  AND record_type           = 'fa'
  AND ETL_RUN_LANG=USERENV('LANG')
  ) current_run
WHERE mc.book_type_code      = bc.book_type_code
AND bc.book_class            = 'CORPORATE'
AND bc.date_ineffective     IS NULL
AND mc.status               = 'COMPLETED'
And ( ( Mc.Last_Update_Date >= Last_Run.Etl_Run_Start_Date
AND mc.last_update_date      < current_run.etl_run_start_date ))
UNION ALL
-- Asset Reclassification
SELECT NVL(mr.concurrent_request_id, 0)
  ||'-'
  ||mr.MASS_RECLASS_ID AS MASS_SPEC,
  'Asset Reclass' AS RECORD_TYPE,
  MR.MASS_RECLASS_ID TRANS_NUM,
  MR.BOOK_TYPE_CODE BOOK_CODE
FROM FA_MASS_RECLASS mr,
  FA_BOOK_CONTROLS bc,
  (SELECT MAX (etl_run_start_date) etl_run_start_date
  FROM fnd_eid_etl_audits
  WHERE eid_data_store_name = 'fa'
  AND record_type           = 'fa'
  AND etl_run_status        = 'S'
  AND ETL_RUN_LANG=USERENV('LANG')
  ) last_run,
  (SELECT MAX (etl_run_start_date) etl_run_start_date
  FROM fnd_eid_etl_audits
  WHERE eid_data_store_name = 'fa'
  AND record_type           = 'fa'
  AND ETL_RUN_LANG=USERENV('LANG')
  ) current_run
WHERE mr.BOOK_TYPE_CODE      = bc.BOOK_TYPE_CODE
AND bc.book_class            = 'CORPORATE'
AND bc.date_ineffective     IS NULL
AND mr.status              = 'COMPLETED'
And ( ( Mr.Last_Update_Date >= Last_Run.Etl_Run_Start_Date
AND mr.last_update_date      < current_run.etl_run_start_date ))
UNION ALL
-- Asset Mass Retirements
SELECT 
  NVL(mt.RETIRE_REQUEST_ID,0)
  ||'-'
  ||mt.MASS_RETIREMENT_ID AS MASS_SPEC,
   'Asset Retirement' AS RECORD_TYPE,
   MT.MASS_RETIREMENT_ID TRANS_NUM,
   MT.BOOK_TYPE_CODE BOOK_CODE
FROM FA_MASS_RETIREMENTS mt,
  FA_BOOK_CONTROLS bc,
  (SELECT MAX (etl_run_start_date) etl_run_start_date
  FROM fnd_eid_etl_audits
  WHERE eid_data_store_name = 'fa'
  AND record_type           = 'fa'
  AND etl_run_status        = 'S'
  AND ETL_RUN_LANG=USERENV('LANG')
  ) last_run,
  (SELECT MAX (etl_run_start_date) etl_run_start_date
  FROM fnd_eid_etl_audits
  WHERE eid_data_store_name = 'fa'
  AND record_type           = 'fa'
  AND ETL_RUN_LANG=USERENV('LANG')
  ) current_run
WHERE mt.BOOK_TYPE_CODE      = bc.BOOK_TYPE_CODE
AND bc.book_class            = 'CORPORATE'
AND bc.date_ineffective     IS NULL
AND mt.status               = 'COMPLETED'
And ( ( Mt.Last_Update_Date >= Last_Run.Etl_Run_Start_Date
AND mt.last_update_date      < current_run.etl_run_start_date ))
UNION ALL
SELECT ma.MASS_ADDITION_ID
  || '' AS MASS_SPEC,
  'Mass Additions' AS RECORD_TYPE,
  1         AS TRANS_NUM,
  MA.BOOK_TYPE_CODE     AS BOOK_CODE
FROM fa_mass_additions ma ,
  FA_BOOK_CONTROLS fbc ,
  FA_DEPRN_PERIODS fdp1 ,
  FA_DEPRN_PERIODS fdp2 ,
  GL_LEDGERS LGR ,
  (SELECT MAX (etl_run_start_date) etl_run_start_date
  FROM fnd_eid_etl_audits
  WHERE eid_data_store_name = 'fa'
  AND record_type           = 'fa'
  AND etl_run_status        = 'S'
  AND ETL_RUN_LANG=USERENV('LANG')
  ) last_run,
  (SELECT MAX (etl_run_start_date) etl_run_start_date
  FROM fnd_eid_etl_audits
  WHERE eid_data_store_name = 'fa'
  AND record_type           = 'fa'
  AND ETL_RUN_LANG=USERENV('LANG')
  ) current_run
WHERE ma.book_type_code         = fbc.book_type_code
AND MA.POSTING_STATUS              IN  ('POSTED','SPLIT')
AND fbc.book_class              = 'CORPORATE'
AND fbc.date_ineffective       IS NULL
AND fbc.set_of_books_id         = LGR.LEDGER_ID
AND LGR.OBJECT_TYPE_CODE        = 'L'
AND NVL(LGR.COMPLETE_FLAG, 'Y') = 'Y'
AND fbc.last_period_counter     = fdp1.period_counter
AND fbc.book_type_code          = fdp2.book_type_code
AND fbc.last_period_counter+1   = fdp2.period_counter
AND fbc.date_ineffective       IS NULL
AND ma.post_batch_id           IS NULL
And ( ( Ma.Last_Update_Date    >= Last_Run.Etl_Run_Start_Date
AND ma.last_update_date         < current_run.etl_run_start_date ))
   ;
