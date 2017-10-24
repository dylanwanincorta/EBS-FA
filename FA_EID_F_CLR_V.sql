CREATE OR REPLACE FORCE EDITIONABLE VIEW "APPS"."FA_EID_F_CLR_V" ("SOURCE", "CLR_SPEC", "ORG_ID", "LEDGER_NAME", "PERIOD_NAME", "BOOK_TYPE_CODE", "ASSET_CATEGORY_ID", "ASSETS_ADDITION_FLAG", "ASSETS_TRACKING_FLAG", "ASSET_CATEGORY", "OPERATING_UNIT", "CIP_CCID", "CLEARING_ACCOUNT_CCID", "CODE_COMBINATION_ID", "GL_ACC_CODE", "GL_ACC_DESCRIPTION", "FUNCTIONAL_CURRENCY", "GL_DATE", "PROJECT_ID", "PROJECT_NAME", "PROJECT_STATUS_CODE", "PROJECT_TYPE", "PROJECT_DESCRIPTION", "PROJECT_CURRENCY_CODE", "PROJECT_RATE_TYPE", "PROJECT_RATE_DATE", "PROJECT_CURRENCY_RATE", "PROJECT_ASSET_ID", "PROJECT_ASSET_LINE_ID", "PROJECT_ASSET_LINE_DETAIL_ID", "PROJECT_ORIGINAL_ASSET_COST", "PROJ_ORIG_ACCT_ASSET_COST", "PROJ_CURRENT_ASSET_COST", "PROJ_CURR_ACCT_ASSET_COST", "PROJ_ASSET_LINE_DESC", "PROJ_ASSET_NUMBER", "PROJ_TRANS_STATUS_CODE", "PROJ_TRANS_STATUS", "PROJ_TRANS_REJ_REASON", "PROJECT_ASSET_TYPE", "PROJ_ASSET_NAME", "PROJ_TASK_ID", "PROJ_TASK_NUMBER", "PROJ_TASK_NAME", "REV_PROJ_ASSET_LINE_ID", "INVOICE_ID", "INVOICE_NUM", "VENDOR_ID", "SUPPLIER_NAME", "INVOICE_DATE", "INV_APPROVAL_STATUS_CODE", "INV_APPROVAL_STATUS", "INV_VALIDATION_STATUS", "INV_VALIDATION_STATUS_CODE", "INV_POSTING_FLAG", "INV_POSTING_STATUS_CODE", "PO_NUMBER", "PO_NUMBER_DISPLAY", "RELEASE_NUMBER", "RELEASE_NUMBER_DISPLAY", "RECEIPT_NUMBER", "RECEIPT_NUMBER_DISPLAY", "INVL_LINE_NUMBER", "INVOICE_DISTRIBUTION_ID", "DISTRIBUTION_LINE_NUMBER", "INV_DIST_DESC", "INV_ROUND_AMOUNT", "INVOICE_CURRENCY_CODE", "INV_EXCHANGE_RATE", "INV_EXCHANGE_RATE_TYPE", "INV_EXCHANGE_DATE", "INV_ACCOUNTED_AMOUNT") AS 
  SELECT 
       'Invoice' AS SOURCE
       , 'INV'|| '-'|| inv.invoice_id|| '-'|| invl.line_number|| '-'|| invd.invoice_distribution_id AS clr_spec
       , NVL (inv.org_id, -9999) AS org_id
       , lgr.NAME AS ledger_name
       , ap_invoices_pkg.get_period_name (inv.gl_date,NULL,inv.org_id) period_name
       , invd.asset_book_type_code AS book_type_code
       , invd.asset_category_id
       , invd.assets_addition_flag
       , invd.assets_tracking_flag
       , fc.description AS asset_category
       , OU.NAME AS operating_unit
       , NULL AS cip_ccid
       , invd.dist_code_combination_id AS clearing_account_ccid
       , cc.code_combination_id
       , DECODE(invd.dist_code_combination_id,NULL, NULL,
                fnd_flex_xml_publisher_apis.process_kff_combination_1
                                   (p_lexical_name                => 'ACCOUNT CODE',
                                    p_application_short_name      => 'SQLGL',
                                    p_id_flex_code                => 'GL#',
                                    p_id_flex_num                 => lgr.chart_of_accounts_id,
                                    p_data_set                    => lgr.chart_of_accounts_id,
                                    p_ccid                        => invd.dist_code_combination_id,
                                    p_segments                    => 'GL_ACCOUNT',
                                    p_show_parent_segments        => 'Y',
                                    p_output_type                 => 'VALUE'
                                   )) AS gl_acc_code
       , DECODE(invd.dist_code_combination_id,NULL, NULL,
                fnd_flex_xml_publisher_apis.process_kff_combination_1
                                   (p_lexical_name                => 'ACCOUNT CODE',
                                    p_application_short_name      => 'SQLGL',
                                    p_id_flex_code                => 'GL#',
                                    p_id_flex_num                 => lgr.chart_of_accounts_id,
                                    p_data_set                    => lgr.chart_of_accounts_id,
                                    p_ccid                        => invd.dist_code_combination_id,
                                    p_segments                    => 'GL_ACCOUNT',
                                    p_show_parent_segments        => 'Y',
                                    p_output_type                 => 'DESCRIPTION'
                                   )) AS gl_acc_description
       , lgr.currency_code AS functional_currency
       , inv.gl_date
       , NULL AS project_id
       , NULL AS project_name
       , NULL AS project_status_code
       , NULL AS project_type
       , NULL AS project_description
       , NULL AS project_currency_code
       , NULL AS project_rate_type
       , NULL AS project_rate_date
       , NULL AS project_currency_rate
       , NULL AS project_asset_id
       , NULL AS project_asset_line_id
       , NULL AS project_asset_line_detail_id
       , NULL AS project_original_asset_cost
       , NULL AS proj_orig_acct_asset_cost
       , NULL AS proj_current_asset_cost
       , NULL AS proj_curr_acct_asset_cost
       , NULL AS proj_asset_line_desc
       , NULL AS proj_asset_number
       , Null As Proj_Trans_Status_Code
       ,NULL AS proj_trans_status
       , NULL AS proj_trans_rej_reason
       , NULL AS project_asset_type
       , NULL AS proj_asset_name
       , NULL AS proj_task_id
       , NULL AS proj_task_number
       , NULL AS proj_task_name
       , NULL AS rev_proj_asset_line_id
       , inv.invoice_id
       , inv.invoice_num
       , inv.vendor_id
       , aps.vendor_name as supplier_name
       , inv.invoice_date
       ,inv.wfapproval_status inv_approval_status_code
	   ,( SELECT DISPLAYED_FIELD FROM AP_LOOKUP_CODES WHERE LOOKUP_TYPE='AP_WFAPPROVAL_STATUS' AND LOOKUP_CODE = inv.wfapproval_status AND ENABLED_FLAG='Y' ) AS inv_approval_status
       , ( SELECT DISPLAYED_FIELD FROM AP_LOOKUP_CODES WHERE LOOKUP_TYPE='APPROVAL' AND LOOKUP_CODE = ap_invoices_pkg.get_approval_status (inv.invoice_id,inv.invoice_amount,inv.payment_status_flag,inv.invoice_type_lookup_code) AND ENABLED_FLAG='Y')inv_validation_status
	   ,ap_invoices_pkg.get_approval_status (inv.invoice_id,inv.invoice_amount,inv.payment_status_flag,inv.invoice_type_lookup_code) inv_validation_status_code
       , ( SELECT DISPLAYED_FIELD FROM AP_LOOKUP_CODES WHERE LOOKUP_TYPE='POSTING STATUS' AND LOOKUP_CODE = ap_invoices_pkg.get_posting_status (inv.invoice_id) AND ENABLED_FLAG='Y') inv_posting_flag
	   ,ap_invoices_pkg.get_posting_status (inv.invoice_id)  inv_posting_status_code
	   , ap_invoices_pkg.get_po_number (inv.invoice_id) po_number
	   , ( SELECT DISPLAYED_FIELD FROM AP_LOOKUP_CODES WHERE LOOKUP_TYPE='AP_ISP_INV_CREATION_TYPE' AND LOOKUP_CODE = ap_invoices_pkg.get_po_number (inv.invoice_id) AND ENABLED_FLAG='Y') po_number_display
       , ap_invoices_pkg.get_release_number (inv.invoice_id) release_number
	   , ( SELECT DISPLAYED_FIELD FROM AP_LOOKUP_CODES WHERE LOOKUP_TYPE='AP_ISP_INV_CREATION_TYPE' AND LOOKUP_CODE =  ap_invoices_pkg.get_release_number (inv.invoice_id) AND ENABLED_FLAG='Y') release_number_display
       , ap_invoices_pkg.get_receipt_number (inv.invoice_id) receipt_number
	   , ( SELECT DISPLAYED_FIELD FROM AP_LOOKUP_CODES WHERE LOOKUP_TYPE='AP_ISP_INV_CREATION_TYPE' AND LOOKUP_CODE =  ap_invoices_pkg.get_receipt_number (inv.invoice_id)  AND ENABLED_FLAG='Y') receipt_number_display
       , invl.line_number AS invl_line_number, invd.invoice_distribution_id
       , invd.distribution_line_number
       , invd.description AS inv_dist_desc
       , NVL(gl_mc_currency_pkg.currround (invd.amount, lgr.currency_code), 0) AS inv_round_amount
       , inv.invoice_currency_code
       , NVL (inv.exchange_rate, 1) AS inv_exchange_rate
       , inv.exchange_rate_type AS inv_exchange_rate_type
       , inv.exchange_date AS inv_exchange_date
       , NVL(gl_mc_currency_pkg.currround ((  invd.amount* NVL (inv.exchange_rate, 1)),lgr.currency_code),0) AS inv_accounted_amount
  FROM ap_invoices_all inv,
       ap_invoice_lines_all invl,
       ap_invoice_distributions_all invd,
       ap_suppliers aps,
       gl_ledgers lgr,
       hr_operating_units OU,
       gl_code_combinations cc,
       fa_categories fc
       
 WHERE inv.invoice_id = invl.invoice_id
   AND ap_invoices_pkg.get_approval_status (inv.invoice_id,inv.invoice_amount,inv.payment_status_flag,inv.invoice_type_lookup_code) <> 'NEVER APPROVED' 
   AND invl.invoice_id = invd.invoice_id
   AND invl.line_number = invd.invoice_line_number
   AND invd.assets_tracking_flag = 'Y'
   AND invd.assets_addition_flag = 'U'
   AND inv.vendor_id = aps.vendor_id
   AND invd.asset_category_id = fc.category_id(+)
   AND INV.ORG_ID = OU.ORGANIZATION_ID(+)
   AND OU.SET_OF_BOOKS_ID = LGR.LEDGER_ID
   AND invd.dist_code_combination_id = cc.code_combination_id
   AND NOT EXISTS (
          SELECT DISTINCT fai.invoice_id
                     FROM fa_asset_invoices fai
                    WHERE fai.invoice_id = invd.invoice_id
                      AND fai.date_ineffective IS NULL
                      AND fai.invoice_transaction_id_out IS NULL)
   AND NOT EXISTS (SELECT DISTINCT fma.invoice_id
                              FROM fa_mass_additions fma
                             WHERE fma.invoice_id = invd.invoice_id)
   AND lgr.object_type_code = 'L'
   AND NVL (lgr.complete_flag, 'Y') = 'Y' 
   AND lgr.ledger_id = invd.set_of_books_id
   AND EXISTS (
          SELECT *
            FROM fa_category_books cb
           WHERE cb.wip_clearing_account_ccid = invd.dist_code_combination_id
              OR cb.asset_clearing_account_ccid = invd.dist_code_combination_id)
