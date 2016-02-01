SELECT * FROM all_views WHERE view_name = 'FA_EMPLOYEES';

SELECT P.Person_Id Employee_ID,
  P.Employee_Number,
  P.Full_Name Name,
  S.Actual_Termination_Date
FROM PER_PERIODS_OF_SERVICE S,
  PER_PEOPLE_X P
WHERE P.Person_ID = S.Person_ID
/


-- This is a view
SELECT * FROM all_views WHERE view_name = 'PER_PEOPLE_X';
--> Only the current record
SELECT PERSON_ID,
  EFFECTIVE_START_DATE,
  EFFECTIVE_END_DATE,
  BUSINESS_GROUP_ID,
  PERSON_TYPE_ID,
  LAST_NAME,
  START_DATE,
  APPLICANT_NUMBER,
  COMMENT_ID,
  CURRENT_APPLICANT_FLAG,
  CURRENT_EMP_OR_APL_FLAG,
  CURRENT_EMPLOYEE_FLAG,
  DATE_EMPLOYEE_DATA_VERIFIED,
  DATE_OF_BIRTH,
  EMAIL_ADDRESS,
  EMPLOYEE_NUMBER,
  EXPENSE_CHECK_SEND_TO_ADDRESS,
  FIRST_NAME,
  FULL_NAME,
  KNOWN_AS,
  MARITAL_STATUS,
  MIDDLE_NAMES,
  NATIONALITY,
  NATIONAL_IDENTIFIER,
  PREVIOUS_LAST_NAME,
  REGISTERED_DISABLED_FLAG,
  SEX,
  TITLE,
  VENDOR_ID,
  WORK_TELEPHONE,
  REQUEST_ID,
  PROGRAM_APPLICATION_ID,
  PROGRAM_ID,
  PROGRAM_UPDATE_DATE,
  ATTRIBUTE_CATEGORY,
  ATTRIBUTE1,  ATTRIBUTE2,  ATTRIBUTE3,  ATTRIBUTE4,  ATTRIBUTE5,
  ATTRIBUTE6,  ATTRIBUTE7,  ATTRIBUTE8,  ATTRIBUTE9,  ATTRIBUTE10,
  ATTRIBUTE11,  ATTRIBUTE12,  ATTRIBUTE13,  ATTRIBUTE14,  ATTRIBUTE15,
  ATTRIBUTE16,  ATTRIBUTE17,  ATTRIBUTE18,  ATTRIBUTE19,  ATTRIBUTE20,
  ATTRIBUTE21,  ATTRIBUTE22,  ATTRIBUTE23,  ATTRIBUTE24,  ATTRIBUTE25,
  ATTRIBUTE26,  ATTRIBUTE27,  ATTRIBUTE28,  ATTRIBUTE29,  ATTRIBUTE30,
  LAST_UPDATE_DATE,
  LAST_UPDATED_BY,
  LAST_UPDATE_LOGIN,
  CREATED_BY,
  CREATION_DATE,
  PER_INFORMATION_CATEGORY,
  PER_INFORMATION1,  PER_INFORMATION2,  PER_INFORMATION3,  PER_INFORMATION4,  PER_INFORMATION5,
  PER_INFORMATION6,  PER_INFORMATION7,  PER_INFORMATION8,  PER_INFORMATION9,  PER_INFORMATION10,
  PER_INFORMATION11,  PER_INFORMATION12,  PER_INFORMATION13,  PER_INFORMATION14,  PER_INFORMATION15,
  PER_INFORMATION16,  PER_INFORMATION17,  PER_INFORMATION18,  PER_INFORMATION19,  PER_INFORMATION20,
  PER_INFORMATION21,  PER_INFORMATION22,  PER_INFORMATION23,  PER_INFORMATION24,  PER_INFORMATION25,
  PER_INFORMATION26,  PER_INFORMATION27,  PER_INFORMATION28,  PER_INFORMATION29,  PER_INFORMATION30,
  SUFFIX,
  OBJECT_VERSION_NUMBER,
  WORK_SCHEDULE,
  CORRESPONDENCE_LANGUAGE,
  STUDENT_STATUS,
  FTE_CAPACITY,
  ON_MILITARY_SERVICE,
  SECOND_PASSPORT_EXISTS,
  BACKGROUND_CHECK_STATUS,
  BACKGROUND_DATE_CHECK,
  BLOOD_TYPE,
  LAST_MEDICAL_TEST_DATE,
  LAST_MEDICAL_TEST_BY,
  REHIRE_RECOMMENDATION,
  REHIRE_AUTHORIZOR,
  REHIRE_REASON,
  RESUME_EXISTS,
  RESUME_LAST_UPDATED,
  OFFICE_NUMBER,
  INTERNAL_LOCATION,
  MAILSTOP,
  PROJECTED_START_DATE,
  HONORS,
  PRE_NAME_ADJUNCT,
  HOLD_APPLICANT_DATE_UNTIL,
  COORD_BEN_MED_PLN_NO,
  COORD_BEN_NO_CVG_FLAG,
  DPDNT_ADOPTION_DATE,
  DPDNT_VLNTRY_SVCE_FLAG,
  RECEIPT_OF_DEATH_CERT_DATE,
  USES_TOBACCO_FLAG,
  BENEFIT_GROUP_ID,
  ORIGINAL_DATE_OF_HIRE,
  TOWN_OF_BIRTH,
  REGION_OF_BIRTH,
  COUNTRY_OF_BIRTH,
  GLOBAL_PERSON_ID,
  COORD_BEN_MED_EXT_ER,
  COORD_BEN_MED_PL_NAME,
  COORD_BEN_MED_INSR_CRR_NAME,
  COORD_BEN_MED_INSR_CRR_IDENT,
  COORD_BEN_MED_CVG_STRT_DT,
  COORD_BEN_MED_CVG_END_DT,
  NPW_NUMBER,
  CURRENT_NPW_FLAG,
  GLOBAL_NAME,
  LOCAL_NAME,
  LIST_NAME
