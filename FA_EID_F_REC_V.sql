
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "APPS"."FA_EID_F_REC_V" ("ASSET_REC_SPEC", "AE_LINE_REFERENCE", "ACCT_LINE_TYPE", "ACCT_LINE_TYPE_NAME", "GL_TRANSFER_STATUS", "GL_TRANSFER_STATUS_NAME", "LEDGER_NAME", "CURRENCY_CODE", "CURRENT_PERIOD", "LAST_CLOSED_PERIOD", "BOOK_TYPE_CODE", "ORG_ID", "ASSET_ID", "ASSET_NUMBER", "ASSET_DESCRIPTION", "ASSET_CATEGORY_ID", "MAJOR_CATEGORY", "MINOR_CATEGORY", "AE_HEADER_ID", "AE_LINE_NUM", "GL_SL_LINK_ID", "GL_SL_LINK_TABLE", "XLA_ACCOUNTING_DATE", "XLA_PERIOD_NAME", "XLA_BALANCE_TYPE", "XLA_CATEGORY_NAME", "ACCOUNTING_ENTRY_STATUS_CODE", "XLA_GL_TRANSFER_STATUS_CODE", "XLA_CCID", "XLA_ACCOUNTED_DR", "XLA_ACCOUNTED_CR", "XLA_ACC_CODE", "XLA_ACC_DESCRIPTION", "XLA_CC_CODE", "XLA_CC_DESCRIPTION", "IR_GL_SL_LINK_ID", "IR_GL_SL_LINK_TABLE", "JE_HEADER_ID", "JE_LINE_NUM", "BATCH_NAME", "JE_SOURCE", "JE_CATEGORY", "PERIOD_NAME", "JOURNAL", "LINE_TYPE_CODE", "JOURNAL_LINE_DESCRIPTION", "GL_CCID", "GL_ACCOUNTED_CR", "GL_ACCOUNTED_DR", "GL_ACC_CODE", "GL_ACC_DESCRIPTION", "GL_CC_CODE", "GL_CC_DESCRIPTION") AS 
  Select /*ASSET_REC_SPEC*/
 FA_AEL.TRX_HDR_ID ||'-'||FA_AEL.ADJUSTMENT_LINE_ID||'-'||LINES.AE_HEADER_ID||'-'||LINES.AE_LINE_NUM||'-'||lines.GL_SL_LINK_ID AS ASSET_REC_SPEC
/* Assets info*/
,FA_AEL.AE_LINE_REFERENCE
,FA_AEL.ACCT_LINE_TYPE
,FA_AEL.ACCT_LINE_TYPE_NAME
,FA_AEL.GL_TRANSFER_STATUS 
,FA_AEL.GL_TRANSFER_STATUS_NAME
,FA_AEL.LEDGER AS LEDGER_NAME
,FA_AEL.CURRENCY_CODE
--newly add attributes to get the current open period and last closed period in fa
,FA_AEL.current_period
,FA_AEL.last_closed_period
,FA_AEL.BOOK_TYPE_CODE
,FA_AEL.ORG_ID
,FA_AEL.ASSET_ID
,FA_AEL.ASSET_NUMBER
,FA_AEL.ASSET_DESCRIPTION
,FA_AEL.ASSET_CATEGORY_ID
,FA_AEL.major_category
,FA_AEL.minor_category

