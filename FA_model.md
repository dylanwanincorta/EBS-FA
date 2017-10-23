## FA_ADDITIONS_B

FA_ADDITIONS_B contains descriptive information to help you identify your assets. Oracle Assets does not use this table to calculate depreciation.

## FA_BOOKS

FA_BOOKS contains the information that Oracle Assets needs to calculate depreciation. When you initially add an asset, Oracle Assets inserts one row into the table. This becomes the ”active” row for the asset. Whenever you use the Depreciation Books form to change the asset’s depreciation information, or if you retire or reinstate it, Oracle Assets inserts another row into the table, which then becomes the new ”active” row, and marks the previous row as obsolete.

## FA_DEPRN_PERIODS

FA_DEPRN_PERIODS contains information about your depreciation periods. Oracle Assets uses this table to determine when each period in FA_CALENDARS was open for a depreciation book.

## 
