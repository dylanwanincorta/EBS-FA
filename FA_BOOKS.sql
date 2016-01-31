-- this poorly designed view may cause performance issue.

select * from all_views where view_name = 'FA_BOOKS_V';
 
SELECT bk.rowid row_id, bk.book_type_code, bk.asset_id, bk.date_placed_in_service, bk.date_effective
, bk.deprn_start_date, bk.deprn_method_code, bk.life_in_months, bk.rate_adjustment_factor
, bk.adjusted_cost, bk.cost, bk.original_cost, bk.salvage_value, bk.prorate_convention_code
, bk.prorate_date, bk.cost_change_flag, bk.adjustment_required_status, bk.capitalize_flag
, bk.retirement_pending_flag, bk.depreciate_flag, bk.last_update_date, bk.last_updated_by
, bk.date_ineffective, bk.transaction_header_id_in, bk.transaction_header_id_out, bk.itc_amount_id
, bk.itc_amount, bk.retirement_id, bk.tax_request_id, bk.itc_basis, bk.basic_rate, bk.adjusted_rate
, bk.bonus_rule, bk.ceiling_name, bk.recoverable_cost, bk.adjusted_recoverable_cost, bk.last_update_login
, bk.adjusted_capacity, bk.fully_rsvd_revals_counter, bk.idled_flag, bk.period_counter_capitalized, bk.period_counter_fully_reserved
, bk.period_counter_fully_retired, bk.period_counter_life_complete, bk.production_capacity, bk.reval_amortization_basis
, bk.reval_ceiling, bk.unit_of_measure, bk.unrevalued_cost, bk.annual_deprn_rounding_flag, bk.percent_salvage_value
, bk.allowed_deprn_limit, bk.allowed_deprn_limit_amount
, decode ( bc.allow_reval_flag, 'YES', 'Y', 'N') allow_reval_flag
, mth.rate_source_rule, mth.deprn_basis_rule, bk.global_attribute1
, bk.global_attribute2, bk.global_attribute3, bk.global_attribute4
, bk.global_attribute5, bk.global_attribute6, bk.global_attribute7
, bk.global_attribute8, bk.global_attribute9, bk.global_attribute10
, bk.global_attribute11, bk.global_attribute12, bk.global_attribute13
, bk.global_attribute14, bk.global_attribute15, bk.global_attribute16
, bk.global_attribute17, bk.global_attribute18, bk.global_attribute19
, bk.global_attribute20, bk.global_attribute_category
, bk.short_fiscal_year_flag, bk.conversion_date
, bk.original_deprn_start_date, bk.formula_factor
, bk.group_asset_id , bk.super_group_id , bk.reduction_rate , bk.reduce_addition_flag 
, bk.reduce_adjustment_flag , bk.reduce_retirement_flag , bk.over_depreciate_option 
, bk.recognize_gain_loss , bk.recapture_reserve_flag , bk.limit_proceeds_flag 
, bk.terminal_gain_loss , bk.salvage_type , bk.deprn_limit_type , bk.tracking_method 
, bk.allocate_to_fully_rsv_flag , bk.allocate_to_fully_ret_flag , bk.excess_allocation_option 
, bk.depreciation_option , bk.member_rollup_flag , bk.ytd_proceeds , bk.ltd_proceeds 
, bk.exclude_fully_rsv_flag , bk.eofy_reserve , bk.terminal_gain_loss_amount , bk.ltd_cost_of_removal 
, bk.exclude_proceeds_from_basis , bk.retirement_deprn_option , bk.terminal_gain_loss_flag , bk.disabled_flag 
, bk.old_adjusted_capacity , bk.cash_generating_unit_id ,bk.nbv_at_switch , bk.prior_deprn_limit_type 
, bk.prior_deprn_limit_amount , bk.prior_deprn_limit , bk.prior_deprn_method , bk.prior_life_in_months 
, bk.prior_basic_rate , bk.prior_adjusted_rate , bk.extended_depreciation_period ,bk.extended_deprn_flag 
from fa_books bk, fa_book_controls bc, fa_methods mth 
WHERE bk.date_ineffective is null 
and bk.book_type_code = bc.book_type_code 
and bk.deprn_method_code = mth.method_code 
and bk.life_in_months = mth.life_in_months 
UNION 
select bk.rowid row_id, bk.book_type_code, bk.asset_id, bk.date_placed_in_service, bk.date_effective
, bk.deprn_start_date, bk.deprn_method_code, bk.life_in_months
, bk.rate_adjustment_factor, bk.adjusted_cost, bk.cost, bk.original_cost, bk.salvage_value, bk.prorate_convention_code
, bk.prorate_date, bk.cost_change_flag, bk.adjustment_required_status, bk.capitalize_flag, bk.retirement_pending_flag
, bk.depreciate_flag, bk.last_update_date, bk.last_updated_by, bk.date_ineffective, bk.transaction_header_id_in
, bk.transaction_header_id_out, bk.itc_amount_id, bk.itc_amount, bk.retirement_id, bk.tax_request_id, bk.itc_basis
, bk.basic_rate, bk.adjusted_rate, bk.bonus_rule, bk.ceiling_name, bk.recoverable_cost, bk.adjusted_recoverable_cost
, bk.last_update_login, bk.adjusted_capacity, bk.fully_rsvd_revals_counter, bk.idled_flag, bk.period_counter_capitalized
, bk.period_counter_fully_reserved, bk.period_counter_fully_retired, bk.period_counter_life_complete, bk.production_capacity
, bk.reval_amortization_basis, bk.reval_ceiling, bk.unit_of_measure, bk.unrevalued_cost, bk.annual_deprn_rounding_flag
, bk.percent_salvage_value, bk.allowed_deprn_limit, bk.allowed_deprn_limit_amount
, decode ( bc.allow_reval_flag, 'YES', 'Y', 'N') allow_reval_flag, mth.rate_source_rule, mth.deprn_basis_rule
, bk.global_attribute1, bk.global_attribute2, bk.global_attribute3, bk.global_attribute4, bk.global_attribute5, bk.global_attribute6
, bk.global_attribute7, bk.global_attribute8, bk.global_attribute9, bk.global_attribute10, bk.global_attribute11, bk.global_attribute12
, bk.global_attribute13, bk.global_attribute14, bk.global_attribute15, bk.global_attribute16, bk.global_attribute17, bk.global_attribute18
, bk.global_attribute19, bk.global_attribute20, bk.global_attribute_category
, bk.short_fiscal_year_flag, bk.conversion_date, bk.original_deprn_start_date, bk.formula_factor, bk.group_asset_id 
, bk.super_group_id , bk.reduction_rate , bk.reduce_addition_flag , bk.reduce_adjustment_flag , bk.reduce_retirement_flag 
, bk.over_depreciate_option , bk.recognize_gain_loss , bk.recapture_reserve_flag , bk.limit_proceeds_flag , bk.terminal_gain_loss 
, bk.salvage_type , bk.deprn_limit_type , bk.tracking_method , bk.allocate_to_fully_rsv_flag , bk.allocate_to_fully_ret_flag 
, bk.excess_allocation_option , bk.depreciation_option , bk.member_rollup_flag , bk.ytd_proceeds , bk.ltd_proceeds 
, bk.exclude_fully_rsv_flag , bk.eofy_reserve , bk.terminal_gain_loss_amount , bk.ltd_cost_of_removal 
, bk.exclude_proceeds_from_basis , bk.retirement_deprn_option , bk.terminal_gain_loss_flag , bk.disabled_flag 
, bk.old_adjusted_capacity , bk.cash_generating_unit_id ,bk.nbv_at_switch , bk.prior_deprn_limit_type 
, bk.prior_deprn_limit_amount , bk.prior_deprn_limit , bk.prior_deprn_method , bk.prior_life_in_months 
, bk.prior_basic_rate , bk.prior_adjusted_rate , bk.extended_depreciation_period ,bk.extended_deprn_flag 
from fa_books bk, fa_book_controls bc, fa_methods mth 
where bk.date_ineffective is null 
and bk.book_type_code = bc.book_type_code 
and bk.deprn_method_code = mth.method_code 
and bk.life_in_months is null 
and mth.life_in_months is null
/

select distinct life_in_months from fa_books;
 
-- there is no row with value 0
-- we can use 0 to eliminate the union