/*XLA INFO*/
,lines.AE_HEADER_ID
,lines.AE_LINE_NUM
,lines.GL_SL_LINK_ID
,lines.GL_SL_LINK_TABLE
,LINES.ACCOUNTING_DATE XLA_ACCOUNTING_DATE
,HEADERS.PERIOD_NAME XLA_PERIOD_NAME
,HEADERS.BALANCE_TYPE_CODE XLA_BALANCE_TYPE
,HEADERS.JE_CATEGORY_NAME XLA_CATEGORY_NAME
,headers.ACCOUNTING_ENTRY_STATUS_CODE
,headers.GL_TRANSFER_STATUS_CODE AS XLA_GL_TRANSFER_STATUS_CODE
,LINES.CODE_COMBINATION_ID xla_ccid
,LINES.ACCOUNTED_DR as xla_accounted_dr
,LINES.ACCOUNTED_CR as xla_accounted_cr 
,DECODE (LINES.CODE_COMBINATION_ID, NULL, NULL,FND_FLEX_XML_PUBLISHER_APIS.PROCESS_KFF_COMBINATION_1
                (P_LEXICAL_NAME => 'ACCOUNT CODE'
                , P_APPLICATION_SHORT_NAME => 'SQLGL'
                , P_ID_FLEX_CODE => 'GL#'
                , P_ID_FLEX_NUM => FA_AEL.CHART_OF_ACCOUNTS_ID
                , P_DATA_SET => FA_AEL.CHART_OF_ACCOUNTS_ID
                , P_CCID => LINES.CODE_COMBINATION_ID
                , P_SEGMENTS => 'GL_ACCOUNT'
                , P_SHOW_PARENT_SEGMENTS => 'Y'
                , P_OUTPUT_TYPE=>'VALUE')) AS XLA_ACC_CODE 
                 
,DECODE(LINES.CODE_COMBINATION_ID, NULL, NULL,FND_FLEX_XML_PUBLISHER_APIS.PROCESS_KFF_COMBINATION_1
                (P_LEXICAL_NAME => 'ACCOUNT CODE'
                , P_APPLICATION_SHORT_NAME => 'SQLGL'
                , P_ID_FLEX_CODE => 'GL#'
                , P_ID_FLEX_NUM => FA_AEL.CHART_OF_ACCOUNTS_ID
                , P_DATA_SET => FA_AEL.CHART_OF_ACCOUNTS_ID
                , P_CCID => LINES.CODE_COMBINATION_ID
                , P_SEGMENTS => 'GL_ACCOUNT'
                , P_SHOW_PARENT_SEGMENTS => 'Y'
                , P_OUTPUT_TYPE=>'DESCRIPTION')) AS XLA_ACC_DESCRIPTION 

,DECODE (LINES.CODE_COMBINATION_ID, NULL, NULL,FND_FLEX_XML_PUBLISHER_APIS.PROCESS_KFF_COMBINATION_1
                (P_LEXICAL_NAME => 'COST CENTER'
                , P_APPLICATION_SHORT_NAME => 'SQLGL'
                , P_ID_FLEX_CODE => 'GL#'
                , P_ID_FLEX_NUM => FA_AEL.CHART_OF_ACCOUNTS_ID
                , P_DATA_SET => FA_AEL.CHART_OF_ACCOUNTS_ID
                , P_CCID => LINES.CODE_COMBINATION_ID
                , P_SEGMENTS => 'FA_COST_CTR'
                , P_SHOW_PARENT_SEGMENTS => 'Y'
                , P_OUTPUT_TYPE=>'VALUE')) AS XLA_CC_CODE 
                 
,DECODE (LINES.CODE_COMBINATION_ID, NULL, NULL,FND_FLEX_XML_PUBLISHER_APIS.PROCESS_KFF_COMBINATION_1
                (P_LEXICAL_NAME => 'ACCOUNT CODE'
                , P_APPLICATION_SHORT_NAME => 'SQLGL'
                , P_ID_FLEX_CODE => 'GL#'
                , P_ID_FLEX_NUM => FA_AEL.CHART_OF_ACCOUNTS_ID
                , P_DATA_SET => FA_AEL.CHART_OF_ACCOUNTS_ID
                , P_CCID => LINES.CODE_COMBINATION_ID
                , P_SEGMENTS => 'FA_COST_CTR'
                , P_SHOW_PARENT_SEGMENTS => 'Y'
                , P_OUTPUT_TYPE=>'DESCRIPTION')) AS XLA_CC_DESCRIPTION 

