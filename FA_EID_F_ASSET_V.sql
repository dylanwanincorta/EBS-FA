CREATE OR REPLACE FORCE EDITIONABLE VIEW "APPS"."FA_EID_F_ASSET_V" ("ASSET_SPEC", "BOOK_TYPE_CODE", "BOOK_TYPE_NAME", "BOOK_CLASS", "ORG_ID", "LEDGER_NAME", "CURRENCY_CODE", "LAST_DEPRN_RUN_DATE", "CURRENT_FISCAL_YEAR", "CURRENT_PERIOD", "CALENDAR_PERIOD_OPEN_DATE", "PERIOD_OPEN_DATE", "LEDGER_ID", "ASSET_ID", "ASSET_NUMBER", "ASSET_DESCRIPTION", "ASSET_TYPE", "MANUFACTURER_NAME", "SERIAL_NUMBER", "MODEL_NUMBER", "TAG_NUMBER", "IN_USE_FLAG", "OWNED_LEASED", "NEW_USED", "INVENTORIAL", "PROPERTY_TYPE_CODE", "UNIT_ADJUSTMENT_FLAG", "ADD_COST_JE_FLAG", "LEASE_ID", "LESSOR", "LEASE_NUMBER", "LEASE_DESC", "PARENT_ASSET", "PARENT_DESCRIPTION", "CATEGORY_TYPE", "CAPITALIZE_FLAG", "ASSET_KEY_SEG", "ASSET_CATEGORY_SEG", "MAJOR_CATEGORY", "MINOR_CATEGORY", "DATE_PLACED_IN_SERVICE", "PRORATE_DATE", "PRORATE_CONVENTION_CODE", "LIFE_IN_YEARS", "LIFE_IN_MONTH", "AGE_IN_YEARS", "AGE_IN_MONTHS", "REMAINING_IN_YEAR", "REMAINING_IN_MONTHS", "YEAR_AGING", "MONTH_AGING", "EOFY_RESERVE", "PRIOR_EOFY_RESERVE", "EMPLOYEE_NAME", "LOC_SEGMENT1", "LOC_SEGMENT2", "LOC_SEGMENT3", "LOC_SEGMENT4", "LOC_SEGMENT5", "LOC_SEGMENT6", "LOC_SEGMENT7", "LOC_SEGMENT1_NAME", "LOC_SEGMENT2_NAME", "LOC_SEGMENT3_NAME", "LOC_SEGMENT4_NAME", "LOC_SEGMENT5_NAME", "LOC_SEGMENT6_NAME", "LOC_SEGMENT7_NAME", "ASSET_LOCATION_SEG", "CURRENT_UNITS", "TRANSACTION_TYPE", "UNITS_ASSIGNED", "ORIGINAL_COST", "ASSET_COST", "ACCUMULATED_DEPRN", "NET_BOOK_VALUE", "DEPRN_AMOUNT", "ADJUSTMENT_AMOUNT", "BONUS_DEPRN_AMOUNT", "BONUS_ADJUSTMENT_AMOUNT", "REVAL_AMORTIZATION", "TOTAL_DEPRN_AMOUNT", "COST_CHANGE_FLAG", "SALVAGE_TYPE", "SALVAGE_VALUE", "DEPRN_METHOD_CODE", "EXPENSE_ACC_CCID", "EXP_ACC_CODE", "EXP_ACC_DESC", "EXP_CC_CODE", "EXP_CC_DESC", "FEEDER_SYSTEM_NAME", "SOURCE_LINE_ID", "VENDOR_NAME", "PO_NUMBER", "INVOICE_ID", "INVOICE_NUMBER", "INVOICE_DATE", "INVOICE_LINE_NUMBER", "INV_LINE_DESC", "PAYABLES_COST", "PAYABLES_UNITS", "PROJECT_ID", "PROJECT_NAME", "PROJECT_TYPE", "PROJECT_NUMBER", "WARRANTY_NUMBER", "WARRANTY_DESC", "WARRANTY_COST", "WARRANTY_START_DATE", "WARRANTY_END_DATE", "WARRANTY_RENEW_FLAG", "WARRANTY_VENDOR", "WARRANTY_CURRENCY", "EID_LAST_UPDATE_DATE", "CONTEXT", "ATTRIBUTE_CATEGORY_CODE", "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3", "ATTRIBUTE4", "ATTRIBUTE5", "ATTRIBUTE6", "ATTRIBUTE7", "ATTRIBUTE8", "ATTRIBUTE9", "ATTRIBUTE10", "ATTRIBUTE11", "ATTRIBUTE12", "ATTRIBUTE13", "ATTRIBUTE14", "ATTRIBUTE15", "ATTRIBUTE16", "ATTRIBUTE17", "ATTRIBUTE18", "ATTRIBUTE19", "ATTRIBUTE20", "ATTRIBUTE21", "ATTRIBUTE22", "ATTRIBUTE23", "ATTRIBUTE24", "ATTRIBUTE25", "ATTRIBUTE26", "ATTRIBUTE27", "ATTRIBUTE28", "ATTRIBUTE29", "ATTRIBUTE30") AS 
  SELECT    ad.asset_id
          || '-'
          || bk.transaction_header_id_in
          || '-'
          || NVL (ai.source_line_id, 0)
          || '-'
          || dh.distribution_id
          || '-'
          || expense_cc.code_combination_id AS asset_spec,
