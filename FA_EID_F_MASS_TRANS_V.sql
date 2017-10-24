
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "APPS"."FA_EID_F_MASS_TRANS_V" ("RECORD_TYPE", "MASS_SPEC", "EID_LAST_UPDATE_DATE", "REQUEST_NUM", "TRANS_NUM", "ORG_ID", "BOOK_CODE", "BOOK_NAME", "TRANS_DATE", "MAJOR_CATEGORY", "MINOR_CATEGORY", "ASSET_CATEGORY", "TRANS_DESCRIPTION", "TRANS_STATUS", "TRANS_STATUS_CODE", "TRANSFER_TYPE", "CHANGE_TYPE", "ASSET_NUMBER", "ASSET_DESCRIPTION", "ADDITION_ACCOUNTING_YEAR", "ADDITION_MONTH_YEAR", "ADDITION_COST", "ADDITION_UNITS", "ADDITION_SOURCE_NAME", "ADDITION_BATCH_ID", "ADDITION_BATCH_DATE", "ADDITION_PO_NUMBER", "ADDITION_INV_ID", "ADDITION_INV_NUMBER", "ADDITION_INV_DATE", "ADDITION_INV_LINE_NUMBER", "ADDITION_INV_DESCRIPTION", "ADDITION_SUPPLIER_NUMBER", "ADDITION_SUPPLIER_NAME", "ADDITION_PROJ_NAME", "ADDITION_PROJ_TASK", "AMORTIZED", "ATTRIBUTE_CATEGORY_CODE", "CONTEXT", "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3", "ATTRIBUTE4", "ATTRIBUTE5", "ATTRIBUTE6", "ATTRIBUTE7", "ATTRIBUTE8", "ATTRIBUTE9", "ATTRIBUTE10", "ATTRIBUTE11", "ATTRIBUTE12", "ATTRIBUTE13", "ATTRIBUTE14", "ATTRIBUTE15", "ATTRIBUTE16", "ATTRIBUTE17", "ATTRIBUTE18", "ATTRIBUTE19", "ATTRIBUTE20", "ATTRIBUTE21", "ATTRIBUTE22", "ATTRIBUTE23", "ATTRIBUTE24", "ATTRIBUTE25", "ATTRIBUTE26", "ATTRIBUTE27", "ATTRIBUTE28", "ATTRIBUTE29", "ATTRIBUTE30") AS 
  select
--Asset Transfers
  'Asset Transfer' AS record_type
  , NVL(mt.CONCURRENT_REQUEST_ID, 0)||'-'||mt.MASS_TRANSFER_ID as MASS_SPEC
  , (Case When mt.CONCURRENT_REQUEST_ID is Null Then mt.DATE_EFFECTIVE
           Else rs.ACTUAL_COMPLETION_DATE 
           End )
           EID_LAST_UPDATE_DATE
   
  , mt.CONCURRENT_REQUEST_ID Request_num
  , mt.MASS_TRANSFER_ID Trans_num
  ,NVL(bc.ORG_ID,-9999) AS ORG_ID
  , bc.book_type_code Book_code
  , bc.book_type_name Book_Name
  , mt.TRANSACTION_DATE_ENTERED Trans_Date,
   decode(fc.category_id,NULL,NULL,
  fnd_flex_xml_publisher_apis.process_kff_combination_1(p_lexical_name           => 'AssetCategory' , 
                                                             p_application_short_name => 'OFA', 
                                                             p_id_flex_code => 'CAT#', 
                                                             p_id_flex_num => fsc.category_flex_structure, 
                                                             p_data_set    => fsc.category_flex_structure, 
                                                             p_ccid        => fc.category_id,
                                                             p_segments    => 'BASED_CATEGORY',
                                                             p_show_parent_segments => 'N',
                                                             p_output_type=>'FULL_DESCRIPTION')
                                                             )  major_Category
  ,decode(fc.category_id,NULL,NULL,
  fnd_flex_xml_publisher_apis.process_kff_combination_1(p_lexical_name           => 'AssetCategory' , 
                                                             p_application_short_name => 'OFA', 
                                                             p_id_flex_code => 'CAT#', 
                                                             p_id_flex_num => fsc.category_flex_structure, 
                                                             p_data_set    => fsc.category_flex_structure, 
                                                             p_ccid        => fc.category_id,
                                                             p_segments    => 'MINOR_CATEGORY',
                                                             p_show_parent_segments => 'N',
                                                             p_output_type=>'FULL_DESCRIPTION'))  minor_Category,
