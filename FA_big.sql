(SELECT ad.asset_id asset_id,
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
  SUM (dd.COST) COST,
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
  (SELECT ad.asset_id asset_id,
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
  )