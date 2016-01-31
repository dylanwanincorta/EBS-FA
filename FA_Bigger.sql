SELECT *
FROM ( ( -- DEP and RET
  (      -- DEPRE
  (      -- here to line 285
  SELECT fdd.asset_id   AS asset_id,
    fdd.book_type_code  AS book_type_code,
    fbc.set_of_books_id AS set_of_books_id,
    ( fdd.asset_category_id
    || '~'
    || fb.deprn_method_code) AS category_id,
    fdd.location_id          AS location_id,
    TO_CHAR (fdd.code_combination_id) ccid,
    (
    CASE
      WHEN fdd.assigned_to IS NULL
      THEN NULL
      ELSE 'PER~'
        || TO_CHAR ( fdd.assigned_to)
    END) employee_id,
    NULL                           AS balancing_segment_id,
    fdd.calendar_period_close_date AS calendar_period_close_date,
    gsob.currency_code doc_curr_code,
    gsob.currency_code loc_curr_code,
    fdd.deprn_amount deprn_doc_amt,
    fdd.deprn_amount deprn_loc_amt,
    (
    CASE
      WHEN fdd.transaction_type_code = 'TRANSFER IN'
      AND fdd.UNITS_ASSIGNED         = 0
      THEN 0
      ELSE fdd.deprn_adjustment_amount
    END) deprn_adjustment_doc_amt,
    (
    CASE
      WHEN fdd.transaction_type_code ='TRANSFER IN'
      AND fdd.UNITS_ASSIGNED         = 0
      THEN 0
      ELSE fdd.deprn_adjustment_amount
    END) deprn_adjustment_loc_amt,
    fdd.deprn_amount total_deprn_doc_amt,
    fdd.deprn_amount total_deprn_loc_amt,
    (
    CASE
      WHEN fdd.transaction_type_code ='TRANSFER IN'
      AND fdd.UNITS_ASSIGNED         = 0
      THEN 0
      ELSE fdd.COST
    END) current_cost_doc_amt,
    (
    CASE
      WHEN fdd.transaction_type_code ='TRANSFER IN'
      AND fdd.UNITS_ASSIGNED         = 0
      THEN 0
      ELSE fdd.COST
    END) current_cost_loc_amt,
    (
    CASE
      WHEN fdd.transaction_type_code ='TRANSFER IN'
      AND fdd.UNITS_ASSIGNED         = 0
      THEN 0
      ELSE fdd.deprn_reserve
    END) acc_deprn_doc_amt,
    (
    CASE
      WHEN fdd.transaction_type_code ='TRANSFER IN'
      AND fdd.UNITS_ASSIGNED         = 0
      THEN 0
      ELSE fdd.deprn_reserve
    END) acc_deprn_loc_amt,
    (
    CASE
      WHEN fdd.transaction_type_code ='TRANSFER IN'
      AND fdd.UNITS_ASSIGNED         = 0
      THEN 0
      ELSE fds.ytd_deprn
    END) AS ytd_deprn_doc_amt,
    (
    CASE
      WHEN fdd.transaction_type_code ='TRANSFER IN'
      AND fdd.UNITS_ASSIGNED         = 0
      THEN 0
      ELSE fds.ytd_deprn
    END) AS ytd_deprn_loc_amt,
    TO_CHAR (fbc.created_by) created_by,
    TO_CHAR (fbc.last_updated_by) changed_by,
    fdd.deprn_run_date created_on_dt,
    fdd.deprn_run_date changed_on_dt,
    ( 'FA~'
    || fdd.book_type_code
    || '~'
    || TO_CHAR ( fdd.distribution_id)
    || '~'
    || fdd.period_entered
    || '~'
    || fdd.asset_category_id
    || '~'
    || FB.DEPRN_METHOD_CODE)       AS INTEGRATION_ID,
    NULL                           AS datasource_num_id, -- 1000.000000000000000 --UNCOMMENT
    '#TENANT_ID'                   AS tenant_id,
    fdd.period_close_date          AS period_close_date,
    NULL                           AS vendor_id,
    fcb.asset_cost_account_ccid    AS x_cost_acc_ccid_id,
    fdd.deprn_reserve              AS x_deprn_reserve,
    fcb.deprn_expense_account_ccid AS x_exp_acc_ccid_id,
    fcb.reserve_account_ccid       AS x_resrv_acc_ccid_id,
    NULL                           AS x_retirement_category,
    fdd.units_assigned             AS x_unit,
    fdd.deprn_source_code          AS x_deprn_source_code,
    (
    CASE
      WHEN fdd.transaction_type_code = 'TRANSFER IN'
      AND fdd.UNITS_ASSIGNED         = 0
      THEN 0
      ELSE fb.salvage_value
    END) AS x_salvage_value,
    (
    CASE
      WHEN fdd.transaction_type_code = 'TRANSFER IN'
      AND fdd.UNITS_ASSIGNED         = 0
      THEN 0
      ELSE
        (SELECT cost
        FROM apps.FA_BOOKS
        WHERE ASSET_ID        = fdd.ASSET_ID
        AND DATE_INEFFECTIVE IS NULL
        )
    END) AS x_net_book_value,
    NULL AS x_retired_value,
    'Y'  AS X_ASSET_ACTIVE_FLG,
    (
    CASE
      WHEN fdd.transaction_type_code = 'TRANSFER IN'
      AND fdd.UNITS_ASSIGNED         = 0
      THEN 0
      ELSE fb.original_cost
    END) AS x_original_cost,
    NULL AS X_RETIRED_NBV_AMT,
    NULL AS X_RETIREMENT_ID,
    NULL AS X_RETIRED_DT,
    NULL AS X_PARTIAL_RETIRE_FLG
  FROM apps.fa_asset_history fah,
    apps.fa_book_controls fbc,
    apps.gl_sets_of_books gsob,
    apps.fa_category_books fcb,
    apps.fa_books fb,
    apps.fa_deprn_summary fds,
    (                             -- Union
    (SELECT ad.asset_id asset_id, -- Line 142 to 215
      ad.asset_number,
      ad.asset_category_id,
      ad.description,
      dh.location_id,
      dh.assigned_to,
      (
      CASE
        WHEN ( th.TRANSACTION_TYPE_CODE = 'TRANSFER IN'
        AND dh.date_ineffective         < dp.period_close_date)
        THEN (
          CASE
            WHEN DH.TRANSACTION_UNITS IS NOT NULL
            THEN DH.UNITS_ASSIGNED + DH.TRANSACTION_UNITS
            ELSE DH.UNITS_ASSIGNED
          END)
        WHEN SUM ( dd.COST) = 0
        THEN 0
        ELSE DH.UNITS_ASSIGNED
      END) AS UNITS_ASSIGNED,
      th.transaction_type_code transaction_type_code,
      dd.deprn_run_date deprn_run_date,
      dp.book_type_code book_type_code,
      dp.period_counter period_counter,
      dp.period_name period_entered,
      dh.code_combination_id,
      dd.deprn_source_code,
      dp.period_close_date,
      dp.calendar_period_close_date,
      dh.transaction_header_id_in,
      dh.distribution_id,
      SUM (dd.COST) COST, -- dd is the key fact table!!
      SUM ( dd.deprn_reserve) deprn_reserve,
      SUM ( dd.deprn_amount) deprn_amount,
      SUM ( dd.deprn_adjustment_amount) deprn_adjustment_amount
    FROM apps.fa_additions ad,
      apps.fa_deprn_periods dp,
      apps.fa_book_controls bc,
      apps.gl_sets_of_books glsb,
      apps.fa_distribution_history dh,
      apps.fa_deprn_detail dd,
      apps.fa_transaction_headers th
    WHERE ad.asset_id             = dd.asset_id
    AND th.transaction_header_id  = dh.transaction_header_id_in
    AND dd.book_type_code         = bc.book_type_code
    AND bc.set_of_books_id        = glsb.set_of_books_id
    AND dd.period_counter         = dp.period_counter
    AND dd.book_type_code         = dp.book_type_code
    AND dd.distribution_id        = dh.distribution_id
    AND dp.period_close_date     IS NOT NULL
    AND dd.deprn_source_code      ='D'
    AND ( dh.date_ineffective    IS NULL
    OR TRUNC ( dd.deprn_run_date) <TRUNC ( dh.date_ineffective))
    GROUP BY ad.asset_id,
      ad.asset_number,
      ad.description,
      dh.location_id,
      ad.asset_category_id,
      dh.assigned_to,
      dh.units_assigned,
      th.transaction_type_code,
      dd.deprn_run_date,
      dp.book_type_code,
      dp.period_counter,
      dp.period_name,
      dh.code_combination_id,
      dd.deprn_source_code,
      dp.period_close_date,
      dp.calendar_period_close_date,
      dh.transaction_header_id_in,
      dh.distribution_id,
      DH.TRANSACTION_UNITS,
      dh.date_ineffective
    )
  UNION
    (SELECT ad.asset_id asset_id, -- Line 217 to 265
      ad.asset_number,
      ad.asset_category_id,
      ad.description,
      dh.location_id,
      dh.assigned_to,
      ( DH.UNITS_ASSIGNED + DH.TRANSACTION_UNITS) AS UNITS_ASSIGNED,
      th.transaction_type_code transaction_type_code,
      dd.deprn_run_date deprn_run_date,
      dp.book_type_code book_type_code,
      dp.period_counter period_counter,
      dp.period_name period_entered,
      dh.code_combination_id,
      dd.deprn_source_code,
      dp.period_close_date,
      dp.calendar_period_close_date,
      dh.transaction_header_id_in,
      dh.distribution_id,
      dd.COST COST,
      dd.deprn_reserve deprn_reserve,
      dd.deprn_amount deprn_amount,
      dd.deprn_adjustment_amount deprn_adjustment_amount
    FROM apps.fa_additions ad,
      apps.fa_deprn_periods dp,
      apps.fa_book_controls bc,
      apps.gl_sets_of_books glsb,
      apps.fa_distribution_history dh,
      apps.fa_deprn_detail dd,
      apps.fa_transaction_headers th
    WHERE ad.asset_id            = dd.asset_id
    AND th.transaction_header_id = (
      CASE
        WHEN (dh.retirement_id           IS NOT NULL
        AND dh.transaction_header_id_OUT IS NOT NULL)
        THEN dh.transaction_header_id_IN
        ELSE dh.transaction_header_id_OUT
      END )
    AND dd.book_type_code                           = bc.book_type_code
    AND bc.set_of_books_id                          = glsb.set_of_books_id
    AND dd.period_counter                           = dp.period_counter
    AND dd.book_type_code                           = dp.book_type_code
    AND dd.distribution_id                          = dh.distribution_id
    AND dp.period_close_date                       IS NOT NULL
    AND dd.deprn_source_code                        = 'D'
    AND th.TRANSACTION_TYPE_CODE                    = 'TRANSFER'
    AND ( dh.date_ineffective                      IS NULL
    OR TRUNC(dh.date_ineffective)                  <= TRUNC ( dp.period_close_date))
    AND ( DH.UNITS_ASSIGNED + DH.TRANSACTION_UNITS) = 0
    )) fdd
  WHERE 1                           = 1
  AND fdd.asset_id                  = fah.asset_id
  AND fdd.transaction_header_id_in >= fah.transaction_header_id_in
  AND fdd.transaction_header_id_in  < NVL ( fah.transaction_header_id_out, 999999999)
  AND fbc.book_type_code            = fdd.book_type_code
  AND fbc.set_of_books_id           = gsob.set_of_books_id
  AND fbc.book_type_code            = fcb.book_type_code
  AND fcb.category_id               = fah.category_id
  AND fah.asset_id                  = fb.asset_id
  AND fah.asset_id                  = fds.asset_id
  AND fdd.book_type_code            = fds.book_type_code
  AND fdd.period_counter            = fds.period_counter
  AND FB.DATE_INEFFECTIVE          IS NULL
    --AND (fdd.deprn_run_date          >=TO_DATE('$$LAST_EXTRACT_DATE','MM/DD/YYYY HH24:MI:SS') ) --UNCOMMENT
  )
UNION
  (SELECT fdd.asset_id  AS asset_id,
    fdd.book_type_code  AS book_type_code,
    fbc.set_of_books_id AS set_of_books_id,
    ( fdd.asset_category_id
    || '~'
    || fb.deprn_method_code) AS category_id,
    fdd.location_id          AS location_id,
    TO_CHAR ( fdd.code_combination_id) ccid,
    (
    CASE
      WHEN fdd.assigned_to IS NULL
      THEN NULL
      ELSE 'PER~'
        || TO_CHAR ( fdd.assigned_to)
    END) employee_id,
    NULL                           AS balancing_segment_id,
    fdd.calendar_period_close_date AS calendar_period_close_date,
    gsob.currency_code doc_curr_code,
    gsob.currency_code loc_curr_code,
    ( fdd.deprn_amount - (
    CASE
      WHEN fdd.deprn_adjustment_amount IS NULL
      THEN 0
      ELSE fdd.deprn_adjustment_amount
    END)) deprn_doc_amt,
    ( fdd.deprn_amount - (
    CASE
      WHEN fdd.deprn_adjustment_amount IS NULL
      THEN 0
      ELSE fdd.deprn_adjustment_amount
    END)) deprn_loc_amt,
    fdd.deprn_adjustment_amount deprn_adjustment_doc_amt,
    fdd.deprn_adjustment_amount deprn_adjustment_loc_amt,
    fdd.deprn_amount total_deprn_doc_amt,
    fdd.deprn_amount total_deprn_loc_amt,
    fdd.COST current_cost_doc_amt,
    fdd.COST current_cost_loc_amt,
    fdd.deprn_reserve acc_deprn_doc_amt,
    fdd.deprn_reserve acc_deprn_loc_amt,
    fds.ytd_deprn AS ytd_deprn_doc_amt,
    fds.ytd_deprn AS ytd_deprn_loc_amt,
    TO_CHAR (fbc.created_by) created_by,
    TO_CHAR (fbc.last_updated_by) changed_by,
    fdd.deprn_run_date created_on_dt,
    fdd.deprn_run_date changed_on_dt,
    ( 'FA~'
    || fdd.book_type_code
    || '~'
    || TO_CHAR ( fdd.distribution_id)
    || '~'
    || fdd.period_entered
    || '~'
    || fdd.asset_category_id
    || '~'
    || FB.DEPRN_METHOD_CODE)       AS INTEGRATION_ID,
    NULL                           AS datasource_num_id, -- 1000.000000000000000 --UNCOMMENT
    '#TENANT_ID'                   AS tenant_id,
    fdd.period_close_date          AS period_close_date,
    NULL                           AS vendor_id,
    fcb.asset_cost_account_ccid    AS x_cost_acc_ccid_id,
    fdd.deprn_reserve              AS x_deprn_reserve,
    fcb.deprn_expense_account_ccid AS x_exp_acc_ccid_id,
    fcb.reserve_account_ccid       AS x_resrv_acc_ccid_id,
    NULL                           AS x_retirement_category,
    fdd.units_assigned             AS x_unit,
    fdd.deprn_source_code          AS x_deprn_source_code,
    fb.salvage_value               AS x_salvage_value,
    (SELECT cost
    FROM apps.FA_BOOKS
    WHERE ASSET_ID        = fdd.ASSET_ID
    AND DATE_INEFFECTIVE IS NULL
    )                AS x_net_book_value,
    NULL             AS x_retired_value,
    'Y'              AS X_ASSET_ACTIVE_FLG,
    fb.original_cost AS x_original_cost,
    NULL             AS X_RETIRED_NBV_AMT,
    NULL             AS X_RETIREMENT_ID,
    NULL             AS X_RETIRED_DT,
    NULL             AS X_PARTIAL_RETIRE_FLG -- ADDED BY PREM
  FROM apps.fa_asset_history fah,
    apps.fa_book_controls fbc,
    apps.gl_sets_of_books gsob,
    apps.fa_category_books fcb,
    apps.fa_books fb,
    apps.fa_deprn_summary fds,
    (SELECT ad.asset_id asset_id,
      ad.asset_number,
      ad.asset_category_id,
      ad.description,
      dh.location_id,
      dh.assigned_to,
      dh.units_assigned,
      th.transaction_type_code transaction_type_code,
      dd.deprn_run_date deprn_run_date,
      dp.book_type_code book_type_code,
      dp.period_counter period_counter,
      dp.period_name period_entered,
      dh.code_combination_id,
      dd.deprn_source_code,
      dp.period_close_date,
      dp.calendar_period_close_date,
      dh.transaction_header_id_in,
      dh.distribution_id,
      SUM (dd.COST) COST,
      SUM (dd.deprn_reserve) deprn_reserve,
      SUM (dd.deprn_amount) deprn_amount,
      SUM ( dd.deprn_adjustment_amount) deprn_adjustment_amount
    FROM apps.fa_additions ad,
      apps.fa_deprn_periods dp,
      apps.fa_book_controls bc,
      apps.gl_sets_of_books glsb,
      apps.fa_distribution_history dh,
      apps.fa_deprn_detail dd,
      apps.fa_transaction_headers th
    WHERE ad.asset_id            = dd.asset_id
    AND th.transaction_header_id = dh.transaction_header_id_in
    AND dd.book_type_code        = bc.book_type_code
    AND bc.set_of_books_id       = glsb.set_of_books_id
    AND dd.period_counter        = dp.period_counter
    AND dd.book_type_code        = dp.book_type_code
    AND dd.distribution_id       = dh.distribution_id
    AND dp.period_close_date    IS NOT NULL
    AND (dd.deprn_source_code    = 'B')
    AND ( dh.date_ineffective   IS NULL
    OR dd.deprn_run_date         < dh.date_ineffective)
    GROUP BY AD.ASSET_ID,
      AD.ASSET_NUMBER,
      AD.DESCRIPTION,
      DH.LOCATION_ID,
      AD.ASSET_CATEGORY_ID,
      DH.ASSIGNED_TO,
      DH.UNITS_ASSIGNED,
      TH.TRANSACTION_TYPE_CODE,
      dd.deprn_run_date,
      dp.book_type_code,
      dp.period_counter,
      dp.period_name,
      dh.code_combination_id,
      dd.deprn_source_code,
      dp.period_close_date,
      dp.calendar_period_close_date,
      dh.transaction_header_id_in,
      dh.distribution_id
    ) FDD
  WHERE 1                           = 1
  AND fdd.asset_id                  = fah.asset_id
  AND fdd.transaction_header_id_in >= fah.transaction_header_id_in
  AND fdd.transaction_header_id_in  < NVL (fah.transaction_header_id_out, 999999999)
  AND fbc.book_type_code            = fdd.book_type_code
  AND fbc.set_of_books_id           = gsob.set_of_books_id
  AND fbc.book_type_code            = fcb.book_type_code
  AND fcb.category_id               = fah.category_id
  AND fah.asset_id                  = fb.asset_id
  AND fah.asset_id                  = fds.asset_id
  AND fdd.book_type_code            = fds.book_type_code
  AND fdd.period_counter            = fds.period_counter
  AND FB.DATE_INEFFECTIVE          IS NULL
    --AND (fdd.deprn_run_date          >=TO_DATE('$$LAST_EXTRACT_DATE','MM/DD/YYYY HH24:MI:SS') ) --UNCOMMENT
  AND FDD.ASSET_ID NOT IN
    (SELECT ASSET_ID FROM apps.fa_deprn_detail WHERE deprn_source_code = 'D'
    )
  )) DEPRE
LEFT OUTER JOIN -- To RETIREM
  (SELECT R.ASSET_ID ,
    (
    CASE
      WHEN D.LOCATION_ID IS NULL
      THEN
        (SELECT location_id
        FROM apps.FA_DISTRIBUTION_HISTORY
        WHERE ASSET_ID        = R.ASSET_ID
        AND DATE_INEFFECTIVE IS NULL
        )
      ELSE D.LOCATION_ID
    END ) LOCATION_ID ,
    (
    CASE
      WHEN D.CODE_COMBINATION_ID IS NULL
      THEN
        (SELECT CODE_COMBINATION_ID
        FROM apps.FA_DISTRIBUTION_HISTORY
        WHERE ASSET_ID        = R.ASSET_ID
        AND DATE_INEFFECTIVE IS NULL
        )
      ELSE D.CODE_COMBINATION_ID
    END ) CODE_COMBINATION_ID ,
    R.RETIREMENT_ID X_RETIREMENT_ID ,
    R.RETIREMENT_TYPE_CODE x_retirement_category ,
    R.COST_RETIRED x_retired_value ,
    R.NBV_RETIRED X_RETIRED_NBV_AMT ,
    R.DATE_RETIRED X_RETIRED_DT ,
    (
    CASE
      WHEN h.TRANSACTION_TYPE_CODE ='PARTIAL RETIREMENT'
      THEN 'Y'
      ELSE 'N'
    END) X_PARTIAL_RETIRE_FLG ,
    (
    CASE
      WHEN h.TRANSACTION_TYPE_CODE ='FULL RETIREMENT'
      THEN 'Y'
      ELSE 'N'
    END) X_FULLY_RETIRED_FLG ,
    H.TRANSACTION_TYPE_CODE ,
    (D.TRANSACTION_UNITS * -1) AS CAL_X_UNIT,
    (
    CASE
      WHEN D.TRANSACTION_UNITS IS NULL
      THEN R.COST_RETIRED
      ELSE ( ( R.COST_RETIRED * ( D.TRANSACTION_UNITS * -1)) / R.UNITS)
    END) AS CAL_X_RETIRED_VALUE,
    (
    CASE
      WHEN D.TRANSACTION_UNITS IS NULL
      THEN R.NBV_RETIRED
      ELSE ( ( R.NBV_RETIRED * ( D.TRANSACTION_UNITS * -1)) / R.UNITS)
    END) AS CAL_X_RETIRED_NBV_AMT,
    DP.CALENDAR_PERIOD_CLOSE_DATE,
    R.BOOK_TYPE_CODE
  FROM apps.FA_Retirements R,
    apps.FA_TRANSACTION_HEADERS H,
    apps.FA_DISTRIBUTION_HISTORY D,
    apps.FA_DEPRN_PERIODS DP
  WHERE R.RETIREMENT_ID                 = D.RETIREMENT_ID(+)
  AND R.ASSET_ID                        = D.ASSET_ID(+)
  AND R.ASSET_ID                        = H.ASSET_ID(+)
  AND R.TRANSACTION_HEADER_ID_IN        = H.TRANSACTION_HEADER_ID(+)
  AND R.BOOK_TYPE_CODE                  = DP.BOOK_TYPE_CODE
  AND TO_CHAR (R.DATE_RETIRED,'MON-YY') = DP.PERIOD_NAME
  AND DP.PERIOD_CLOSE_DATE             IS NOT NULL
  ) RETIREM
ON ( DEPRE.ASSET_ID                  = RETIREM.ASSET_ID
AND DEPRE.ccid                       = RETIREM.Code_Combination_Id
AND DEPRE.CALENDAR_PERIOD_CLOSE_DATE = RETIREM.CALENDAR_PERIOD_CLOSE_DATE
AND DEPRE.BOOK_TYPE_CODE             = RETIREM.BOOK_TYPE_CODE) ) DEP_AND_RET
LEFT OUTER JOIN
  (SELECT FAR.ASSET_ID,
    FAR.RETIREMENT_ID,
    FAR.DATE_RETIRED,
    FAR.COST_RETIRED,
    FAR.UNITS,
    FAR.NBV_RETIRED,
    FAH.TRANSACTION_TYPE_CODE,
    FDP.PERIOD_NAME,
    FDH.LOCATION_ID,
    (FDH.TRANSACTION_UNITS * -1) REINSTATED_UNIT,
    ( ( FAR.COST_RETIRED   * (FDH.TRANSACTION_UNITS * -1)) / FAR.UNITS) REINSTATED_COST,
    ( ( FAR.NBV_RETIRED    * (FDH.TRANSACTION_UNITS * -1)) / FAR.UNITS) REINSTATED_NBV
  FROM apps.FA_RETIREMENTS FAR,
    apps.FA_TRANSACTION_HEADERS FAH,
    apps.FA_DEPRN_PERIODS FDP,
    apps.FA_DISTRIBUTION_HISTORY FDH
  WHERE FAR.TRANSACTION_HEADER_ID_OUT       = FAH.TRANSACTION_HEADER_ID
  AND FDP.BOOK_TYPE_CODE                    = FAR.BOOK_TYPE_CODE
  AND FDP.PERIOD_CLOSE_DATE                IS NOT NULL
  AND (TO_CHAR (FAR.DATE_RETIRED, 'MON-YY') = FDP.PERIOD_NAME)
  AND FAR.ASSET_ID                          = FDH.ASSET_ID(+)
  AND FAR.RETIREMENT_ID                     = FDH.RETIREMENT_ID(+)
  AND FAH.TRANSACTION_TYPE_CODE             = 'REINSTATEMENT'
  ) REINSTATEMENT
ON DEP_AND_RET.ASSET_ID         = REINSTATEMENT.ASSET_ID
AND DEP_AND_RET.X_RETIREMENT_ID = REINSTATEMENT.RETIREMENT_ID
AND DEP_AND_RET.location_id     = REINSTATEMENT.location_id)
WHERE rownum                    < 10;
