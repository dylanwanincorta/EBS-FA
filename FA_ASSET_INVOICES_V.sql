SELECT * FROM all_views WHERE view_name = 'FA_ASSET_INVOICES_V';

-- a view on FA_ASSET_INVOICES grain
SELECT ad.asset_number,
  ad.tag_number,
  ad.description,
  lu.meaning ASSET_TYPE,
  ad.manufacturer_name,
  ad.serial_number,
  ad.model_number,
  ca.segment1 MAJOR_CATEGORY,
  /* customize */
  ca.segment2 SUB_CATEGORY,
  /* customize */
  bk.book_type_code,
  bk.date_placed_in_service,
  bk.deprn_method_code,
  bk.life_in_months,
  bk.salvage_value,
  bk.adjusted_rate,
  bk.production_capacity,
  -- invoice grain started here
  po_vn.vendor_name,
  po_vn.segment1 vendor_number,
  ai.po_number,
  ai.invoice_number,
  ai.invoice_id,
  ai.invoice_line_number,
  ai.description INVOICE_LINE_DESCRIPTION,
  ai.fixed_assets_cost INVOICE_COST,
  ai.ap_distribution_line_number DISTRIBUTION_LINE_NUMBER,
  ai.prior_source_line_id,
  ai.invoice_distribution_id,
  ai.po_distribution_id
FROM FA_ADDITIONS AD,
  FA_BOOK_CONTROLS BC,
  FA_BOOKS BK,
  FA_CATEGORIES_B CA,
  FA_ASSET_INVOICES AI,  
  PO_VENDORS PO_VN,   --> this is now a view.  
  FA_LOOKUPS LU
WHERE bc.book_class                  = 'CORPORATE'
AND bk.book_type_code                = bc.book_type_code
AND bk.asset_id                      = ad.asset_id
AND bk.period_counter_fully_retired IS NULL
AND bk.date_ineffective             IS NULL  --> only current
AND ca.category_id                   = ad.asset_category_id
AND lu.lookup_type                   = 'ASSET TYPE'
AND lu.lookup_code                   = ad.asset_type
AND ai.asset_id                      = ad.asset_id
AND ai.date_ineffective             IS NULL  --> only current
AND ai.deleted_flag                  = 'NO'
AND po_vn.vendor_id                  = ai.po_vendor_id
/

-- an asset may have multiple active invoices
select asset_id , count(*) 
from FA_ASSET_INVOICES 
where date_ineffective             IS NULL 
group by asset_id
having count(*) > 1;
/

select asset_invoice_id , date_effective, count(*) 
from FA_ASSET_INVOICES 
where 1=1
--and  date_ineffective             IS NULL 
group by asset_invoice_id, date_effective
having count(*) > 1;
/

select asset_invoice_id, count(*) 
from FA_ASSET_INVOICES 
where 1=1
--and  date_ineffective             IS NULL 
group by asset_invoice_id
having count(*) > 1;
/



-- and asset may have multiple book entries but only one in the corp book
select bk.asset_id , count(*) 
from FA_BOOKS bk 
inner join FA_BOOK_CONTROLS BC
ON bc.book_class                  = 'CORPORATE'
AND bk.book_type_code                = bc.book_type_code
where bk.date_ineffective             IS NULL 
AND bk.period_counter_fully_retired IS NULL
group by bk.asset_id
having count(*) > 1;