--BOOK
          bc.book_type_code, 
          bc.book_type_name, 
          bc.book_class,
          NVL (bc.org_id, -9999) AS org_id, 
          lgr.NAME AS ledger_name,
          lgr.currency_code, 
          bc.last_deprn_run_date, 
          bc.current_fiscal_year,
          dp1.period_name current_period, 
          dp1.calendar_period_open_date,
          dp1.period_open_date, 
          lgr.ledger_id AS ledger_id,
--ASSET
          ad.asset_id, 
          ad.asset_number,
          adt.description AS asset_description, 
          ad.asset_type,
          ad.manufacturer_name, 
          ad.serial_number, 
          ad.model_number,
          ad.tag_number, 
          ad.in_use_flag, 
          ad.owned_leased, 
          ad.new_used,
          ad.inventorial, 
          ad.property_type_code, 
          ad.unit_adjustment_flag,
          ad.add_cost_je_flag
--Lease
          , ad.lease_id, lv.vendor_name AS lessor, lease.lease_number,
          lease.description AS lease_desc
--Parent Asset
          , pad.asset_number parent_asset,
          padt.description parent_description
--CATEGORY
          , ca.category_type, ca.capitalize_flag,
          ak.concatenated_segments asset_key_seg,
          ck.concatenated_segments asset_category_seg,
          DECODE
             (ca.category_id,
              NULL, NULL,
              fnd_flex_xml_publisher_apis.process_kff_combination_1
                                (p_lexical_name                => 'AssetCategory',
                                 p_application_short_name      => 'OFA',
                                 p_id_flex_code                => 'CAT#',
                                 p_id_flex_num                 => fsc.category_flex_structure,
                                 p_data_set                    => fsc.category_flex_structure,
                                 p_ccid                        => ca.category_id,
                                 p_segments                    => 'BASED_CATEGORY',
                                 p_show_parent_segments        => 'N',
                                 p_output_type                 => 'FULL_DESCRIPTION'
                                )
             ) AS major_category,
          DECODE
             (ca.category_id,
              NULL, NULL,
              fnd_flex_xml_publisher_apis.process_kff_combination_1
                                (p_lexical_name                => 'AssetCategory',
                                 p_application_short_name      => 'OFA',
                                 p_id_flex_code                => 'CAT#',
                                 p_id_flex_num                 => fsc.category_flex_structure,
                                 p_data_set                    => fsc.category_flex_structure,
                                 p_ccid                        => ca.category_id,
                                 p_segments                    => 'MINOR_CATEGORY',
                                 p_show_parent_segments        => 'N',
                                 p_output_type                 => 'FULL_DESCRIPTION'
                                )
             ) AS minor_category