/*GL info*/
,GIR.GL_SL_LINK_ID AS IR_GL_SL_LINK_ID
,GIR.GL_SL_LINK_TABLE AS IR_GL_SL_LINK_TABLE 
,GJL.JE_HEADER_ID
,GJL.JE_LINE_NUM
,GJB.NAME BATCH_NAME
,GJH.JE_SOURCE
,GJH.JE_CATEGORY
,GJH.PERIOD_NAME
,GJH.NAME AS JOURNAL
,GJL.LINE_TYPE_CODE
,GJL.DESCRIPTION AS JOURNAL_LINE_DESCRIPTION
,GJL.CODE_COMBINATION_ID AS GL_CCID
,GJL.ACCOUNTED_CR AS GL_ACCOUNTED_CR
,GJL.ACCOUNTED_DR AS GL_ACCOUNTED_DR
,DECODE (GJL.CODE_COMBINATION_ID, NULL, NULL,FND_FLEX_XML_PUBLISHER_APIS.PROCESS_KFF_COMBINATION_1
                (P_LEXICAL_NAME => 'ACCOUNT CODE'
                , P_APPLICATION_SHORT_NAME => 'SQLGL'
                , P_ID_FLEX_CODE => 'GL#'
                , P_ID_FLEX_NUM => FA_AEL.CHART_OF_ACCOUNTS_ID
                , P_DATA_SET => FA_AEL.CHART_OF_ACCOUNTS_ID
                , P_CCID => GJL.CODE_COMBINATION_ID
                , P_SEGMENTS => 'GL_ACCOUNT'
                , P_SHOW_PARENT_SEGMENTS => 'Y'
                , P_OUTPUT_TYPE=>'VALUE')) AS GL_ACC_CODE 
                 
,DECODE(GJL.CODE_COMBINATION_ID, NULL, NULL,FND_FLEX_XML_PUBLISHER_APIS.PROCESS_KFF_COMBINATION_1
                (P_LEXICAL_NAME => 'ACCOUNT CODE'
                , P_APPLICATION_SHORT_NAME => 'SQLGL'
                , P_ID_FLEX_CODE => 'GL#'
                , P_ID_FLEX_NUM => FA_AEL.CHART_OF_ACCOUNTS_ID
                , P_DATA_SET => FA_AEL.CHART_OF_ACCOUNTS_ID
                , P_CCID => GJL.CODE_COMBINATION_ID
                , P_SEGMENTS => 'GL_ACCOUNT'
                , P_SHOW_PARENT_SEGMENTS => 'Y'
                , P_OUTPUT_TYPE=>'DESCRIPTION')) AS GL_ACC_DESCRIPTION 

,DECODE (GJL.CODE_COMBINATION_ID, NULL, NULL,FND_FLEX_XML_PUBLISHER_APIS.PROCESS_KFF_COMBINATION_1
                (P_LEXICAL_NAME => 'COST CENTER'
                , P_APPLICATION_SHORT_NAME => 'SQLGL'
                , P_ID_FLEX_CODE => 'GL#'
                , P_ID_FLEX_NUM => FA_AEL.CHART_OF_ACCOUNTS_ID
                , P_DATA_SET => FA_AEL.CHART_OF_ACCOUNTS_ID
                , P_CCID => GJL.CODE_COMBINATION_ID
                , P_SEGMENTS => 'FA_COST_CTR'
                , P_SHOW_PARENT_SEGMENTS => 'Y'
                , P_OUTPUT_TYPE=>'VALUE')) AS GL_CC_CODE 
                 
,DECODE (GJL.CODE_COMBINATION_ID, NULL, NULL,FND_FLEX_XML_PUBLISHER_APIS.PROCESS_KFF_COMBINATION_1
                (P_LEXICAL_NAME => 'ACCOUNT CODE'
                , P_APPLICATION_SHORT_NAME => 'SQLGL'
                , P_ID_FLEX_CODE => 'GL#'
                , P_ID_FLEX_NUM => FA_AEL.CHART_OF_ACCOUNTS_ID
                , P_DATA_SET => FA_AEL.CHART_OF_ACCOUNTS_ID
                , P_CCID => GJL.CODE_COMBINATION_ID
                , P_SEGMENTS => 'FA_COST_CTR'
                , P_SHOW_PARENT_SEGMENTS => 'Y'
                , P_OUTPUT_TYPE=>'DESCRIPTION')) AS GL_CC_DESCRIPTION 