UNION ALL
SELECT 
       'Project' AS SOURCE
       , 'PROJ'|| '-'|| paa.project_id|| '-'|| paa.project_asset_id|| '-'|| pal.project_asset_line_id|| '-'|| pal.project_asset_line_detail_id AS clr_spec
       , NVL (pal.org_id, -9999) org_id
       , lgr.NAME AS ledger_name
       , pal.fa_period_name AS period_name
       , paa.book_type_code
       , pal.asset_category_id
       , NULL AS assets_addition_flag
       , NULL AS assets_tracking_flag
       , fc.description AS asset_category
       , OU.NAME AS operating_unit
       , pal.cip_ccid
       , NULL AS clearing_account_ccid
       , cc.code_combination_id
       , DECODE(pal.cip_ccid,NULL, NULL,
                fnd_flex_xml_publisher_apis.process_kff_combination_1
                                    (p_lexical_name                => 'ACCOUNT CODE',
                                     p_application_short_name      => 'SQLGL',
                                     p_id_flex_code                => 'GL#',
                                     p_id_flex_num                 => cc.chart_of_accounts_id,
                                     p_data_set                    => cc.chart_of_accounts_id,
                                     p_ccid                        => pal.cip_ccid,
                                     p_segments                    => 'GL_ACCOUNT',
                                     p_show_parent_segments        => 'Y',
                                     p_output_type                 => 'VALUE'
                                    )) AS gl_acc_code
       , DECODE(pal.cip_ccid,NULL, NULL,
                fnd_flex_xml_publisher_apis.process_kff_combination_1
                                    (p_lexical_name                => 'ACCOUNT CODE',
                                     p_application_short_name      => 'SQLGL',
                                     p_id_flex_code                => 'GL#',
                                     p_id_flex_num                 => cc.chart_of_accounts_id,
                                     p_data_set                    => cc.chart_of_accounts_id,
                                     p_ccid                        => pal.cip_ccid,
                                     p_segments                    => 'GL_ACCOUNT',
                                     p_show_parent_segments        => 'Y',
                                     p_output_type                 => 'DESCRIPTION'
                                    )) AS gl_acc_description
       , lgr.currency_code AS functional_currency
       , pal.gl_date
       , paa.project_id
       , pp.NAME AS project_name
       , pp.project_status_code
       , pp.project_type
       , pp.description AS project_description
       , pp.project_currency_code
       , pp.project_rate_type
       , pp.project_rate_date
       , gl_currency_api.get_rate(pp.project_currency_code,NVL (lgr.currency_code, pp.project_currency_code),pp.project_rate_date,pp.project_rate_type) AS project_currency_rate
       , pal.project_asset_id
       , pal.project_asset_line_id
       , pal.project_asset_line_detail_id
       , pal.original_asset_cost AS project_original_asset_cost
       , NVL(gl_mc_currency_pkg.currround((  pal.original_asset_cost* NVL(gl_currency_api.get_rate (pp.project_currency_code,NVL (lgr.currency_code,pp.project_currency_code),pp.project_rate_date,pp.project_rate_type),1)),lgr.currency_code),0) AS proj_orig_acct_asset_cost
       , pal.current_asset_cost AS proj_current_asset_cost
       , NVL(gl_mc_currency_pkg.currround((  pal.current_asset_cost* NVL(gl_currency_api.get_rate (pp.project_currency_code,NVL (lgr.currency_code,pp.project_currency_code),pp.project_rate_date,pp.project_rate_type),1)),lgr.currency_code),0) AS proj_curr_acct_asset_cost
       , pal.description AS proj_asset_line_desc
       , paa.asset_number AS proj_asset_number
       , Pal.Transfer_Status_Code As Proj_Trans_Status_Code
	   , ( SELECT MEANING FROM PA_LOOKUPS WHERE LOOKUP_TYPE='PROJECT STATUS' AND LOOKUP_CODE = pal.transfer_status_code AND ENABLED_FLAG='Y' ) proj_trans_status
       , transfer_rejection_reason AS proj_trans_rej_reason
       , paa.project_asset_type
       , paa.asset_name AS proj_asset_name
       , pal.task_id AS proj_task_id
       , pt.task_number AS proj_task_number
       , pt.task_name AS proj_task_name
       , pal.rev_proj_asset_line_id
       , NULL AS invoice_id
       , NULL AS invoice_num
       , NULL AS vendor_id
       , NULL AS vendor_name
       , Null As Invoice_Date
       ,NULL AS inv_approval_status_code
       , Null As Inv_Approval_Status
       , Null As Inv_Validation_Status_Code
       , NULL AS inv_validation_status
       , Null As Inv_Posting_Flag
       ,NULL AS inv_posting_status_code
       , Null As Po_Number
       ,NULL AS PO_NUMBER_DISPLAY
       , Null As Release_Number
       ,NULL AS  release_number_display
       , Null As Receipt_Number
       ,NULL AS Receipt_Number_display
       , NULL AS invl_line_number
       , NULL AS invoice_distribution_id
       , NULL AS distribution_line_number
       , NULL AS inv_dist_desc
       , NULL AS inv_round_amount
       , NULL AS invoice_currency_code
       , NULL AS inv_exchange_rate
       , NULL AS inv_exchange_rate_type
       , NULL AS inv_exchange_date
       , NULL AS inv_accounted_amount
  FROM pa_projects_all pp
       ,pa_project_asset_lines_all pal
       ,pa_tasks pt
       ,pa_project_assets_all paa
       ,fa_categories fc
       ,gl_ledgers lgr
       ,hr_operating_units OU
       ,gl_code_combinations cc
       ,PA_PERIODS_ALL PAP
 WHERE pp.project_id = pal.project_id
   AND pal.project_asset_id = paa.project_asset_id(+)
   AND pal.task_id = pt.task_id
   AND pal.asset_category_id = fc.category_id(+)
   AND pal.org_id = OU.ORGANIZATION_ID(+)
   AND OU.SET_OF_BOOKS_ID = LGR.LEDGER_ID
   AND pal.cip_ccid = cc.code_combination_id
   AND NOT EXISTS (SELECT DISTINCT fma.project_asset_line_id
                              FROM fa_mass_additions fma
                             WHERE fma.invoice_id = pal.project_asset_line_id)
   AND NOT EXISTS (SELECT DISTINCT fa.asset_id
                              FROM fa_additions_b fa
                             WHERE fa.asset_id = paa.fa_asset_id)
AND PAL.ORG_ID = PAP.ORG_ID
AND PAL.GL_DATE BETWEEN PAP.START_DATE AND PAP.END_DATE
;