--ASSET LIFE
          ,
          bk.date_placed_in_service, 
          bk.prorate_date,
          bk.prorate_convention_code, 
          bk.life_in_months / 12 AS life_in_years,
          bk.life_in_months AS life_in_month,
          ROUND (  MONTHS_BETWEEN (dp1.calendar_period_open_date,
                                   bk.date_placed_in_service
                                  )
                 / 12
                ) age_in_years,
          ROUND
               (MONTHS_BETWEEN (dp1.calendar_period_open_date,
                                bk.date_placed_in_service
                               ),
                2
               ) age_in_months
          ,CASE
                WHEN ROUND(bk.life_in_months / 12- MONTHS_BETWEEN (dp1.calendar_period_open_date,bk.date_placed_in_service)/ 12,2) <= 0 THEN 0
                ELSE ROUND(bk.life_in_months / 12- MONTHS_BETWEEN (dp1.calendar_period_open_date,bk.date_placed_in_service)/ 12,2)
           END as remaining_in_year

          ,CASE
                WHEN ROUND(  bk.life_in_months - MONTHS_BETWEEN (dp1.calendar_period_open_date,bk.date_placed_in_service),2) <= 0 THEN 0
                ELSE ROUND(  bk.life_in_months - MONTHS_BETWEEN (dp1.calendar_period_open_date,bk.date_placed_in_service),2)
           END as remaining_in_months,
          
          CASE
             WHEN   bk.life_in_months / 12
                  -   MONTHS_BETWEEN (dp1.calendar_period_open_date,
                                      bk.date_placed_in_service
                                     )
                    / 12 BETWEEN 0.01 AND 1
                THEN (SELECT meaning
                        FROM fa_lookups
                       WHERE lookup_type = 'FA_EID_YEAR_AGING_BUCKETS'
                         AND lookup_code = 'WITHIN_ONE_YEAR')
             WHEN   bk.life_in_months / 12
                  -   MONTHS_BETWEEN (dp1.calendar_period_open_date,
                                      bk.date_placed_in_service
                                     )
                    / 12 BETWEEN 1.01 AND 3
                THEN (SELECT meaning
                        FROM fa_lookups
                       WHERE lookup_type = 'FA_EID_YEAR_AGING_BUCKETS'
                         AND lookup_code = 'ONE_TO_THREE')
             WHEN   bk.life_in_months / 12
                  -   MONTHS_BETWEEN (dp1.calendar_period_open_date,
                                      bk.date_placed_in_service
                                     )
                    / 12 BETWEEN 3.01 AND 5
                THEN (SELECT meaning
                        FROM fa_lookups
                       WHERE lookup_type = 'FA_EID_YEAR_AGING_BUCKETS'
                         AND lookup_code = 'THREE_TO_FIVE')
             WHEN   bk.life_in_months / 12
                  -   MONTHS_BETWEEN (dp1.calendar_period_open_date,
                                      bk.date_placed_in_service
                                     )
                    / 12 BETWEEN 5.01 AND 10
                THEN (SELECT meaning
                        FROM fa_lookups
                       WHERE lookup_type = 'FA_EID_YEAR_AGING_BUCKETS'
                         AND lookup_code = 'FIVE_TO_TEN')
             WHEN   bk.life_in_months / 12
                  -   MONTHS_BETWEEN (dp1.calendar_period_open_date,
                                      bk.date_placed_in_service
                                     )
                    / 12 > 10
                THEN (SELECT meaning
                        FROM fa_lookups
                       WHERE lookup_type = 'FA_EID_YEAR_AGING_BUCKETS'
                         AND lookup_code = 'EXTENDED_TEN')
             WHEN   bk.life_in_months / 12
                  -   MONTHS_BETWEEN (dp1.calendar_period_open_date,
                                      bk.date_placed_in_service
                                     )
                    / 12 <= 0
                THEN (SELECT meaning
                        FROM fa_lookups
                       WHERE lookup_type = 'FA_EID_YEAR_AGING_BUCKETS'
                         AND lookup_code = 'FULLY_RESERVED')
          END AS year_aging,
          
          CASE
             WHEN   bk.life_in_months
                  - MONTHS_BETWEEN (dp1.calendar_period_open_date,
                                    bk.date_placed_in_service
                                   ) BETWEEN 0.01 AND 1
                THEN (SELECT meaning
                        FROM fa_lookups
                       WHERE lookup_type = 'FA_EID_MONTH_AGING_BUCKETS'
                         AND lookup_code = 'WITHIN_ONE_YEAR')
             WHEN   bk.life_in_months
                  - MONTHS_BETWEEN (dp1.calendar_period_open_date,
                                    bk.date_placed_in_service
                                   ) BETWEEN 1.01 AND 6
                THEN (SELECT meaning
                        FROM fa_lookups
                       WHERE lookup_type = 'FA_EID_MONTH_AGING_BUCKETS'
                         AND lookup_code = 'ONE_TO_SIX')
             WHEN   bk.life_in_months
                  - MONTHS_BETWEEN (dp1.calendar_period_open_date,
                                    bk.date_placed_in_service
                                   ) BETWEEN 6.01 AND 12
                THEN (SELECT meaning
                        FROM fa_lookups
                       WHERE lookup_type = 'FA_EID_MONTH_AGING_BUCKETS'
                         AND lookup_code = 'SIX_TO_TWELVE')
             WHEN   bk.life_in_months
                  - MONTHS_BETWEEN (dp1.calendar_period_open_date,
                                    bk.date_placed_in_service
                                   ) BETWEEN 12.01 AND 18
                THEN (SELECT meaning
                        FROM fa_lookups
                       WHERE lookup_type = 'FA_EID_MONTH_AGING_BUCKETS'
                         AND lookup_code = 'TWELVE_TO_EIGHTEEN')
             WHEN   bk.life_in_months
                  - MONTHS_BETWEEN (dp1.calendar_period_open_date,
                                    bk.date_placed_in_service
                                   ) BETWEEN 18.01 AND 24
                THEN (SELECT meaning
                        FROM fa_lookups
                       WHERE lookup_type = 'FA_EID_MONTH_AGING_BUCKETS'
                         AND lookup_code = 'EIGHTEEN_TO_TWENTY_FOUR')
             WHEN   bk.life_in_months
                  - MONTHS_BETWEEN (dp1.calendar_period_open_date,
                                    bk.date_placed_in_service
                                   ) BETWEEN 24.01 AND 30
                THEN (SELECT meaning
                        FROM fa_lookups
                       WHERE lookup_type = 'FA_EID_MONTH_AGING_BUCKETS'
                         AND lookup_code = 'TWENTY_FOUR_TO_THIRTY')
             WHEN   bk.life_in_months
                  - MONTHS_BETWEEN (dp1.calendar_period_open_date,
                                    bk.date_placed_in_service
                                   ) > 30
                THEN (SELECT meaning
                        FROM fa_lookups
                       WHERE lookup_type = 'FA_EID_MONTH_AGING_BUCKETS'
                         AND lookup_code = 'EXTENDED_THIRTY')
             WHEN   bk.life_in_months
                  - MONTHS_BETWEEN (dp1.calendar_period_open_date,
                                    bk.date_placed_in_service
                                   ) < 1
                THEN (SELECT meaning
                        FROM fa_lookups
                       WHERE lookup_type = 'FA_EID_MONTH_AGING_BUCKETS'
                         AND lookup_code = 'FULLY_RESERVED')
          END AS month_aging,
          
          bk.eofy_reserve, 
          bk.prior_eofy_reserve