decode(fc.category_id,NULL,NULL,
  fnd_flex_xml_publisher_apis.process_kff_combination_1(p_lexical_name           => 'AssetCategory' , 
                                                             p_application_short_name => 'OFA', 
                                                             p_id_flex_code => 'CAT#', 
                                                             p_id_flex_num => fsc.category_flex_structure, 
                                                             p_data_set    => fsc.category_flex_structure, 
                                                             p_ccid        => fc.category_id,
                                                             p_segments    => 'ALL',
                                                             p_show_parent_segments => 'N',
                                                             p_output_type=>'FULL_DESCRIPTION'))  asset_Category                                                                                                                        
  , mt.description Trans_Description,
  (Case 
        when rs.USER_CONCURRENT_PROGRAM_NAME = 'Mass Transfers Preview Report' then (SELECT MEANING FROM FA_LOOKUPS WHERE LOOKUP_TYPE='MASS_TRX_STATUS' AND LOOKUP_CODE='PREVIEWED') 
        when rs.USER_CONCURRENT_PROGRAM_NAME ='Mass Transfer' then (SELECT MEANING FROM FA_LOOKUPS WHERE LOOKUP_TYPE='MASS_TRX_STATUS' AND LOOKUP_CODE='COMPLETED')
        when mt.CONCURRENT_REQUEST_ID is null then (SELECT MEANING FROM FA_LOOKUPS WHERE LOOKUP_TYPE='MASS_TRX_STATUS' AND LOOKUP_CODE='NEW')
        
   End) Trans_Status
   , (Case 
        when rs.USER_CONCURRENT_PROGRAM_NAME = 'Mass Transfers Preview Report' then 'PREVIEWED'
        when rs.USER_CONCURRENT_PROGRAM_NAME ='Mass Transfer' then 'COMPLETED'    
        when mt.CONCURRENT_REQUEST_ID is null then 'NEW'
        
   End) Trans_Status_code
   -- transfer type , will be multi-assign attribute in Endeca metadata
  , (CASE WHEN mt.FROM_LOCATION_ID <> mt.TO_LOCATION_ID  THEN (SELECT MEANING FROM FA_LOOKUPS WHERE LOOKUP_TYPE='FA_EID_MASS_TRANSFER_TYPE' AND LOOKUP_CODE='LOCATION_TRANSFER') ||'|' ELSE '' END)||
    (CASE WHEN mt.FROM_GL_CCID<> mt.TO_GL_CCID           THEN (SELECT MEANING FROM FA_LOOKUPS WHERE LOOKUP_TYPE='FA_EID_MASS_TRANSFER_TYPE' AND LOOKUP_CODE='DEPRECIATION_EXPENSE_TRANSFER') ||'|' ELSE '' END)||
    (CASE WHEN mt.FROM_EMPLOYEE_ID <> mt.TO_EMPLOYEE_ID  THEN (SELECT MEANING FROM FA_LOOKUPS WHERE LOOKUP_TYPE='FA_EID_MASS_TRANSFER_TYPE' AND LOOKUP_CODE='EMPLOYEE_TRANSFER') ELSE (SELECT MEANING FROM FA_LOOKUPS WHERE LOOKUP_TYPE='FA_EID_MASS_TRANSFER_TYPE' AND LOOKUP_CODE='NO_TRANSFER_DET')  END) as Transfer_Type 
   /* Union Attributes*/ 
  ,'' AS Change_Type 
  ,'' as asset_number
  ,'' as asset_description    
  ,'' as addition_Accounting_Year 
  ,'' as addition_Month_Year   
  ,to_number('') as addition_cost  
  ,to_number('') as addition_units
  ,'' as addition_source_name
  ,to_number('') as addition_batch_id 
  ,to_date('') as addition_batch_date 
  ,'' as addition_po_number  
  ,to_number('') as addition_inv_id 
  ,'' as addition_inv_number  
  ,to_date('') as addition_inv_date 
  ,to_number('') as addition_inv_line_number 
  ,'' as addition_inv_Description 
  ,'' as addition_supplier_Number  
  ,'' as addition_supplier_name  
  ,'' as addition_Proj_Name 
  ,'' as addition_proj_task  
  ,'' as Amortized
  --Asset Transfer DFF
  ,mt.ATTRIBUTE_CATEGORY_CODE 
  ,NULL AS CONTEXT 
  ,mt.ATTRIBUTE1
  ,mt.ATTRIBUTE2
  ,mt.ATTRIBUTE3
  ,mt.ATTRIBUTE4
  ,mt.ATTRIBUTE5
  ,mt.ATTRIBUTE6
  ,mt.ATTRIBUTE7
  ,mt.ATTRIBUTE8
  ,mt.ATTRIBUTE9
  ,mt.ATTRIBUTE10
  ,mt.ATTRIBUTE11
  ,mt.ATTRIBUTE12
  ,mt.ATTRIBUTE13
  ,mt.ATTRIBUTE14
  ,mt.ATTRIBUTE15
  ,NULL AS ATTRIBUTE16
  ,NULL AS ATTRIBUTE17
  ,NULL AS ATTRIBUTE18
  ,NULL AS ATTRIBUTE19
  ,NULL AS ATTRIBUTE20
  ,NULL AS ATTRIBUTE21
  ,NULL AS ATTRIBUTE22
  ,NULL AS ATTRIBUTE23
  ,NULL AS ATTRIBUTE24
  ,NULL AS ATTRIBUTE25
  ,NULL AS ATTRIBUTE26
  ,NULL AS ATTRIBUTE27
  ,NULL AS ATTRIBUTE28
  ,NULL AS ATTRIBUTE29
  ,NULL AS ATTRIBUTE30
  
