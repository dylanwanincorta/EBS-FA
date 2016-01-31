select * From FA_ASSET_HISTORY;

-- Test uniqueness
select asset_id , date_effective
from FA_ASSET_HISTORY
group by asset_id, date_effective
having count(*) >1;
--> asset and date_Effective combination is unique

-- current asset
select asset_id
from FA_ASSET_HISTORY
WHERE DATE_INEFFECTIVE is null
group by asset_id
having count(*) >1;
-- the latest row only one row per asset

-- All assets have current records
select asset_id
from FA_ASSET_HISTORY INEFF
WHERE DATE_INEFFECTIVE is not null
and NOT EXISTS (Select 1 from FA_ASSET_HISTORY CURR where CURR.DATE_INEFFECTIVE is null and CURR.ASSET_ID = INEFF.ASSET_ID);
/

-- This table is a effective dated table!
select asset_id, date_effective, DATE_INEFFECTIVE from FA_ASSET_HISTORY where asset_id =100077; 

--> we should populate an infinite future date to simplify the range join.
