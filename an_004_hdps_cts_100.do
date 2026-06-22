/*==============================================================================
FILE NAME:				an_003_hdps_cut_offs
AUTHOR:					John Tazare
DESCRIPTION OF FILE:	Run test-requested + test cut-offs + continuous test
						 values HDPS analysis 
*=============================================================================*/

use "$datadir/derived/ppi_h2ra_cohort", replace 

* Results
tempname john 
postfile `john' str30(outcome) str20(bias) float(no_of_vars hr ll ul) using "$projectdir/data/testResults_hdps_cts", replace 


*=============================================================================
* Re-do HDPS ranking
*=============================================================================

di as txt "Selecting top `no_overall' confounders"
use "$projectdir/reviewercomments-2026/data/bias_info_all.dta", replace
drop if c1==0 // this drops two test results mistakenly included
gen dim = substr(code_id, 1,2)
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

foreach num of numlist 100 250 500 750  {
preserve
local no_overall `num' 
qui levelsof code_id if rank < `no_overall' , local(final_selection_`no_overall')

* Identify test results in top 100
replace dim = "test" if dim!="d1" & dim!="d2" & dim!="d3" & dim!="d4"

gen code_id2 = code_id
replace code_id2 = code_id + "a" if strpos(code_id, "Low") > 0

gen testRest = substr(code_id2, 1, strlen(code_id2) - 4) if dim=="test"
levelsof testRest if rank<=100, local(tests_`no_overall') 
restore
}


use "$projectdir/data/hdps_covariates.dta", replace

foreach num of numlist 100 250 500 750  {
	
local no_overall `num' 	
	
preserve 

foreach t of local tests_`no_overall' {
rename `t' testRes_`t'

* missing indicator
gen testRes_`t'_mi = testRes_`t'==.

foreach var of varlist testRes_`p'* {
replace `var' = -999 if `var' ==. 
}
}

foreach k of local final_selection_`no_overall' {
rename `k' y_`k'
}
keep patid y* testRes_*
foreach l of local final_selection_`no_overall' {
rename y_`l' __`l' 
}
tempfile final
save `final', replace 
*
use "$datadir/derived/ppi_h2ra_cohort", replace 
merge 1:1 patid using `final' 
drop _merge

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
keep if imd !=. 
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

logistic ppi_exposure (${vars})##i.calendar_year_cat __* testRes_*
assert e(N)==858295 & e(converged)==1
predict propensity

gen att_weight = ppi_exposure + (1-ppi_exposure)*(propensity/(1-propensity))

stset end_fu [pweight=att_weight], failure(lld_COPD) origin(indexdate) enter(indexdate) scale(365.25) id(patid)
stcox ppi_exposure,  vce(robust)


mat b =r(table)
mat list b
local hr = b[1,1]
local ll = b[5,1]
local ul = b[6,1]


post `john' ("lld_COPD") ("abs_log_bias") (`no_overall') (`hr') (`ll') (`ul') 

keep patid propensity ppi_exposure 
save "$projectdir/data/pscores/pscores_cts100_`no_overall'.dta", replace

restore
}
postclose `john'  