from
  FA_MASS_TRANSFERS mt,
  FA_BOOK_CONTROLS bc,
  FA_CATEGORIES_B fc,
  FND_CONC_REQ_SUMMARY_V rs  ,
  fa_system_controls  fsc
where
  mt.book_type_code = bc.book_type_code
  and bc.book_class = 'CORPORATE'
  and bc.date_ineffective IS NULL     
  and mt.CATEGORY_ID = fc.category_id(+)
  and mt.CONCURRENT_REQUEST_ID = rs.request_id(+)
  and NVL(rs.USER_CONCURRENT_PROGRAM_NAME, '$$') <> 'Mass Transfer'
union all
-- Asset Revaluation
-- Asset Revaluation
select
  'Asset revaluation' AS record_type,
  NVL(mr.last_request_id,0)||'-'||mr.mass_reval_id||'-'||mrr.ASSET_ID as MASS_SPEC,
  mr.LAST_UPDATE_DATE EID_LAST_UPDATE_DATE,
  mr.last_request_id Request_num,
  mr.mass_reval_id Trans_num,
  NVL(bc.ORG_ID,-9999) AS ORG_ID,
  bc.book_type_code book_code,
  bc.book_type_name Book_Name,
  mr.reval_date trans_date,
  
     decode(fc.category_id,NULL,NULL,
  fnd_flex_xml_publisher_apis.process_kff_combination_1(p_lexical_name           => 'AssetCategory' , 
                                                             p_application_short_name => 'OFA', 
                                                             p_id_flex_code => 'CAT#', 
                                                             p_id_flex_num => fsc.category_flex_structure, 
                                                             p_data_set    => fsc.category_flex_structure, 
                                                             p_ccid        => fc.category_id,
                                                             p_segments    => 'BASED_CATEGORY',
                                                             p_show_parent_segments => 'N',
                                                             p_output_type=>'FULL_DESCRIPTION')
                                                             )  major_Category
  ,decode(fc.category_id,NULL,NULL,
  fnd_flex_xml_publisher_apis.process_kff_combination_1(p_lexical_name           => 'AssetCategory' , 
                                                             p_application_short_name => 'OFA', 
                                                             p_id_flex_code => 'CAT#', 
                                                             p_id_flex_num => fsc.category_flex_structure, 
                                                             p_data_set    => fsc.category_flex_structure, 
                                                             p_ccid        => fc.category_id,
                                                             p_segments    => 'MINOR_CATEGORY',
                                                             p_show_parent_segments => 'N',
                                                             p_output_type=>'FULL_DESCRIPTION'))  minor_Category,
decode(fc.category_id,NULL,NULL,
  fnd_flex_xml_publisher_apis.process_kff_combination_1(p_lexical_name           => 'AssetCategory' , 
                                                             p_application_short_name => 'OFA', 
                                                             p_id_flex_code => 'CAT#', 
                                                             p_id_flex_num => fsc.category_flex_structure, 
                                                             p_data_set    => fsc.category_flex_structure, 
                                                             p_ccid        => fc.category_id,
                                                             p_segments    => 'ALL',
                                                             p_show_parent_segments => 'N',
                                                             p_output_type=>'FULL_DESCRIPTION'))  asset_Category                                                                                                                        
  ,mr.description Trans_Description
  ,lo.meaning as Trans_Status
  ,mr.status as TRANS_STATUS_CODE
  ,'' as Transfer_Type 
  ,'' AS Change_Type 
  /* Union Attributes*/ 
  ,ad.ASSET_NUMBER as asset_number
  ,'' as asset_description    
  ,'' as addition_Accounting_Year 
  ,'' as addition_Month_Year   
  ,to_number('') as addition_cost  
  ,to_number('') as addition_units
  ,'' as addition_source_name
  ,to_number('') as addition_batch_id 
  ,to_date('') as addition_batch_date 
  ,'' as addition_po_number  
  ,to_number('') as addition_inv_id 
  ,'' as addition_inv_number  
  ,to_date('') as addition_inv_date 
  ,to_number('') as addition_inv_line_number 
  ,'' as addition_inv_Description 
  ,'' as addition_supplier_Number  
  ,'' as addition_supplier_name  
  ,'' as addition_Proj_Name 
  ,'' as addition_proj_task 
  ,'' as Amortized
  --Mass Revaluation DFF
  ,mr.ATTRIBUTE_CATEGORY_CODE
  ,NULL AS CONTEXT 
  ,mr.ATTRIBUTE1
  ,mr.ATTRIBUTE2
  ,mr.ATTRIBUTE3
  ,mr.ATTRIBUTE4
  ,mr.ATTRIBUTE5
  ,mr.ATTRIBUTE6
  ,mr.ATTRIBUTE7
  ,mr.ATTRIBUTE8
  ,mr.ATTRIBUTE9
  ,mr.ATTRIBUTE10
  ,mr.ATTRIBUTE11
  ,mr.ATTRIBUTE12
  ,mr.ATTRIBUTE13
  ,mr.ATTRIBUTE14
  ,mr.ATTRIBUTE15
  ,NULL AS ATTRIBUTE16
  ,NULL AS ATTRIBUTE17
  ,NULL AS ATTRIBUTE18
  ,NULL AS ATTRIBUTE19
  ,NULL AS ATTRIBUTE20
  ,NULL AS ATTRIBUTE21
  ,NULL AS ATTRIBUTE22
  ,NULL AS ATTRIBUTE23
  ,NULL AS ATTRIBUTE24
  ,NULL AS ATTRIBUTE25
  ,NULL AS ATTRIBUTE26
  ,NULL AS ATTRIBUTE27
  ,NULL AS ATTRIBUTE28
  ,NULL AS ATTRIBUTE29
  ,NULL AS ATTRIBUTE30
 
