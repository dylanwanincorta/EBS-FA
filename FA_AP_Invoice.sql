-- This join can be used in reconcilation and drill down from FA to AP
-- However, it is more important to find which AP invoices should be added to FA
SELECT fa.asset_number,
       fai.asset_id,
       fai.asset_invoice_id,
       fai.fixed_assets_cost,
       fai.invoice_transaction_id_in,
       fai.invoice_number,
       fai.ap_distribution_line_number,
       fai.source_line_id,
       fai.invoice_distribution_id,
       fai.invoice_line_number,
       fai.invoice_id,  
       aia.invoice_id,   -- AP INvoice Header
       aila.line_number, -- AP Invoice Line!
       aida.invoice_distribution_id  -- AP Invoice Distribution
  FROM fa_additions                 fa,
       fa_asset_invoices            fai,
       ap_invoices_all              aia,
       ap_invoice_lines_all         aila,
       ap_invoice_distributions_all aida
 WHERE fai.invoice_id = aia.invoice_id
   AND aia.invoice_id = aila.invoice_id
   AND aia.invoice_id = aida.invoice_id
   AND aila.line_number = aida.invoice_line_number
   AND fai.invoice_line_number = aila.line_number  -- This join is the key
   AND fai.invoice_distribution_id = aida.invoice_distribution_id
   AND fai.asset_id = fa.asset_id
/