SELECT ROWID,
  DATE_INEFFECTIVE,
  ASSET_ID,
  UNITS_ASSIGNED,
  ASSIGNED_TO,
  CODE_COMBINATION_ID,
  LOCATION_ID
FROM FA_DISTRIBUTION_HISTORY
WHERE asset_id                                = 102723
AND fa_distribution_history.date_ineffective IS NULL
ORDER BY asset_id