from 
  fa_mass_revaluations mr,
  FA_MASS_REVALUATION_RULES  mrr,
  FA_BOOK_CONTROLS bc,
  FA_CATEGORIES_B fc ,
  FA_ADDITIONS_B ad, 
  fa_system_controls  fsc,
  FA_LOOKUPS lo
where
  mr.mass_reval_id = mrr.mass_reval_id(+)
  and mr.book_type_code = bc.book_type_code
  and bc.book_class = 'CORPORATE'
  and bc.date_ineffective IS NULL
  and mrr.category_id = fc.category_id(+)
  and mrr.ASSET_ID = ad.ASSET_ID(+)
  and mr.status <> ('COMPLETED')
  and lo.lookup_type='MASS_TRX_STATUS'
  and lo.enabled_flag='Y'
  and mr.status = lo.lookup_code
  
  --and mr.LAST_REQUEST_ID IS NOT NULL
union all
-- Asset Changes
select
'Asset Change' AS record_type,
  NVL(mc.concurrent_request_id,0)||'-'||mc.mass_change_id as MASS_SPEC,
  mc.LAST_UPDATE_DATE EID_LAST_UPDATE_DATE,
  mc.concurrent_request_id request_num,
  mc.mass_change_id Trans_num,
  NVL(bc.ORG_ID,-9999) AS ORG_ID,
  bc.book_type_code book_code,
  bc.book_type_name Book_Name,
  mc.transaction_date_entered Trans_date,
  '' AS asset_category,
  '' AS major_category,
  '' AS minor_category,
  '' AS Trans_Description
  ,lo.meaning as Trans_Status
  ,mc.status as TRANS_STATUS_CODE
  ,'' as Transfer_Type
  ,( Case When mc.FROM_DATE_PLACED_IN_SERVICE <> mc.TO_DATE_PLACED_IN_SERVICE Then (SELECT MEANING FROM FA_LOOKUPS WHERE LOOKUP_TYPE='FA_EID_MASS_CHANGE_TYPE' AND LOOKUP_CODE='DPIS_CHANGE') ||'|' ELSE '' END)||
  ( CASE When MC.FROM_CONVENTION <> mc.TO_CONVENTION Then (SELECT MEANING FROM FA_LOOKUPS WHERE LOOKUP_TYPE='FA_EID_MASS_CHANGE_TYPE' AND LOOKUP_CODE='PRORATE_CONVENTION_CHANGE') ||'|' ELSE '' END)||
  ( CASE When mc.FROM_LIFE_IN_MONTHS <> mc.TO_LIFE_IN_MONTHS Then (SELECT MEANING FROM FA_LOOKUPS WHERE LOOKUP_TYPE='FA_EID_MASS_CHANGE_TYPE' AND LOOKUP_CODE='ASSET_LIFE_CHANGE') ||'|' ELSE '' END)||
  ( CASE When mc.FROM_METHOD_CODE <> mc.TO_METHOD_CODE Then (SELECT MEANING FROM FA_LOOKUPS WHERE LOOKUP_TYPE='FA_EID_MASS_CHANGE_TYPE' AND LOOKUP_CODE='DEPRECIATION_METHOD_CHANGE') ||'|' ELSE '' END) ||
  ( CASE When mc.FROM_BASIC_RATE <> mc.FROM_ADJUSTED_RATE Then (SELECT MEANING FROM FA_LOOKUPS WHERE LOOKUP_TYPE='FA_EID_MASS_CHANGE_TYPE' AND LOOKUP_CODE='DEPRECIATION_RATE_CHANGE') ||'|' ELSE '' END) ||
  ( CASE When mc.FROM_PRODUCTION_CAPACITY <> mc.TO_PRODUCTION_CAPACITY Then (SELECT MEANING FROM FA_LOOKUPS WHERE LOOKUP_TYPE='FA_EID_MASS_CHANGE_TYPE' 
    AND LOOKUP_CODE='PRODUCTION_CAPACITY_CHANGE') ||'|' ELSE '' END) ||
  ( CASE When mc.FROM_UOM <> mc.TO_UOM Then (SELECT MEANING FROM FA_LOOKUPS WHERE LOOKUP_TYPE='FA_EID_MASS_CHANGE_TYPE' AND LOOKUP_CODE='UNIT_CHANGE') ||'|' ELSE '' END )||
  ( CASE When mc.FROM_GROUP_ASSOCIATION <> mc.TO_GROUP_ASSOCIATION Then (SELECT MEANING FROM FA_LOOKUPS WHERE LOOKUP_TYPE='FA_EID_MASS_CHANGE_TYPE' AND LOOKUP_CODE='GROUP_ASSOCIATION_CHANGE') ||'|' ELSE '' END) ||
  ( CASE When mc.FROM_SALVAGE_TYPE <> mc.TO_SALVAGE_TYPE or mc.FROM_PERCENT_SALVAGE_VALUE <> mc.TO_PERCENT_SALVAGE_VALUE or mc.FROM_SALVAGE_VALUE <> mc.FROM_SALVAGE_VALUE Then (SELECT MEANING FROM FA_LOOKUPS WHERE LOOKUP_TYPE='FA_EID_MASS_CHANGE_TYPE' AND LOOKUP_CODE='SALVAGE_VALUE_CHANGE') ||'|' ELSE '' END) ||
  ( CASE When mc.FROM_DEPRN_LIMIT_TYPE <> mc.TO_DEPRN_LIMIT_TYPE or mc.TO_DEPRN_LIMIT <> mc.TO_DEPRN_LIMIT or mc.FROM_DEPRN_LIMIT_AMOUNT <> mc.TO_DEPRN_LIMIT_AMOUNT Then (SELECT MEANING FROM FA_LOOKUPS WHERE LOOKUP_TYPE='FA_EID_MASS_CHANGE_TYPE' AND LOOKUP_CODE='DEPRECIATION_LIMIT_CHANGE')   ELSE (SELECT MEANING FROM FA_LOOKUPS WHERE LOOKUP_TYPE='FA_EID_MASS_CHANGE_TYPE' AND LOOKUP_CODE='NO_CHANGE_DET')  END )
   