--ASSET ASSIGNMENT
          , emp.NAME AS employee_name
-- Asset location KFF
          ,
          (SELECT description
             FROM fnd_flex_values_vl
            WHERE flex_value_set_id =
                     (SELECT flex_value_set_id
                        FROM fnd_id_flex_segments g
                       WHERE g.application_id = 140
                         AND g.id_flex_code = 'LOC#'
                         AND application_column_name = 'SEGMENT1')
              AND flex_value = loc.segment1) AS loc_segment1,
          (SELECT description
             FROM fnd_flex_values_vl
            WHERE flex_value_set_id =
                     (SELECT flex_value_set_id
                        FROM fnd_id_flex_segments g
                       WHERE g.application_id = 140
                         AND g.id_flex_code = 'LOC#'
                         AND application_column_name = 'SEGMENT2')
              AND flex_value = loc.segment2) AS loc_segment2,
          (SELECT description
             FROM fnd_flex_values_vl
            WHERE flex_value_set_id =
                     (SELECT flex_value_set_id
                        FROM fnd_id_flex_segments g
                       WHERE g.application_id = 140
                         AND g.id_flex_code = 'LOC#'
                         AND application_column_name = 'SEGMENT3')
              AND flex_value = loc.segment3) AS loc_segment3,
          (SELECT description
             FROM fnd_flex_values_vl
            WHERE flex_value_set_id =
                     (SELECT flex_value_set_id
                        FROM fnd_id_flex_segments g
                       WHERE g.application_id = 140
                         AND g.id_flex_code = 'LOC#'
                         AND application_column_name = 'SEGMENT4')
              AND flex_value = loc.segment4) AS loc_segment4,
          (SELECT description
             FROM fnd_flex_values_vl
            WHERE flex_value_set_id =
                     (SELECT flex_value_set_id
                        FROM fnd_id_flex_segments g
                       WHERE g.application_id = 140
                         AND g.id_flex_code = 'LOC#'
                         AND application_column_name = 'SEGMENT5')
              AND flex_value = loc.segment5) AS loc_segment5,
          (SELECT description
             FROM fnd_flex_values_vl
            WHERE flex_value_set_id =
                     (SELECT flex_value_set_id
                        FROM fnd_id_flex_segments g
                       WHERE g.application_id = 140
                         AND g.id_flex_code = 'LOC#'
                         AND application_column_name = 'SEGMENT6')
              AND flex_value = loc.segment6) AS loc_segment6,
          (SELECT description
             FROM fnd_flex_values_vl
            WHERE flex_value_set_id =
                     (SELECT flex_value_set_id
                        FROM fnd_id_flex_segments g
                       WHERE g.application_id = 140
                         AND g.id_flex_code = 'LOC#'
                         AND application_column_name = 'SEGMENT7')
              AND flex_value = loc.segment7) AS loc_segment7,

          (SELECT segment_name
             FROM fnd_id_flex_segments g
            WHERE g.application_id = 140
              AND g.id_flex_code = 'LOC#'
              AND application_column_name = 'SEGMENT1') AS loc_segment1_name,
          (SELECT segment_name
             FROM fnd_id_flex_segments g
            WHERE g.application_id = 140
              AND g.id_flex_code = 'LOC#'
              AND application_column_name = 'SEGMENT2') AS loc_segment2_name,
          (SELECT segment_name
             FROM fnd_id_flex_segments g
            WHERE g.application_id = 140
              AND g.id_flex_code = 'LOC#'
              AND application_column_name = 'SEGMENT3') AS loc_segment3_name,
          (SELECT segment_name
             FROM fnd_id_flex_segments g
            WHERE g.application_id = 140
              AND g.id_flex_code = 'LOC#'
              AND application_column_name = 'SEGMENT4') AS loc_segment4_name,
          (SELECT segment_name
             FROM fnd_id_flex_segments g
            WHERE g.application_id = 140
              AND g.id_flex_code = 'LOC#'
              AND application_column_name = 'SEGMENT5') AS loc_segment5_name,
          (SELECT segment_name
             FROM fnd_id_flex_segments g
            WHERE g.application_id = 140
              AND g.id_flex_code = 'LOC#'
              AND application_column_name = 'SEGMENT6') AS loc_segment6_name,
          (SELECT segment_name
             FROM fnd_id_flex_segments g
            WHERE g.application_id = 140
              AND g.id_flex_code = 'LOC#'
              AND application_column_name = 'SEGMENT7') AS loc_segment7_name,

          DECODE
             (loc.location_id,
              NULL, NULL,
              fnd_flex_xml_publisher_apis.process_kff_combination_1
                                (p_lexical_name                => 'AssetLocation',
                                 p_application_short_name      => 'OFA',
                                 p_id_flex_code                => 'LOC#',
                                 p_id_flex_num                 => fsc.location_flex_structure,
                                 p_data_set                    => fsc.location_flex_structure,
                                 p_ccid                        => loc.location_id,
                                 p_segments                    => 'ALL',
                                 p_show_parent_segments        => 'Y',
                                 p_output_type                 => 'FULL_DESCRIPTION'
                                )
             ) AS asset_location_seg
