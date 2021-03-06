SELECT * FROM all_views WHERE view_name = 'FA_CATEGORIES_B_KFV';

SELECT ROWID,
  CATEGORY_ID,
  SEGMENT1  || '-'  || SEGMENT2,
  RPAD(NVL(SEGMENT1, ' '), 20)  || '-'  || RPAD(NVL(SEGMENT2, ' '), 20),
  SEGMENT1,SEGMENT2,SEGMENT3,SEGMENT4,SEGMENT5,SEGMENT6,SEGMENT7 ,
  START_DATE_ACTIVE,
  END_DATE_ACTIVE ,
  PROPERTY_TYPE_CODE,
  PROPERTY_1245_1250_CODE ,
  DATE_INEFFECTIVE ,
  CREATED_BY,
  CREATION_DATE ,
  LAST_UPDATE_LOGIN,
  ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,  ATTRIBUTE4,  ATTRIBUTE5,  ATTRIBUTE6,  ATTRIBUTE7,
  ATTRIBUTE8,  ATTRIBUTE9,  ATTRIBUTE10,  ATTRIBUTE11,  ATTRIBUTE12,  ATTRIBUTE13,
  ATTRIBUTE14,  ATTRIBUTE15,  ATTRIBUTE_CATEGORY_CODE 
,  PRODUCTION_CAPACITY,
  GLOBAL_ATTRIBUTE1,  GLOBAL_ATTRIBUTE2,  GLOBAL_ATTRIBUTE3,  GLOBAL_ATTRIBUTE4,  GLOBAL_ATTRIBUTE5,
  GLOBAL_ATTRIBUTE6,  GLOBAL_ATTRIBUTE7,  GLOBAL_ATTRIBUTE8,  GLOBAL_ATTRIBUTE9,  GLOBAL_ATTRIBUTE10,
  GLOBAL_ATTRIBUTE11,  GLOBAL_ATTRIBUTE12,  GLOBAL_ATTRIBUTE13,  GLOBAL_ATTRIBUTE14,  GLOBAL_ATTRIBUTE15,
  GLOBAL_ATTRIBUTE16,  GLOBAL_ATTRIBUTE17,  GLOBAL_ATTRIBUTE18,  GLOBAL_ATTRIBUTE19,  GLOBAL_ATTRIBUTE20,
  GLOBAL_ATTRIBUTE_CATEGORY ,
  INVENTORIAL,
  SUMMARY_FLAG,
  ENABLED_FLAG,
  OWNED_LEASED,
  LAST_UPDATE_DATE,
  LAST_UPDATED_BY,
  CATEGORY_TYPE,
  CAPITALIZE_FLAG
FROM FA_CATEGORIES_B;
--> We need to generate this using the Flexfield metadata generation tool

--FA_CATEGORIES_VL
SELECT *
FROM all_views
WHERE view_name = 'FA_CATEGORIES_VL';


SELECT B.ROWID ROW_ID,
  B.CATEGORY_ID,
  B.SUMMARY_FLAG,
  B.ENABLED_FLAG,
  B.OWNED_LEASED,
  B.LAST_UPDATE_DATE,  B.LAST_UPDATED_BY,
  B.CATEGORY_TYPE,
  B.CAPITALIZE_FLAG,
  T.DESCRIPTION,
  B.SEGMENT1,  B.SEGMENT2,  B.SEGMENT3,  B.SEGMENT4,  B.SEGMENT5,  B.SEGMENT6,  B.SEGMENT7,
  B.START_DATE_ACTIVE,
  B.END_DATE_ACTIVE,
  B.PROPERTY_TYPE_CODE,
  B.PROPERTY_1245_1250_CODE,
  B.DATE_INEFFECTIVE,
  B.CREATED_BY,  B.CREATION_DATE,  B.LAST_UPDATE_LOGIN,
  B.ATTRIBUTE1,  B.ATTRIBUTE2,  B.ATTRIBUTE3,  B.ATTRIBUTE4,  B.ATTRIBUTE5,  B.ATTRIBUTE6,  B.ATTRIBUTE7,  B.ATTRIBUTE8,
  B.ATTRIBUTE9,  B.ATTRIBUTE10,  B.ATTRIBUTE11,  B.ATTRIBUTE12,  B.ATTRIBUTE13,  B.ATTRIBUTE14,  B.ATTRIBUTE15,  B.ATTRIBUTE_CATEGORY_CODE,
  B.PRODUCTION_CAPACITY,
  B.GLOBAL_ATTRIBUTE1,  B.GLOBAL_ATTRIBUTE2,  B.GLOBAL_ATTRIBUTE3,  B.GLOBAL_ATTRIBUTE4,  B.GLOBAL_ATTRIBUTE5,  B.GLOBAL_ATTRIBUTE6,  B.GLOBAL_ATTRIBUTE7,
  B.GLOBAL_ATTRIBUTE8,  B.GLOBAL_ATTRIBUTE9,  B.GLOBAL_ATTRIBUTE10,  B.GLOBAL_ATTRIBUTE11,  B.GLOBAL_ATTRIBUTE12,  B.GLOBAL_ATTRIBUTE13,  B.GLOBAL_ATTRIBUTE14,
  B.GLOBAL_ATTRIBUTE15,  B.GLOBAL_ATTRIBUTE16,  B.GLOBAL_ATTRIBUTE17,  B.GLOBAL_ATTRIBUTE18,  B.GLOBAL_ATTRIBUTE19,  B.GLOBAL_ATTRIBUTE20,  B.GLOBAL_ATTRIBUTE_CATEGORY,
  B.INVENTORIAL
FROM FA_CATEGORIES_TL T,
  FA_CATEGORIES_B B
WHERE B.CATEGORY_ID = T.CATEGORY_ID
AND T.LANGUAGE      = userenv('LANG')
