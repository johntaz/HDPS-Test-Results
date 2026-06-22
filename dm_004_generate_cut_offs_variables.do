/*==============================================================================
FILE NAME:				dm_004_generate_cut_offs_variables
AUTHOR:					John Tazare
DESCRIPTION OF FILE:	Generate cut-off variables based on therapeutic ranges
*=============================================================================*/

foreach v in lld_COPD {


	forvalues i = 1/2 {
	
use "$datadir/derived/hd_ps_cohort_`v'_test", replace
merge 1:1 patid using "$datadir/derived/ppi_h2ra_cohort", keepusing(age female) 
drop _merge

* Blood pressure
merge 1:1 patid using "$derived/resultsDBP_`i'" 
summ dbp
gen dbpNorm = 1 if dbp<90 
replace dbpNorm = 0 if dbpNorm==.
drop _merge

merge 1:1 patid using "$derived/resultsSBP_`i'" 
summ sbp
gen sbpNorm = 1 if sbp<=140 & age <80 
replace sbpNorm = 1 if sbp<=150 & age >=80
replace sbpNorm = 0 if sbpNorm==.
drop _merge


* Calcium
merge 1:1 patid using "$derived/resultsCalcium_`i'"
summ calcium 
gen calciumNorm = 1 if calcium>=2.15 & calcium<=2.65 
replace calciumNorm = 0 if calciumNorm==.
gen calciumLow = 1 if calcium<2.15 
replace calciumLow = 0 if calciumLow==.
gen calciumHigh = 1 if calcium>2.65 & calcium!=. 
replace calciumHigh = 0 if calciumHigh==.
drop _merge

merge 1:1 patid using "$derived/resultsCalcium Adjusted_`i'" 
summ calciumadjusted
gen calciumadjustedNorm = 1 if calciumadjusted>=2.20 & calciumadjusted<=2.60
replace calciumadjustedNorm = 0 if calciumadjustedNorm==.
gen calciumadjustedLow = 1 if calciumadjusted<2.20 
replace calciumadjustedLow = 0 if calciumadjustedLow==.
gen calciumadjustedHigh = 1 if calciumadjusted>2.60 & calciumadjusted!=. 
replace calciumadjustedHigh = 0 if calciumadjustedHigh==.
drop _merge

* Full blood count
merge 1:1 patid using "$derived/resultsBasophil_`i'" 
summ basophil
gen basophilNorm = 1 if basophil<=0.1 
replace basophilNorm = 0 if basophilNorm==.
drop _merge

merge 1:1 patid using "$derived/resultsEosinophil_`i'" 
summ eosinophil
gen eosinophilNorm = 1 if eosinophil<=0.4 
replace eosinophilNorm = 0 if eosinophilNorm==.
drop _merge


merge 1:1 patid using "$derived/resultsHaemoglobin_`i'" 
summ haemoglobin
gen haemoglobinNorm = 1 if haemoglobin>=13.5 & haemoglobin<=18.0 & female==0
replace haemoglobinNorm = 1 if haemoglobin>=11.5 & haemoglobin<=16.0 & female==1
replace haemoglobinNorm = 0 if haemoglobinNorm==.
gen haemoglobinLow = 1 if haemoglobin< 13.5 & female==0
replace haemoglobinLow = 1 if haemoglobin< 11.5 & female==1
replace haemoglobinLow = 0 if haemoglobinLow==.
gen haemoglobinHigh = 1 if haemoglobin> 18.0 & haemoglobin!=. & female==0
replace haemoglobinHigh = 1 if haemoglobin> 16.0 & haemoglobin!=. & female==1
replace haemoglobinHigh = 0 if haemoglobinHigh==.
drop _merge

merge 1:1 patid using "$derived/resultsLymphocyte_`i'" 
summ lymphocyte
gen lymphocyteNorm = 1 if lymphocyte>=1 & lymphocyte<=4.8
replace lymphocyteNorm = 0 if lymphocyteNorm==.
gen lymphocyteLow = 1 if lymphocyte< 1
replace lymphocyteLow = 0 if lymphocyteLow==.
gen lymphocyteHigh = 1 if lymphocyte> 4.8 & lymphocyte!=. 
replace lymphocyteHigh = 0 if lymphocyteHigh==.
drop _merge

merge 1:1 patid using "$derived/resultsMonocytes_`i'" 
summ monocytes
gen monocytesNorm = 1 if monocytes>=0.2 & monocytes<=0.8
replace monocytesNorm = 0 if monocytesNorm==.
gen monocytesLow = 1 if monocytes< 0.2
replace monocytesLow = 0 if monocytesLow==.
gen monocytesHigh = 1 if monocytes> 0.8 & monocytes!=. 
replace monocytesHigh = 0 if monocytesHigh==.
drop _merge


merge 1:1 patid using "$derived/resultsMCV_`i'" 
summ mcv
gen mcvNorm = 1 if mcv>=80 & mcv<=100
replace mcvNorm = 0 if mcvNorm==.
gen mcvLow = 1 if mcv< 80
replace mcvLow = 0 if mcvLow==.
gen mcvHigh = 1 if mcv> 120 & mcv!=. 
replace mcvHigh = 0 if mcvHigh==.
drop _merge

merge 1:1 patid using "$derived/resultsMCH_`i'" 
summ mch
gen mchNorm = 1 if mch>=27 & mch<=34
replace mchNorm = 0 if mchNorm==.
gen mchLow = 1 if mch< 27
replace mchLow = 0 if mchLow==.
gen mchHigh = 1 if mch> 34 & mch!=. 
replace mchHigh = 0 if mchHigh==.
drop _merge


merge 1:1 patid using "$derived/resultsPlatelets_`i'" 
summ platelets
gen plateletsNorm = 1 if platelets>=130 & platelets<=400
replace plateletsNorm = 0 if plateletsNorm==.
gen plateletsLow = 1 if platelets< 130
replace plateletsLow = 0 if plateletsLow==.
gen plateletsHigh = 1 if platelets> 400 & platelets!=. 
replace plateletsHigh = 0 if plateletsHigh==.
drop _merge

merge 1:1 patid using "$derived/resultsRBC_`i'" 
summ rbc
gen rbcNorm = 1 if rbc>=4.5 & rbc<=6.0 & female==0
replace rbcNorm = 1 if rbc>=4.0 & rbc<=5.6 & female==1
replace rbcNorm = 0 if rbcNorm==.
gen rbcLow = 1 if rbc< 4.5 & female==0
replace rbcLow = 1 if rbc< 4.0 & female==1
replace rbcLow = 0 if rbcLow==.
gen rbcHigh = 1 if rbc> 6.0 & rbc!=. & female==0
replace rbcHigh = 1 if rbc> 5.6 & rbc!=. & female==1
replace rbcHigh = 0 if rbcHigh==.
drop _merge

merge 1:1 patid using "$derived/resultsWBC_`i'" 
summ wbc
gen wbcNorm = 1 if wbc>=4 & wbc<=11
replace wbcNorm = 0 if wbcNorm==.
gen wbcLow = 1 if wbc< 4
replace wbcLow = 0 if wbcLow==.
gen wbcHigh = 1 if wbc> 11 & wbc!=. 
replace wbcHigh = 0 if wbcHigh==.
drop _merge



* Glucose
merge 1:1 patid using "$derived/resultsGlucose_`i'" 
summ glucose
gen glucoseNorm = 1 if glucose>=3.3 & glucose<=6.1
replace glucoseNorm = 0 if glucoseNorm==.
gen glucoseLow = 1 if glucose< 3.3
replace glucoseLow = 0 if glucoseLow==.
gen glucoseHigh = 1 if glucose> 6.1 & glucose!=. 
replace glucoseHigh = 0 if glucoseHigh==.
drop _merge

merge 1:1 patid using "$derived/resultsGlucosefasting_`i'" 
summ glucosefasting
gen glucosefastingNorm = 1 if glucosefasting>=3.3 & glucosefasting<=6.1
replace glucosefastingNorm = 0 if glucosefastingNorm==.
gen glucosefastingLow = 1 if glucosefasting< 3.3
replace glucosefastingLow = 0 if glucosefastingLow==.
gen glucosefastingHigh = 1 if glucosefasting> 6.1 & glucosefasting!=. 
replace glucosefastingHigh = 0 if glucosefastingHigh==.
drop _merge

* Lipids
merge 1:1 patid using "$derived/resultsCholesterol_`i'" 
summ cholesterol
gen cholesterolNorm = 1 if cholesterol<=5 
replace cholesterolNorm = 0 if cholesterolNorm==.
drop _merge

merge 1:1 patid using "$derived/resultsHDL_`i'" 
summ hdl
gen hdlNorm = 1 if hdl>=1
replace hdlNorm = 0 if hdlNorm==.
drop _merge

merge 1:1 patid using "$derived/resultsLDL_`i'" 
summ ldl
gen ldlNorm = 1 if ldl<=3 
replace ldlNorm = 0 if ldlNorm==.
drop _merge


merge 1:1 patid using "$derived/resultsTriglycerides_`i'" 
summ triglycerides
gen triglyceridesNorm = 1 if triglycerides>=0.85 & triglycerides<=2.0
replace triglyceridesNorm = 0 if triglyceridesNorm==.
gen triglyceridesLow = 1 if triglycerides< 0.85
replace triglyceridesLow = 0 if triglyceridesLow==.
gen triglyceridesHigh = 1 if triglycerides> 2.0 & triglycerides!=. 
replace triglyceridesHigh = 0 if triglyceridesHigh==.
drop _merge


* Liver function tests

merge 1:1 patid using "$derived/resultsAlbumin_`i'" 
summ albumin
gen albuminNorm = 1 if albumin>=38 & albumin<=50 
replace albuminNorm = 0 if albuminNorm==.
gen albuminLow = 1 if albumin<38 
replace albuminLow = 0 if albuminLow==.
gen albuminHigh = 1 if albumin>50 & albumin!=. 
replace albuminHigh = 0 if albuminHigh==.
drop _merge

merge 1:1 patid using "$derived/resultsAST_`i'" 
summ ast
gen astNorm = 1 if ast>=15 & ast<=42
replace astNorm = 0 if astNorm==.
gen astLow = 1 if ast<15 
replace astLow = 0 if astLow==.
gen astHigh = 1 if ast>42 & ast!=. 
replace astHigh = 0 if astHigh==.
drop _merge

merge 1:1 patid using "$derived/resultsALT_`i'" 
summ alt
gen altNorm = 1 if alt<=40
replace altNorm = 0 if altNorm==.
drop _merge


merge 1:1 patid using "$derived/resultsALP_`i'" 
summ alp
gen alpNorm = 1 if alp>=35 & alp<=115 & age <60
replace alpNorm = 1 if alp>=35 & alp<=150 & age >=60
replace alpNorm = 0 if alpNorm==.
gen alpLow = 1 if alp< 35 & age < 60
replace alpLow = 1 if alp< 35 & age >=60
replace alpLow = 0 if alpLow==.
gen alpHigh = 1 if alp> 115 & alp!=. & age <60
replace alpHigh = 1 if alp> 150 & alp!=. & age >=60
replace alpHigh = 0 if alpHigh==.
drop _merge

merge 1:1 patid using "$derived/resultsAKP_`i'" 
summ akp
gen akpNorm = 1 if akp>=35 & akp<=115 & age <60
replace akpNorm = 1 if akp>=35 & akp<=150 & age >=60
replace akpNorm = 0 if akpNorm==.
gen akpLow = 1 if akp< 35 & age < 60
replace akpLow = 1 if akp< 35 & age >=60
replace akpLow = 0 if akpLow==.
gen akpHigh = 1 if akp> 115 & akp!=. & age <60
replace akpHigh = 1 if akp> 150 & akp!=. & age >=60
replace akpHigh = 0 if akpHigh==.
drop _merge


merge 1:1 patid using "$derived/resultsBilirubin_`i'" 
summ bilirubin
gen bilirubinNorm = 1 if bilirubin>=2 & bilirubin<=20
replace bilirubinNorm = 0 if bilirubinNorm==.
gen bilirubinLow = 1 if bilirubin<2 
replace bilirubinLow = 0 if bilirubinLow==.
gen bilirubinHigh = 1 if bilirubin>20 & bilirubin!=. 
replace bilirubinHigh = 0 if bilirubinHigh==.
drop _merge


* Urea and electrolytes
merge 1:1 patid using "$derived/resultsCreatinine_`i'" 
summ creatinine
gen creatinineNorm = 1 if creatinine>=20 & creatinine<=120 & age <60
replace creatinineNorm = 1 if creatinine>=70 & creatinine<=140 & age >=60
replace creatinineNorm = 0 if creatinineNorm==.
gen creatinineLow = 1 if creatinine< 20 & age < 60
replace creatinineLow = 1 if creatinine< 70 & age >=60
replace creatinineLow = 0 if creatinineLow==.
gen creatinineHigh = 1 if creatinine> 120 & creatinine!=. & age <60
replace creatinineHigh = 1 if creatinine> 140 & creatinine!=. & age >=60
replace creatinineHigh = 0 if creatinineHigh==.
drop _merge

merge 1:1 patid using "$derived/resultsPotassium_`i'" 
summ potassium
gen potassiumNorm = 1 if potassium>=3.6 & potassium<=5.4
replace potassiumNorm = 0 if potassiumNorm==.
gen potassiumLow = 1 if potassium< 3.6
replace potassiumLow = 0 if potassiumLow==.
gen potassiumHigh = 1 if potassium> 5.4 & potassium!=. 
replace potassiumHigh = 0 if potassiumHigh==.
drop _merge

merge 1:1 patid using "$derived/resultsSodium_`i'"
summ sodium 
gen sodiumNorm = 1 if sodium>=134 & sodium<=144
replace sodiumNorm = 0 if sodiumNorm==.
gen sodiumLow = 1 if sodium< 134
replace sodiumLow = 0 if sodiumLow==.
gen sodiumHigh = 1 if sodium> 144 & sodium!=. 
replace sodiumHigh = 0 if sodiumHigh==.
drop _merge

merge 1:1 patid using "$derived/resultsUrea_`i'" 
summ urea
gen ureaNorm = 1 if urea>=3 & urea<=8.5 & age <60
replace ureaNorm = 1 if urea>=3 & urea<=10 & age >=60
replace ureaNorm = 0 if ureaNorm==.
gen ureaLow = 1 if urea< 3 & age < 60
replace ureaLow = 1 if urea< 3 & age >=60
replace ureaLow = 0 if ureaLow==.
gen ureaHigh = 1 if urea> 8.5 & urea!=. & age <60
replace ureaHigh = 1 if urea> 10 & urea!=. & age >=60
replace ureaHigh = 0 if ureaHigh==.
drop _merge

merge 1:1 patid using "$derived/resultsGFR_`i'" 
summ gfr
gen gfrNorm = 1 if gfr>=60
replace gfrNorm = 0 if gfrNorm==.
drop _merge

* Other
merge 1:1 patid using "$derived/resultsCRP_`i'" 
summ crp
gen crpNorm = 1 if crp<5 
replace crpNorm = 0 if crpNorm==.
drop _merge


merge 1:1 patid using "$derived/resultsHbA1c_`i'" 
summ hba1c
gen hba1cNorm = 1 if hba1c<=60
replace hba1cNorm = 0 if hba1cNorm==.
drop _merge

merge 1:1 patid using "$derived/resultstotalprot_`i'" 
summ totalprot
gen totalprotNorm = 1 if totalprot>=60 & totalprot<=80
replace totalprotNorm = 0 if totalprotNorm==.
gen totalprotLow = 1 if totalprot< 60
replace totalprotLow = 0 if totalprotLow==.
gen totalprotHigh = 1 if totalprot> 80 & totalprot!=. 
replace totalprotHigh = 0 if totalprotHigh==.
drop _merge

merge 1:1 patid using "$derived/resultsUrate_`i'" 
summ urate
gen urateNorm = 1 if urate>=0.12 & urate<=0.42 & female==0
replace urateNorm = 1 if urate>=0.12 & urate<=0.38 & female==1
replace urateNorm = 0 if urateNorm==.
gen urateLow = 1 if urate< 0.12 & female==0
replace urateLow = 1 if urate< 0.12 & female==1
replace urateLow = 0 if urateLow==.
gen urateHigh = 1 if urate> 0.42 & urate!=. & female==0
replace urateHigh = 1 if urate> 0.38 & urate!=. & female==1
replace urateHigh = 0 if urateHigh==.
drop _merge

****************** Ranking
* Remove non-cut-off variables from HDPS ranking
drop age female calcium calciumadjusted basophil eosinophil haemoglobin lymphocyte monocytes mcv  /// 
mch platelets rbc wbc glucose glucosefasting cholesterol hdl ldl triglycerides albumin ///
ast alt alp akp bilirubin creatinine potassium sodium urea gfr crp hba1c totalprot urate sbp dbp

ds patid ppi_exposure 
di as txt "Ranking confounders by potential for causing bias"
tempname bias_1 

ds patid ppi_exposure `v' , not
local treatment ppi_exposure
local outcome `v'

postfile `bias_1' str30(code_id) e1 e0 c1 c0 e1c1 e0c1 e1c0 e0c0 d1c1 d1c0 d0c1 d0c0 using "$derived/bias_info_testResults_`outcome'_`i'.dta", replace

quietly {

	foreach t of varlist `r(varlist)' {
   
   count if `t'==1
   local c1=`r(N)'
   
   count if `v'==0
   local c0=`r(N)'
   
   count if `treatment'==1
   local e1=`r(N)' 
   
   count if `treatment'==0
   local e0=`r(N)' 
   
   count if `treatment'==1 & `t'==1
   local e1c1=`r(N)'
   
   count if `treatment'==0 & `t'==1
   local e0c1=`r(N)'
   
    count if `treatment'==1 & `t'==0
   local e1c0=`r(N)'
   
   count if `treatment'==0 & `t'==0
   local e0c0=`r(N)'

   count if `outcome'==1 & `t'==1
   local d1c1=`r(N)'

   count if `outcome'==1 & `t'==0
   local d1c0=`r(N)'
   
   count if `outcome'==0 & `t'==1
   local d0c1=`r(N)'

   count if `outcome'==0 & `t'==0
   local d0c0=`r(N)'


		
		post `bias_1' ("`t'") (`e1') (`e0') (`c1') (`c0')  (`e1c1') (`e0c1') (`e1c0') (`e0c0') (`d1c1') (`d1c0') (`d0c1') (`d0c0')

	}
}
postclose `bias_1'          



*=============================================================================
* Analysis
*=============================================================================

* Results
tempname john 
postfile `john' str30(outcome) str20(bias) float(no_of_vars hr ll ul) using "$derived/results_testResults_`outcome'_`i'", replace 

local cohort  ppi_h2ra_cohort
local patid patid 

* For each of the Bross and Outcome Strength

foreach num of numlist 100 250 500 750 900 {

local no_overall `num' 

*=============================================================================
* 7. Pick top k codes - create final analysis dataset
*=============================================================================
preserve 

di as txt "Selecting top `no_overall' confounders"
use "$derived/bias_info_testResults_`outcome'_`i'.dta", replace
gen pc1=e1c1/e1
gen pc0=e0c1/e0
gen rr_ce=pc1/pc0
replace rr_ce=. if rr_ce==0
gen rr_cd=(d1c1/c1)/(d1c0/c0)
replace rr_cd=. if rr_cd==0
gen bias=(pc1*(rr_cd-1)+1)/(pc0*(rr_cd-1)+1)
gen abs_log_bias=abs(log(bias))
gen ce_strength=abs(rr_ce-1)
gen cd_strength=abs(rr_cd-1)
gsort- abs_log_bias
gen rank=_n
keep if rank<=`no_overall'

qui levelsof code_id, local(final_selection)

restore 

preserve 
foreach k of local final_selection {
rename `k' y_`k'
}
keep `patid' y*
foreach l of local final_selection {
rename y_`l' __`l' 
}
tempfile final
save `final', replace 
*

use "$datadir/derived/ppi_h2ra_cohort", replace 
merge 1:1 `patid' using `final' 
drop _merge