FROM PER_PEOPLE_F  -- This is still a view
WHERE TRUNC(SYSDATE) BETWEEN EFFECTIVE_START_DATE AND EFFECTIVE_END_DATE
/

-- Check the view
SELECT * FROM all_views WHERE view_name = 'PER_PEOPLE_F';

--> this PER_PEOPLE_F is a secured view on PER_ALL_PEOPLE_F
SELECT PERSON_ID ,
  EFFECTIVE_START_DATE ,
  EFFECTIVE_END_DATE ,
  BUSINESS_GROUP_ID ,
  PERSON_TYPE_ID ,
  LAST_NAME ,
  START_DATE ,
  APPLICANT_NUMBER ,
  COMMENT_ID ,
  CURRENT_APPLICANT_FLAG ,
  CURRENT_EMP_OR_APL_FLAG ,
  CURRENT_EMPLOYEE_FLAG ,
  DATE_EMPLOYEE_DATA_VERIFIED ,
  DATE_OF_BIRTH ,
  EMAIL_ADDRESS ,
  EMPLOYEE_NUMBER ,
  EXPENSE_CHECK_SEND_TO_ADDRESS ,
  FAST_PATH_EMPLOYEE ,
  FIRST_NAME ,
  FULL_NAME ,
  ORDER_NAME ,
  KNOWN_AS ,
  MARITAL_STATUS ,
  MIDDLE_NAMES ,
  NATIONALITY ,
  NATIONAL_IDENTIFIER ,
  PREVIOUS_LAST_NAME ,
  REGISTERED_DISABLED_FLAG ,
  SEX ,
  TITLE ,
  VENDOR_ID ,
  HR_GENERAL.GET_WORK_PHONE(PAP.PERSON_ID) WORK_TELEPHONE ,
  REQUEST_ID ,
  PROGRAM_APPLICATION_ID ,
  PROGRAM_ID ,
  PROGRAM_UPDATE_DATE ,
  ATTRIBUTE_CATEGORY ,
  ATTRIBUTE1 ,
