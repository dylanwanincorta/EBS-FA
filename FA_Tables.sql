select * From all_objects where owner= 'FA' and object_type = 'TABLE';

-- perhaps build for calculating Quarter to Date and Year to Date meaures?
select * from FA_PERIOD_MAPS;

select * FRom FA_CONVENTIONS;

select distinct table_name FRom all_tab_columns where column_name = 'DATE_INEFFECTIVE' and table_name like 'FA_%';

--FA_BOOKS
--FA_ASSET_HISTORY
--FA_BOOK_CONTROLS
--FA_BOOK_CONTROLS_HISTORY
--FA_BOOKS_GROUPS
--FA_DISTRIBUTION_HISTORY
--FA_ASSET_INVOICES
--FA_SUPER_GROUP_RULES
--FA_IMPAIRMENTS
--FA_ADD_WARRANTIES
--FA_GROUP_ASSET_RULES