*=============================================================================
* 8. Analysis
*=============================================================================
global vars "nsaid_6m aspirin_6m clopidogrel_6m oac_6m inhaled_steroid_6m sys_steroid_6m upper_GI_endoscopy_6m"
global vars = "$vars" + " gastric_cancer_6m GERD_6m peptic_ulcer_6m upper_GI_bleed_6m"
global vars = "$vars" + " pancreatitis_6m oesophagitis_6m barretts_6m hpylori_infect_6m hypertension CHD" 
global vars = "$vars" + " heart_fail other_athero PVD CVD COPD cancer HIV CKD dementia diabetes"
global vars = "$vars" + " female i.new_alcstatus i.new_alclevel i.new_smokstatus c.age_p* bmi_mi c.bmi_p*"
global vars = "$vars" + " nonviral_liver cirrhosis_6m i.imd i.n_admission_6m_cat i.GP_app_6m_cat i.n_bnfchapters_6m_cat"

set more off
set matsize 1500

recode calendar_year (1998/2003=0 "1998-2003") (2004/2009=1 "2004-2009") (2010/2015=2 "2010-2015"), gen(calendar_year_cat) label(yearcat_lbl)
keep if newcohort != 2 // keep PPI/H2RA users (drop non-users)
keep if imd !=. //
assert _N == 858295
mkspline age_p = age, cubic knots(20 40 60 70 80)
mkspline bmi_p=bmi, cubic nknots(5)
gen bmi_mi = bmi==.
foreach var of varlist bmi_p* {
	replace `var' = 0 if `var'==. // redefine bmi so that zero is categorised as missing
}

assert alclevel!=.
assert alcstatus!=.
assert smokstatus !=.
rename alclevel new_alclevel
rename alcstatus new_alcstatus
rename smokstatus new_smokstatus

logistic ppi_exposure (${vars})##i.calendar_year_cat __*
assert e(N)==858295 & e(converged)==1
predict propensity

gen att_weight = ppi_exposure + (1-ppi_exposure)*(propensity/(1-propensity))

stset end_fu [pweight=att_weight], failure(`outcome') origin(indexdate) enter(indexdate) scale(365.25) id(patid)
stcox ppi_exposure,  vce(robust)


mat b =r(table)
mat list b
local hr = b[1,1]
local ll = b[5,1]
local ul = b[6,1]


post `john' ("`outcome'") ("abs_log_bias") (`no_overall') (`hr') (`ll') (`ul') 

keep patid propensity ppi_exposure 
save "$derived/pscores_testResults_`outcome'_`i'", replace


restore
}



postclose `john'   
}

}



  