AS Change_Type
    
  /* Union Attributes*/ 
  ,'' as asset_number
  ,'' as asset_description    
  ,'' as addition_Accounting_Year 
  ,'' as addition_Month_Year   
  ,to_number('') as addition_cost  
  ,to_number('') as addition_units
  ,'' as addition_source_name
  ,to_number('') as addition_batch_id 
  ,to_date('') as addition_batch_date 
  ,'' as addition_po_number  
  ,to_number('') as addition_inv_id 
  ,'' as addition_inv_number  
  ,to_date('') as addition_inv_date 
  ,to_number('') as addition_inv_line_number 
  ,'' as addition_inv_Description 
  ,'' as addition_supplier_Number  
  ,'' as addition_supplier_name  
  ,'' as addition_Proj_Name 
  ,'' as addition_proj_task  
  , mc.AMORTIZE_FLAG Amortized
  --Mass Change DFF
  ,mc.ATTRIBUTE_CATEGORY_CODE
 ,NULL AS CONTEXT 
  ,mc.ATTRIBUTE1
  ,mc.ATTRIBUTE2
  ,mc.ATTRIBUTE3
  ,mc.ATTRIBUTE4
  ,mc.ATTRIBUTE5
  ,mc.ATTRIBUTE6
  ,mc.ATTRIBUTE7
  ,mc.ATTRIBUTE8
  ,mc.ATTRIBUTE9
  ,mc.ATTRIBUTE10
  ,mc.ATTRIBUTE11
  ,mc.ATTRIBUTE12
  ,mc.ATTRIBUTE13
  ,mc.ATTRIBUTE14
  ,mc.ATTRIBUTE15
  ,null as ATTRIBUTE16
  ,null as ATTRIBUTE17
  ,null as ATTRIBUTE18
  ,null as ATTRIBUTE19
  ,null as ATTRIBUTE20
  ,null as ATTRIBUTE21
  ,null as ATTRIBUTE22
  ,null as ATTRIBUTE23
  ,null as ATTRIBUTE24
  ,null as ATTRIBUTE25
  ,null as ATTRIBUTE26
  ,null as ATTRIBUTE27
  ,null as ATTRIBUTE28
  ,null as ATTRIBUTE29
  ,null as ATTRIBUTE30
from
  fa_mass_changes mc,
  FA_BOOK_CONTROLS bc,
  FA_LOOKUPS lo