--
  ATTRIBUTE30 ,
  LAST_UPDATE_DATE ,
  LAST_UPDATED_BY ,
  LAST_UPDATE_LOGIN ,
  CREATED_BY ,
  CREATION_DATE ,
  PER_INFORMATION_CATEGORY ,
  PER_INFORMATION1 ,
  PER_INFORMATION2 ,
  PER_INFORMATION3 ,
  PER_INFORMATION4 ,
  PER_INFORMATION5 ,
  PER_INFORMATION6 ,
  PER_INFORMATION7 ,
  PER_INFORMATION8 ,
  PER_INFORMATION9 ,
  PER_INFORMATION10 ,
  PER_INFORMATION11 ,
  PER_INFORMATION12 ,
  PER_INFORMATION13 ,
  PER_INFORMATION14 ,
  PER_INFORMATION15 ,
  PER_INFORMATION16 ,
  PER_INFORMATION17 ,
  PER_INFORMATION18 ,
  PER_INFORMATION19 ,
  PER_INFORMATION20 ,
  PER_INFORMATION21 ,
  PER_INFORMATION22 ,
  PER_INFORMATION23 ,
  PER_INFORMATION24 ,
  PER_INFORMATION25 ,
  PER_INFORMATION26 ,
  PER_INFORMATION27 ,
  PER_INFORMATION28 ,
  PER_INFORMATION29 ,
  PER_INFORMATION30 ,
  OBJECT_VERSION_NUMBER ,
  DATE_OF_DEATH ,
  SUFFIX ,
  WORK_SCHEDULE ,
  CORRESPONDENCE_LANGUAGE ,
  STUDENT_STATUS ,
  FTE_CAPACITY ,
  ON_MILITARY_SERVICE ,
  SECOND_PASSPORT_EXISTS ,
  BACKGROUND_CHECK_STATUS ,
  BACKGROUND_DATE_CHECK ,
  BLOOD_TYPE ,
  LAST_MEDICAL_TEST_DATE ,
  LAST_MEDICAL_TEST_BY ,
  REHIRE_RECOMMENDATION ,
  REHIRE_AUTHORIZOR ,
  REHIRE_REASON ,
  RESUME_EXISTS ,
  RESUME_LAST_UPDATED ,
  OFFICE_NUMBER ,
  INTERNAL_LOCATION ,
  MAILSTOP ,
  PROJECTED_START_DATE ,
  HONORS ,
  PRE_NAME_ADJUNCT ,
  HOLD_APPLICANT_DATE_UNTIL ,
  COORD_BEN_MED_PLN_NO ,
  COORD_BEN_NO_CVG_FLAG ,
  DPDNT_ADOPTION_DATE ,
  DPDNT_VLNTRY_SVCE_FLAG ,
  RECEIPT_OF_DEATH_CERT_DATE ,
  USES_TOBACCO_FLAG ,
  BENEFIT_GROUP_ID ,
  ORIGINAL_DATE_OF_HIRE ,
  TOWN_OF_BIRTH ,
  REGION_OF_BIRTH ,
  COUNTRY_OF_BIRTH ,
  GLOBAL_PERSON_ID ,
  PARTY_ID ,
  COORD_BEN_MED_EXT_ER ,
  COORD_BEN_MED_PL_NAME ,
  COORD_BEN_MED_INSR_CRR_NAME ,
  COORD_BEN_MED_INSR_CRR_IDENT ,
  COORD_BEN_MED_CVG_STRT_DT ,
  COORD_BEN_MED_CVG_END_DT ,
  NPW_NUMBER ,
  CURRENT_NPW_FLAG ,
  GLOBAL_NAME ,
  LOCAL_NAME ,
  hr_person_name.get_list_name(global_name, local_name) LIST_NAME
FROM PER_ALL_PEOPLE_F PAP
WHERE DECODE(HR_SECURITY.VIEW_ALL ,'Y' , 'TRUE'
               , HR_SECURITY.SHOW_PERSON ( pap.person_id
                                         , pap.current_applicant_flag 
                                         ,pap.current_employee_Flag
                                         , pap.current_npw_flag 
                                         ,pap.employee_number
                                         , pap.applicant_number
                                         , pap.npw_number)) = 'TRUE'
AND DECODE(hr_general.get_xbg_profile,'Y',pap.business_group_id , hr_general.get_business_group_id)        = pap.business_group_id
/


--PER_PERIODS_OF_SERVICE
select person_id from PER_PERIODS_OF_SERVICE group by person_id having count(*) > 1;
select * 
FRom PER_PERIODS_OF_SERVICE 
where person_id in (55, 425, 792, 795, 2569, 28778) 
order by person_id, date_start;
--> the FA view logic does not look correct!

--> We can just use PER_ALL_PEOPLE_F and skip termination date