FROM 
(SELECT 
 L1.MEANING || ' : ' || TO_NUMBER(TH.TRANSACTION_HEADER_ID) AE_LINE_REFERENCE
, ADJ.ADJUSTMENT_TYPE ACCT_LINE_TYPE
, LUTL.MEANING ACCT_LINE_TYPE_NAME
, ADJ.CODE_COMBINATION_ID CODE_COMBINATION_ID
, LGR.CHART_OF_ACCOUNTS_ID
, LGR.NAME as LEDGER
, LGR.CURRENCY_CODE AS CURRENCY_CODE
, dp1.period_name current_period
, dp1.FISCAL_YEAR as fiscal_year
, dp2.PERIOD_NAME last_closed_period
, DECODE(ADJ.JE_HEADER_ID, NULL, 'N', 'Y') GL_TRANSFER_STATUS
, L3.MEANING GL_TRANSFER_STATUS_NAME
, BC.SET_OF_BOOKS_ID SET_OF_BOOKS_ID
,  NVL (bc.org_id, -9999) AS org_id
, TH.TRANSACTION_HEADER_ID SOURCE_ID
, TH.TRANSACTION_HEADER_ID TRX_HDR_ID
, ADJ.ADJUSTMENT_LINE_ID
, ADJ.LAST_UPDATE_DATE LAST_UPDATE_DATE
, TH.ASSET_ID ASSET_ID
, AD.ASSET_NUMBER ASSET_NUMBER
, AD.DESCRIPTION ASSET_DESCRIPTION
, TH.BOOK_TYPE_CODE BOOK_TYPE_CODE
, AH.CATEGORY_ID ASSET_CATEGORY_ID
, DECODE
             (ca.category_id,
              NULL, NULL,
              fnd_flex_xml_publisher_apis.process_kff_combination_1
                                (p_lexical_name                => 'AssetCategory',
                                 p_application_short_name      => 'OFA',
                                 p_id_flex_code                => 'CAT#',
                                 p_id_flex_num                 => SYS.category_flex_structure,
                                 p_data_set                    => SYS.category_flex_structure,
                                 p_ccid                        => ca.category_id,
                                 p_segments                    => 'BASED_CATEGORY',
                                 p_show_parent_segments        => 'N',
                                 p_output_type                 => 'FULL_DESCRIPTION'
                                )
             ) AS major_category          
, DECODE
             (ca.category_id,
              NULL, NULL,
              fnd_flex_xml_publisher_apis.process_kff_combination_1
                                (p_lexical_name                => 'AssetCategory',
                                 p_application_short_name      => 'OFA',
                                 p_id_flex_code                => 'CAT#',
                                 p_id_flex_num                 => SYS.category_flex_structure,
                                 p_data_set                    => SYS.category_flex_structure,
                                 p_ccid                        => ca.category_id,
                                 p_segments                    => 'MINOR_CATEGORY',
                                 p_show_parent_segments        => 'N',
                                 p_output_type                 => 'FULL_DESCRIPTION'
                                )
             ) AS minor_category

, ADJ.JE_HEADER_ID JE_HEADER_ID
, ADJ.JE_LINE_NUM JE_LINE_NUM
FROM 
  FA_SYSTEM_CONTROLS SYS
, FA_LOOKUPS L3
, FA_LOOKUPS L1
, FA_LOOKUPS_TL LUTL
, GL_LEDGERS LGR
, FA_BOOK_CONTROLS BC
, FA_ASSET_HISTORY AH
, FA_ADDITIONS AD
, FA_ADJUSTMENTS ADJ
, FA_TRANSACTION_HEADERS TH
, fa_deprn_periods dp1
, fa_deprn_periods dp2
, fa_categories_b_kfv      ck
, fa_categories_b          ca
, fa_category_books        cb

WHERE 
BC.BOOK_CLASS = 'CORPORATE'
AND bc.date_ineffective IS NULL
AND L3.LOOKUP_CODE = DECODE(ADJ.JE_HEADER_ID, NULL, 'NO', 'YES')
AND L3.LOOKUP_TYPE = 'YESNO'
AND L1.LOOKUP_TYPE = 'FAXOLTRX'
AND L1.LOOKUP_CODE = TH.TRANSACTION_TYPE_CODE
AND LGR.OBJECT_TYPE_CODE = 'L'
AND NVL(LGR.COMPLETE_FLAG, 'Y') = 'Y'
AND LGR.LEDGER_ID = BC.SET_OF_BOOKS_ID
AND BC.BOOK_TYPE_CODE = TH.BOOK_TYPE_CODE
AND AH.ASSET_ID = AD.ASSET_ID
AND TH.TRANSACTION_HEADER_ID >= AH.TRANSACTION_HEADER_ID_IN
AND TH.TRANSACTION_HEADER_ID < NVL(AH.TRANSACTION_HEADER_ID_OUT, TH.TRANSACTION_HEADER_ID + 1)
AND TH.ASSET_ID = AD.ASSET_ID
AND ADJ.SOURCE_TYPE_CODE <> 'DEPRECIATION' 
AND TH.TRANSACTION_HEADER_ID = ADJ.TRANSACTION_HEADER_ID
AND TH.BOOK_TYPE_CODE = ADJ.BOOK_TYPE_CODE
AND TH.ASSET_ID = ADJ.ASSET_ID
AND LUTL.LOOKUP_CODE= ADJ.ADJUSTMENT_TYPE
AND LUTL.LOOKUP_TYPE='ADJUSTMENT TYPE'
AND LUTL.LANGUAGE =USERENV('LANG')
AND AH.CATEGORY_ID = ck.category_id
AND CA.ENABLED_FLAG = 'Y'
AND CA.END_DATE_ACTIVE IS NULL  
AND cb.book_type_code = bc.book_type_code
And Ca.Category_Id = Cb.Category_Id
And Cb.Category_Id = Ah.Category_Id 
AND bc.book_type_code = dp1.book_type_code
AND bc.last_period_counter + 1 = dp1.period_counter
AND dp1.period_close_date IS NULL
AND bc.book_type_code = dp2.book_type_code
AND bc.last_period_counter = dp2.period_counter
AND dp2.period_close_date IS NOT NULL
) Fa_Ael
,Gl_Je_Lines Gjl
,Gl_Je_Headers Gjh
,Gl_Je_Batches Gjb
,Xla_Distribution_Links Links
,Xla_Ae_Lines Lines
,Xla_Ae_Headers Headers
,GL_IMPORT_REFERENCES GIR
WHERE 
    FA_AEL.JE_HEADER_ID = GJL.JE_HEADER_ID(+)
AND Fa_Ael.Code_Combination_Id = Gjl.Code_Combination_Id(+)
And Gjl.Je_Header_Id = Gjh.Je_Header_Id(+)
And Gjh.Je_Batch_Id = Gjb.Je_Batch_Id(+)
AND Fa_Ael.Trx_Hdr_Id = Links.Source_Distribution_Id_Num_1(+)
And Fa_Ael.Adjustment_Line_Id = Links.Source_Distribution_Id_Num_2
AND links.application_id = 140
and Links.Ae_Header_Id = Lines.Ae_Header_Id
And Links.Ae_Line_Num = Lines.Ae_Line_Num
And Lines.Ae_Header_Id = Headers.Ae_Header_Id
And Lines.Ledger_Id = Fa_Ael.Set_Of_Books_Id
And Lines.Application_Id = 140
AND links.source_distribution_type = 'TRX'
And Lines.Gl_Sl_Link_Id = Gir.Gl_Sl_Link_Id(+)
AND Lines.Gl_Sl_Link_Table = Gir.Gl_Sl_Link_Table(+)
   ;