--ASSET TRANSACTION
          ,
          ad.current_units, lo.meaning transaction_type, dh.units_assigned
-- FINANCIAL INFO
          ,
bk.original_cost  AS original_cost ,
NVL(gl_mc_currency_pkg.CurrRound( (bk.COST * dh.units_assigned / ad.current_units),LGR.CURRENCY_CODE),0) AS asset_cost ,
NVL(gl_mc_currency_pkg.CurrRound(ds.deprn_reserve, LGR.CURRENCY_CODE),0) accumulated_deprn ,
NVL(gl_mc_currency_pkg.CurrRound( (ds.ADJUSTED_COST),LGR.CURRENCY_CODE)- ds.deprn_reserve - ds.IMPAIRMENT_RESERVE,0) net_book_value ,
CASE
  WHEN (ds.DEPRN_RESERVE = bk.COST)
  THEN 0
  ELSE (ds.deprn_amount - ( NVL (ds.deprn_adjustment_amount, 0)- NVL (ds.bonus_deprn_adjustment_amount, 0))- NVL (ds.bonus_deprn_amount, 0))
END AS deprn_amount ,
NVL (ds.deprn_adjustment_amount, 0)- NVL (ds.bonus_deprn_adjustment_amount, 0) adjustment_amount ,
NVL (ds.bonus_deprn_amount - ds.bonus_deprn_adjustment_amount,0) bonus_deprn_amount ,
NVL (ds.bonus_deprn_adjustment_amount, 0) bonus_adjustment_amount ,
NVL (ds.reval_amortization, 0) reval_amortization ,
ds.YTD_DEPRN total_deprn_amount ,
bk.cost_change_flag ,
bk.salvage_type ,
bk.salvage_value ,
bk.deprn_method_code,
         expense_cc.code_combination_id AS expense_acc_ccid,
          cb.deprn_expense_acct AS exp_acc_code,
          fnd_flex_xml_publisher_apis.process_kff_combination_1
                  (p_lexical_name                => 'EXP Account',
                   p_application_short_name      => 'SQLGL',
                   p_id_flex_code                => 'GL#',
                   p_id_flex_num                 => lgr.chart_of_accounts_id,
                   p_data_set                    => lgr.chart_of_accounts_id,
                   p_ccid                        => expense_cc.code_combination_id,
                   p_segments                    => 'GL_ACCOUNT',
                   p_show_parent_segments        => 'Y',
                   p_output_type                 => 'FULL_DESCRIPTION'
                  ) AS exp_acc_desc,
          fnd_flex_xml_publisher_apis.process_kff_combination_1
                   (p_lexical_name                => 'EXP CostCenter',
                    p_application_short_name      => 'SQLGL',
                    p_id_flex_code                => 'GL#',
                    p_id_flex_num                 => lgr.chart_of_accounts_id,
                    p_data_set                    => lgr.chart_of_accounts_id,
                    p_ccid                        => expense_cc.code_combination_id,
                    p_segments                    => 'FA_COST_CTR',
                    p_show_parent_segments        => 'Y',
                    p_output_type                 => 'VALUE'
                   ) AS exp_cc_code,
          fnd_flex_xml_publisher_apis.process_kff_combination_1
                   (p_lexical_name                => 'EXP CostCenter',
                    p_application_short_name      => 'SQLGL',
                    p_id_flex_code                => 'GL#',
                    p_id_flex_num                 => lgr.chart_of_accounts_id,
                    p_data_set                    => lgr.chart_of_accounts_id,
                    p_ccid                        => expense_cc.code_combination_id,
                    p_segments                    => 'FA_COST_CTR',
                    p_show_parent_segments        => 'Y',
                    p_output_type                 => 'FULL_DESCRIPTION'
                   ) AS exp_cc_desc


