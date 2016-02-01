-- view Period end Book record!
-- This query can be run much fast in Incorta

SELECT /*+ index(dd FA_DEPRN_DETAIL_U1) */
          dh.asset_id,
          cb.category_id,
          dh.location_id,
             'YTD',
             dh.code_combination_id,
             nvl(dd.cost,0),
             dh.units_assigned + nvl(dh.TRANSACTION_UNITS, 0),
          nvl(dd.deprn_amount,0),
          dd.period_counter
--        nvl(dd.YTD_DEPRN,0)
        FROM fa.fa_distribution_history dh,
             fa.fa_deprn_detail         dd,
             fa.fa_asset_history        ah,
             fa.fa_category_books       cb,
             fa.fa_books                bk,
        fa.fa_deprn_periods      fdp
       WHERE dh.asset_id = NVL(p_asset_id, dh.asset_id)
         AND dh.book_type_code = p_asset_book
         AND dd.asset_id = dh.asset_id
         AND dd.book_type_code = dh.book_type_code
         AND dd.distribution_id = dh.distribution_id
         AND dd.period_counter <= p_period_counter
       AND fdp.period_counter = p_period_counter
       AND fdp.book_type_code = bk.book_type_code
         AND ah.asset_id = dh.asset_id
         AND ah.asset_type != 'EXPENSED'
         AND cb.category_id = ah.category_id
         AND cb.book_type_code = dd.book_type_code
         AND bk.book_type_code = cb.book_type_code
         AND bk.asset_id = dd.asset_id
       AND bk.transaction_header_id_in =
            (SELECT MAX (ifb.transaction_header_id_in)
               FROM fa.fa_books ifb
              WHERE ifb.book_type_code = bk.book_type_code
                AND ifb.asset_id = bk.asset_id
                AND ifb.date_effective < NVL (fdp.period_close_date, SYSDATE))
       AND   dh.transaction_header_id_in >= ah.transaction_header_id_in
         AND   dh.transaction_header_id_in < nvl(ah.transaction_header_id_out,dh.transaction_header_id_in+1)
         AND NVl(bk.period_counter_fully_retired,
                 p_period_counter + 1) > p_period_counter_first + 1
      AND dd.period_counter  between p_period_counter_first + 1 and p_period_counter
         AND DECODE(ah.asset_type,
                    'CAPITALIZED',
                    cb.asset_cost_acct,
                    NULL) IS NOT NULL