where
  mc.book_type_code = bc.book_type_code
  and bc.book_class = 'CORPORATE'
  and bc.date_ineffective IS NULL
  and mc.status <> 'COMPLETED'
  and lo.lookup_type='MASS_TRX_STATUS'
  and lo.enabled_flag='Y'
  and mc.status = lo.lookup_code
union all
-- Asset Reclassification
select
  'Asset Reclass' AS record_type,
  NVL(mr.concurrent_request_id, 0)||'-'||mr.MASS_RECLASS_ID as MASS_SPEC,
  mr.LAST_UPDATE_DATE EID_LAST_UPDATE_DATE,
  mr.concurrent_request_id request_num,
  mr.MASS_RECLASS_ID Trans_num,
  NVL(bc.ORG_ID,-9999) AS ORG_ID,
  mr.book_type_code book_code,
  bc.book_type_name Book_Name,
  mr.transaction_date_entered Trans_date,
'' AS asset_category,
  '' AS major_category,
  '' AS minor_category,
  '' AS Trans_Description
  ,lo.meaning trans_status
  ,mr.status trans_status_code
   ,'' as Transfer_Type
   ,'' AS Change_Type 
  /* Union Attributes*/ 
  ,'' as asset_number
  ,'' as asset_description    
  ,'' as addition_Accounting_Year 
  ,'' as addition_Month_Year   
  ,to_number('') as addition_cost  
  ,to_number('') as addition_units
  ,'' as addition_source_name
  ,to_number('') as addition_batch_id 
  ,to_date('') as addition_batch_date 
  ,'' as addition_po_number  
  ,to_number('') as addition_inv_id 
  ,'' as addition_inv_number  
  ,to_date('') as addition_inv_date 
  ,to_number('') as addition_inv_line_number 
  ,'' as addition_inv_Description 
  ,'' as addition_supplier_Number  
  ,'' as addition_supplier_name  
  ,'' as addition_Proj_Name 
  ,'' as addition_proj_task  
  , mr.AMORTIZE_FLAG Amortized
  --Mass Reclassification DFF
  ,mr.ATTRIBUTE_CATEGORY_CODE
  ,NULL AS CONTEXT 
  ,mr.ATTRIBUTE1
  ,mr.ATTRIBUTE2
  ,mr.ATTRIBUTE3
  ,mr.ATTRIBUTE4
  ,mr.ATTRIBUTE5
  ,mr.ATTRIBUTE6
  ,mr.ATTRIBUTE7
  ,mr.ATTRIBUTE8
  ,mr.ATTRIBUTE9
  ,mr.ATTRIBUTE10
  ,mr.ATTRIBUTE11
  ,mr.ATTRIBUTE12
  ,mr.ATTRIBUTE13
  ,mr.ATTRIBUTE14
  ,mr.ATTRIBUTE15
  ,NULL AS ATTRIBUTE16
  ,NULL AS ATTRIBUTE17
  ,NULL AS ATTRIBUTE18
  ,NULL AS ATTRIBUTE19
  ,NULL AS ATTRIBUTE20
  ,NULL AS ATTRIBUTE21
  ,NULL AS ATTRIBUTE22
  ,NULL AS ATTRIBUTE23
  ,NULL AS ATTRIBUTE24
  ,NULL AS ATTRIBUTE25
  ,NULL AS ATTRIBUTE26
  ,NULL AS ATTRIBUTE27
  ,NULL AS ATTRIBUTE28
  ,NULL AS ATTRIBUTE29
  ,NULL AS ATTRIBUTE30
  
from
  FA_MASS_RECLASS mr,
  FA_BOOK_CONTROLS bc,
  FA_LOOKUPS lo
where
     mr.BOOK_TYPE_CODE = bc.BOOK_TYPE_CODE