--Source line info
          
          ,ai.feeder_system_name, ai.source_line_id, iv.vendor_name,
          ai.po_number, ai.invoice_id, ai.invoice_number, ai.invoice_date,
          ai.invoice_line_number, ai.description AS inv_line_desc,
          ai.payables_cost, ai.payables_units, pp.project_id,
          pp.NAME AS project_name, pp.project_type,
          pp.segment1 AS project_number
-- WARRANTIES INFO
          , fw.warranty_number, fw.description AS warranty_desc,
          fw.COST AS warranty_cost, fw.start_date AS warranty_start_date,
          fw.end_date AS warranty_end_date,
          fw.renew_flag AS warranty_renew_flag,
          wv.vendor_name AS warranty_vendor,
          fw.currency_code AS warranty_currency,
          GREATEST (ad.last_update_date,
                    ad.last_update_date
                   ) eid_last_update_date
--Asset DFF
          ,
          ad.CONTEXT, ad.attribute_category_code, ad.attribute1,
          ad.attribute2, ad.attribute3, ad.attribute4, ad.attribute5,
          ad.attribute6, ad.attribute7, ad.attribute8, ad.attribute9,
          ad.attribute10, ad.attribute11, ad.attribute12, ad.attribute13,
          ad.attribute14, ad.attribute15, ad.attribute16, ad.attribute17,
          ad.attribute18, ad.attribute19, ad.attribute20, ad.attribute21,
          ad.attribute22, ad.attribute23, ad.attribute24, ad.attribute25,
          ad.attribute26, ad.attribute27, ad.attribute28, ad.attribute29,
          ad.attribute30