and bc.book_class = 'CORPORATE'
and bc.date_ineffective IS NULL	 
AND  mr.status <> 'COMPLETED'
and lo.lookup_type='MASS_TRX_STATUS'
and lo.enabled_flag='Y'
and mr.status = lo.lookup_code
union all
-- Asset Mass Retirements
select
  'Asset Retirement' AS record_type,
  NVL(mt.RETIRE_REQUEST_ID,0)||'-'||mt.MASS_RETIREMENT_ID as MASS_SPEC,
  mt.LAST_UPDATE_DATE EID_LAST_UPDATE_DATE,
  mt.RETIRE_REQUEST_ID request_num,
  mt.MASS_RETIREMENT_ID Trans_num,
  NVL(bc.ORG_ID,-9999) AS ORG_ID,
  mt.book_type_code book_code,
  bc.book_type_name Book_Name,
  mt.RETIREMENT_DATE Trans_date,
  '' AS asset_category,
  '' AS major_category,
  '' AS minor_category,
  '' AS Trans_Description
  ,lo.meaning trans_status
  ,mt.status trans_status_code
   ,'' as Transfer_Type
   ,'' AS Change_Type 
  /* Union Attributes*/ 
  ,'' as asset_number
  ,'' as asset_description    
  ,'' as addition_Accounting_Year 
  ,'' as addition_Month_Year   
  ,to_number('') as addition_cost  
  ,to_number('') as addition_units
  ,'' as addition_source_name
  ,to_number('') as addition_batch_id 
  ,to_date('') as addition_batch_date 
  ,'' as addition_po_number  
  ,to_number('') as addition_inv_id 
  ,'' as addition_inv_number  
  ,to_date('') as addition_inv_date 
  ,to_number('') as addition_inv_line_number 
  ,'' as addition_inv_Description 
  ,'' as addition_supplier_Number  
  ,'' as addition_supplier_name  
  ,'' as addition_Proj_Name 
  ,'' as addition_proj_task
  ,'' as Amortized
  --Mass retirements DFF
  ,mt.ATTRIBUTE_CATEGORY_CODE
 ,NULL AS CONTEXT 
  ,mt.ATTRIBUTE1
  ,mt.ATTRIBUTE2
  ,mt.ATTRIBUTE3
  ,mt.ATTRIBUTE4
  ,mt.ATTRIBUTE5
  ,mt.ATTRIBUTE6
  ,mt.ATTRIBUTE7
  ,mt.ATTRIBUTE8
  ,mt.ATTRIBUTE9
  ,mt.ATTRIBUTE10
  ,mt.ATTRIBUTE11
  ,mt.ATTRIBUTE12
  ,mt.ATTRIBUTE13
  ,mt.ATTRIBUTE14
  ,mt.ATTRIBUTE15
  ,NULL AS ATTRIBUTE16
  ,NULL AS ATTRIBUTE17
  ,NULL AS ATTRIBUTE18
  ,NULL AS ATTRIBUTE19
  ,NULL AS ATTRIBUTE20
  ,NULL AS ATTRIBUTE21
  ,NULL AS ATTRIBUTE22
  ,NULL AS ATTRIBUTE23
  ,NULL AS ATTRIBUTE24
  ,NULL AS ATTRIBUTE25
  ,NULL AS ATTRIBUTE26
  ,NULL AS ATTRIBUTE27
  ,NULL AS ATTRIBUTE28
  ,NULL AS ATTRIBUTE29
  ,NULL AS ATTRIBUTE30
  
from
  FA_MASS_RETIREMENTS mt,
  FA_BOOK_CONTROLS bc,
  FA_LOOKUPS lo
where
     mt.BOOK_TYPE_CODE = bc.BOOK_TYPE_CODE
	 and bc.book_class = 'CORPORATE'
and bc.date_ineffective IS NULL
AND  mt.status <> 'COMPLETED'
and lo.lookup_type='MASS_TRX_STATUS'
and lo.enabled_flag='Y'
and mt.status = lo.lookup_code

union all
-- Assets Mass Additions
SELECT
  'Mass Additions' AS record_type,
  ma.MASS_ADDITION_ID || ''  as MASS_SPEC,
  ma.LAST_UPDATE_DATE EID_LAST_UPDATE_DATE,
  to_number('') as Request_num,
  to_number('') as Trans_num,
  NVL(fbc.ORG_ID,-9999) AS ORG_ID,
  ma.book_type_code as book_code,
  fbc.book_type_name Book_Name,
  ma.accounting_date as trans_date,
  decode(fc.category_id,NULL,NULL,
  fnd_flex_xml_publisher_apis.process_kff_combination_1(p_lexical_name           => 'AssetCategory' , 
                                                             p_application_short_name => 'OFA', 
                                                             p_id_flex_code => 'CAT#', 
                                                             p_id_flex_num => fsc.category_flex_structure, 
                                                             p_data_set    => fsc.category_flex_structure, 
                                                             p_ccid        => fc.category_id,
                                                             p_segments    => 'BASED_CATEGORY',
                                                             p_show_parent_segments => 'N',
                                                             p_output_type=>'DESCRIPTION')
                                                             )  major_Category
  ,decode(fc.category_id,NULL,NULL,
  fnd_flex_xml_publisher_apis.process_kff_combination_1(p_lexical_name           => 'AssetCategory' , 
                                                             p_application_short_name => 'OFA', 
                                                             p_id_flex_code => 'CAT#', 
                                                             p_id_flex_num => fsc.category_flex_structure, 
                                                             p_data_set    => fsc.category_flex_structure, 
                                                             p_ccid        => fc.category_id,
                                                             p_segments    => 'MINOR_CATEGORY',
                                                             p_show_parent_segments => 'N',
                                                             p_output_type=>'DESCRIPTION'))  minor_Category,
decode(fc.category_id,NULL,NULL,
  fnd_flex_xml_publisher_apis.process_kff_combination_1(p_lexical_name           => 'AssetCategory' , 
                                                             p_application_short_name => 'OFA', 
                                                             p_id_flex_code => 'CAT#', 
                                                             p_id_flex_num => fsc.category_flex_structure, 
                                                             p_data_set    => fsc.category_flex_structure, 
                                                             p_ccid        => fc.category_id,
                                                             p_segments    => 'ALL',
                                                             p_show_parent_segments => 'N',
                                                             p_output_type=>'DESCRIPTION'))  asset_Category                                                                                                                        
  ,'' as Trans_Description
  ,lo.meaning trans_status
  ,ma.queue_name as Trans_Status_code
   ,'' as Transfer_Type
   ,'' AS Change_Type 
  ,ma.asset_number as asset_number
  ,ma.description as asset_description
  ,to_char(ma.accounting_date,'yyyy') as addition_Accounting_Year 
  ,to_char(ma.accounting_date,'MM-YYYY') as addition_Month_Year   
  ,ma.fixed_assets_cost as addition_cost  
  ,ma.fixed_assets_units as addition_units
  ,ma.feeder_system_name as addition_source_name
  
  --Payable Mass Addition
  ,ma.create_batch_id as addition_batch_id 
  ,ma.CREATE_BATCH_DATE as addition_batch_date 
  ,ma.po_number as addition_po_number  
  ,ma.invoice_id as addition_inv_id 
  ,ma.invoice_number as addition_inv_number  
  ,ma.invoice_date as addition_inv_date 
  ,ma.invoice_line_number as addition_inv_line_number 
  ,ma.description as addition_inv_Description 
  ,po.segment1 as addition_supplier_Number  
  ,po.vendor_name as addition_supplier_name  
    
  -- project Mass Addition    
  ,pj.name as addition_Proj_Name 
  ,pt.task_number as addition_proj_task  
  ,ma.AMORTIZE_FLAG Amortized
  --Mass Additions DFF
  ,ma.ATTRIBUTE_CATEGORY_CODE
  ,ma.CONTEXT 
  ,ma.ATTRIBUTE1
  ,ma.ATTRIBUTE2
  ,ma.ATTRIBUTE3
  ,ma.ATTRIBUTE4
  ,ma.ATTRIBUTE5
  ,ma.ATTRIBUTE6
  ,ma.ATTRIBUTE7
  ,ma.ATTRIBUTE8
  ,ma.ATTRIBUTE9
  ,ma.ATTRIBUTE10
  ,ma.ATTRIBUTE11
  ,ma.ATTRIBUTE12
  ,ma.ATTRIBUTE13
  ,ma.ATTRIBUTE14
  ,ma.ATTRIBUTE15
  ,ma.ATTRIBUTE16
  ,ma.ATTRIBUTE17
  ,ma.ATTRIBUTE18
  ,ma.ATTRIBUTE19
  ,ma.ATTRIBUTE20
  ,ma.ATTRIBUTE21
  ,ma.ATTRIBUTE22
  ,ma.ATTRIBUTE23
  ,ma.ATTRIBUTE24
  ,ma.ATTRIBUTE25
  ,ma.ATTRIBUTE26
  ,ma.ATTRIBUTE27
  ,ma.ATTRIBUTE28
  ,ma.ATTRIBUTE29
  ,ma.ATTRIBUTE30
  
from 
   ap_suppliers po  
  ,fa_additions_b ad  
  ,fa_mass_additions ma  
  ,fa_warranties war  
  ,fa_additions_b gad 
  ,pa_projects_all pj 
  ,pa_tasks pt
  ,FA_CATEGORIES_B fc
  ,FA_BOOK_CONTROLS fbc
  ,FA_DEPRN_PERIODS fdp1
  ,FA_DEPRN_PERIODS fdp2
  ,GL_LEDGERS LGR    
  ,fa_system_controls fsc
  ,fa_lookups lo

WHERE 

  fbc.book_type_code = fdp1.book_type_code
  and fbc.book_class = 'CORPORATE'
  and fbc.date_ineffective IS NULL
  and fbc.set_of_books_id = LGR.LEDGER_ID
  AND LGR.OBJECT_TYPE_CODE = 'L'
  AND NVL(LGR.COMPLETE_FLAG, 'Y') = 'Y' 
  and fbc.last_period_counter = fdp1.period_counter
  and fbc.book_type_code = fdp2.book_type_code
  and fbc.last_period_counter+1 = fdp2.period_counter
  and fbc.date_ineffective is null    
  and ma.book_type_code = fbc.book_type_code
  and ma.asset_category_id = fc.CATEGORY_ID (+)
  and ma.project_id = pj.project_id ( + )
  and ma.task_id = pt.task_id ( + )
  and ma.po_vendor_id = po.vendor_id ( + ) 
  and ma.parent_asset_id = ad.asset_id ( + ) 
  and ma.warranty_id = war.warranty_id (+) 
  and gad.asset_id (+) = ma.group_asset_id
  and ma.queue_name <> 'POSTED'
  and lo.lookup_type='MASS_TRX_STATUS'
  and lo.enabled_flag='Y'
  and ma.queue_name = lo.lookup_code
  and ma.post_batch_id is NULL
   ;