FROM fa_book_controls bc,
          fa_books bk,
          fa_additions_b ad,
          fa_additions_tl adt,
          fa_additions_b pad,
          fa_additions_tl padt,
          fa_asset_keywords_kfv ak,
          fa_categories_b_kfv ck,
          fa_leases lease,
          ap_suppliers lv,
          fa_categories_b ca,
          fa_category_books cb,
          fa_distribution_history dh,
          fa_transaction_headers th,
          fa_lookups lo,
          fa_employees emp,
          fa_locations loc,
          fa_deprn_summary ds,
          fa_deprn_periods dp1,
          fa_books_bas bkprev,
          gl_ledgers lgr,
          gl_code_combinations expense_cc,
          fa_system_controls fsc,
          fa_asset_invoices ai,
          ap_suppliers iv,
          pa_projects_all pp,
          fa_add_warranties faw,
          fa_warranties fw,
          ap_suppliers wv

WHERE bc.book_class = 'CORPORATE'
      AND bk.book_type_code = bc.book_type_code
      AND bk.asset_id = ad.asset_id
      
      AND bk.period_counter_fully_retired   IS NULL
      AND bk.date_ineffective               IS NULL
      AND bk.transaction_header_id_out      IS NULL
      AND bc.date_ineffective               IS NULL
      
      AND ad.asset_id = adt.asset_id
      AND adt.LANGUAGE = USERENV ('LANG')
      AND ad.parent_asset_id = pad.asset_id(+)
      AND pad.asset_id = padt.asset_id(+)
      AND padt.LANGUAGE(+) = USERENV ('LANG')
      AND ad.lease_id = lease.lease_id(+)
      AND lv.vendor_id(+) = lease.lessor_id
      AND ad.asset_key_ccid = ak.code_combination_id(+)
      AND ad.asset_category_id = ck.category_id
      AND dh.transaction_header_id_out      IS NULL
      AND dh.date_ineffective               IS NULL
      AND dh.retirement_id                  IS NULL
      AND dh.book_type_code = bk.book_type_code
      AND dh.asset_id = ad.asset_id
      AND dh.assigned_to = emp.employee_id(+)
      AND loc.enabled_flag = 'Y'
      AND loc.location_id = dh.location_id
      AND expense_cc.code_combination_id = dh.code_combination_id
      AND ca.enabled_flag = 'Y'
      AND ca.end_date_active                IS NULL
      AND cb.book_type_code = bk.book_type_code
      AND ca.category_id = cb.category_id
      AND cb.category_id = ad.asset_category_id
      AND (    lo.lookup_type = 'FAXOLTRX'
           AND lo.lookup_code = th.transaction_type_code
          )
      AND bkprev.transaction_header_id_out(+) = bk.transaction_header_id_in
      AND th.transaction_header_id = bk.transaction_header_id_in
      AND lgr.object_type_code = 'L'
      AND NVL (lgr.complete_flag, 'Y') = 'Y'
      AND bc.set_of_books_id = lgr.ledger_id
      AND ds.book_type_code = bc.book_type_code
      AND ds.asset_id = ad.asset_id
      AND ds.period_counter =
             (SELECT MAX (period_counter)
                FROM fa_deprn_summary
               WHERE asset_id = ds.asset_id
                 AND book_type_code = ds.book_type_code)
      AND bc.book_type_code = dp1.book_type_code
      AND bc.last_period_counter + 1 = dp1.period_counter
      AND dp1.period_close_date IS NULL
      AND ai.date_ineffective IS NULL
      AND ai.invoice_transaction_id_out IS NULL
      AND ad.asset_id = ai.asset_id(+)
      AND ai.po_vendor_id = iv.vendor_id(+)
      AND ai.project_id = pp.project_id(+)
      AND bk.asset_id = faw.asset_id(+)
      AND faw.warranty_id = fw.warranty_id(+)
      AND fw.po_vendor_id = wv.vendor_id(+)
   ;
