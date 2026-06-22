/*==============================================================================
FILE NAME:				dm_003_test_value_transcoding
AUTHOR:					John Tazare
DESCRIPTION OF FILE:	Applies cleaning rules to all test results and compares
						distribution before/after
*=============================================================================*/

* Do-file options
local debugMode 0 // 1 = Yes , 0 = No
local output 1 // 1 = Yes produce a pdf, 0 = Don't

* Set up pdf output
if `output'==1 {
* PDF
capture putpdf clear
putpdf begin

* Create title 
putpdf paragraph, halign(center)
putpdf text ("Test results in the year prior to index"), bold
}

* Total number of patients in cohort
local popn = 858295

* Loop over all relevant 1 and 2 year baselines windows 
foreach v of numlist 1  2  {

use "$derived/relevantTestResults_`v'Year", replace
local window `v'


tempname denom`window'
postfile `denom`window'' str50(test) float(cleaned patientPropn) using "$derived/testSummary_`window'blahblah.dta", replace

* Grab sample for testing code
if `debugMode' == 1 {
keep if _n < 10000
}

*****************************************************************************
* Calcium
*****************************************************************************
******* Calcium 
local test calcium
local lbl = upper(substr(`"`test'"', 1, 1)) + substr(`"`test'"', 2, .)
* Select relevant results
preserve 
keep if enttype == 159 

* Replace unitMeasurement 
replace unitMeasurement = "mmol/L" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "mmol/L" measurements 
keep if unitMeasurement == "mmol/L" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw")
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
local cleaned 1 
keep if data2 < 5 & data2 > 0

* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count 
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', .01)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)
* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak

}

restore

******* Calcium adjusted
local test calciumadjusted
local lbl = "Calcium Adjusted"
* Select relevant results
preserve 
keep if enttype == 160 

* Replace unitMeasurement 
replace unitMeasurement = "mmol/L" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "mmol/L" measurements 
keep if unitMeasurement == "mmol/L" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 5 & data2 > 0
local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak

}

restore

*****************************************************************************
* Full blood count (FBC)
*****************************************************************************
******* Basophil
local test basophil
local lbl = upper(substr(`"`test'"', 1, 1)) + substr(`"`test'"', 2, .)
* Select relevant results
preserve 
keep if enttype == 313

* Replace unitMeasurement 
replace unitMeasurement = "10*9/L" if unitMeasurement == "10*9"
replace unitMeasurement = "10*9/L" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "10*9/L" measurements 
keep if unitMeasurement == "10*9/L"


* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

local cleaned 1 
* Clean up
keep if data2 < 1 & data2 > 0

* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


******* Eosinophil
local test eosinophil
local lbl = upper(substr(`"`test'"', 1, 1)) + substr(`"`test'"', 2, .)
* Select relevant results
preserve 
keep if enttype == 168

* Replace unitMeasurement 
replace unitMeasurement = "10*9/L" if unitsCode == 0
replace unitMeasurement = "10*9/L" if  unitMeasurement == "10*9"
replace unitMeasurement = "10*9/L" if  unitMeasurement == "/L"

tab unitMeasurement

* Only keep patients with "10*9/L" measurements 
keep if unitMeasurement == "10*9/L" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 6 & data2 > 0
local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore

******* Haemoglobin
local test haemoglobin
local lbl = upper(substr(`"`test'"', 1, 1)) + substr(`"`test'"', 2, .)
* Select relevant results
preserve 
keep if enttype == 173

* Replace unitMeasurement 
replace data2 = data2/10 if unitMeasurement == "g/dL"
replace unitMeasurement = "g/dL" if  unitMeasurement == "g/L"
replace data2 = data2/10 if  data2>50
replace unitMeasurement = "g/dL" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "g/dL" measurements 
keep if unitMeasurement == "g/dL" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 35 & data2 > 0
local cleaned 1 

* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest
* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


******* Lymphocyte
local test lymphocyte
local lbl = upper(substr(`"`test'"', 1, 1)) + substr(`"`test'"', 2, .)
* Select relevant results
preserve 
keep if enttype == 208

* Replace unitMeasurement 
replace unitMeasurement = "10*9/L" if unitMeasurement == "/L"
replace unitMeasurement = "10*9/L" if  unitMeasurement == "10*9"
replace unitMeasurement = "10*9/L" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "10*9/L" measurements 
keep if unitMeasurement == "10*9/L" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 20 & data2 > 0
local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


******* Monocytes
local test monocytes
local lbl = upper(substr(`"`test'"', 1, 1)) + substr(`"`test'"', 2, .)
* Select relevant results
preserve 
keep if enttype == 183

* Replace unitMeasurement 
replace unitMeasurement = "10*9/L" if unitsCode == 0
replace unitMeasurement = "10*9/L" if unitMeasurement == "10*9"

tab unitMeasurement

* Only keep patients with "10*9/L" measurements 
keep if unitMeasurement == "10*9/L" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 15 & data2 > 0
local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore

******* mcv
local test mcv
local lbl = "MCV"
* Select relevant results
preserve 
keep if enttype == 182

* Replace unitMeasurement 
replace unitMeasurement = "fL" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "fL" measurements 
keep if unitMeasurement == "fL"

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 200 & data2 > 0
local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


******* mch
local test mch
local lbl = "MCH"
* Select relevant results
preserve 
keep if enttype == 180

* Replace unitMeasurement
replace unitMeasurement = "pg" if unitsCode == 0
replace unitMeasurement = "pg" if unitMeasurement == "pg/mL"
 
tab unitMeasurement

* Only keep patients with "pg" measurements 
keep if unitMeasurement == "pg"

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

local cleaned 0 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


******* Platelets
local test platelets
local lbl = upper(substr(`"`test'"', 1, 1)) + substr(`"`test'"', 2, .)
* Select relevant results
preserve 
keep if enttype == 189


* Replace unitMeasurement 
replace unitMeasurement = "10*9/L" if unitMeasurement == "/L"
replace unitMeasurement = "10*9/L" if  unitMeasurement == "10*9"
replace unitMeasurement = "10*9/L" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "10*9/L" measurements 
keep if unitMeasurement == "10*9/L" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)


* Clean up
keep if data2 < 1200 & data2 > 0

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore



******* rbc
local test rbc
local lbl = "RBC"
* Select relevant results
preserve 
keep if enttype == 194

* Replace unitMeasurement 
replace unitMeasurement = "mg/L" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "mg/L" measurements 
keep if unitMeasurement == "mg/L" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 100 & data2 > 0

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


******* WBC
local test wbc
local lbl = "WBC"
* Select relevant results
preserve 
keep if enttype == 207

* Replace unitMeasurement 
replace unitMeasurement = "10*9/L" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "10*9/L" measurements 
keep if unitMeasurement == "10*9/L" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 150 & data2 > 0

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


*******************************************************************************
* Glucose
*******************************************************************************

******* Glucose
local test glucose
local lbl = upper(substr(`"`test'"', 1, 1)) + substr(`"`test'"', 2, .)
* Select relevant results
preserve 
keep if enttype == 213

* Replace unitMeasurement 
replace unitMeasurement = "mmol/L" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "mmol/L" measurements 
keep if unitMeasurement == "mmol/L" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 40 & data2 > 0

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


******* Glucose Fasting
local test glucosefasting
local lbl = upper(substr(`"`test'"', 1, 1)) + substr(`"`test'"', 2, .)
* Select relevant results
preserve 
keep if enttype == 274

* Replace unitMeasurement 
replace unitMeasurement = "mmol/L" if unitMeasurement == "IU/L"
replace unitMeasurement = "mmol/L" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "mmol/L" measurements 
keep if unitMeasurement == "mmol/L" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)
* Clean up
keep if data2 < 40 & data2 > 0

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore

******************************************************************************
* Lipids
*****************************************************************************


******* Cholesterol
local test cholesterol
local lbl = upper(substr(`"`test'"', 1, 1)) + substr(`"`test'"', 2, .)
* Select relevant results
preserve 
keep if enttype == 163

* Replace unitMeasurement 
replace unitMeasurement = "mmol/L" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "mmol/L" measurements 
keep if unitMeasurement == "mmol/L" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 15 & data2 > 0

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


******* hdl
local test hdl
local lbl = "HDL"
* Select relevant results
preserve
keep if enttype == 175

* Replace unitMeasurement
replace unitMeasurement = "mmol/L" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "mmol/L" measurements 
keep if unitMeasurement == "mmol/L"

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 20 & data2 > 0

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


******* ldl
local test ldl
local lbl = "LDL"
* Select relevant results
preserve
keep if enttype == 177

* Replace unitMeasurement
replace unitMeasurement = "mmol/L" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "mmol/L" measurements 
keep if unitMeasurement == "mmol/L"

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 20 & data2 > 0

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


******* Triglycerides
local test triglycerides
local lbl = upper(substr(`"`test'"', 1, 1)) + substr(`"`test'"', 2, .)
* Select relevant results
preserve 
keep if enttype == 202

* Replace unitMeasurement 
replace unitMeasurement = "mmol/L" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "mmol/L" measurements 
keep if unitMeasurement == "mmol/L" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 15 & data2 > 0

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore

******************************************************************************
* Liver Function Tests (LFTss)
******************************************************************************

******* Albumin 
local test albumin
local lbl = upper(substr(`"`test'"', 1, 1)) + substr(`"`test'"', 2, .)
* Select relevant results
preserve 
keep if enttype == 152 

* Replace unitMeasurement 
replace unitMeasurement = "g/L" if unitsCode == 0
tab unitMeasurement

* Only keep patients with "g/L" measurements 
keep if unitMeasurement == "g/L" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
local cleaned 1 
keep if data2 < 150 & data2 > 3

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


******* ast
local test ast
local lbl = "AST"
* Select relevant results
preserve
keep if enttype == 156

tab unitMeasurement

* Replace unitMeasurement
replace unitMeasurement = "IU/L" if unitMeasurement == "U/L"

tab unitMeasurement

* Only keep patients with "IU/L" measurements 
keep if unitMeasurement == "IU/L"

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 400 & data2 > 0

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


******* alt
local test alt
local lbl = "ALT"
* Select relevant results
preserve
keep if enttype == 155

* Replace unitMeasurement
replace unitMeasurement = "IU/L" if unitMeasurement == "U/L"

tab unitMeasurement

* Only keep patients with "IU/L" measurements 
keep if unitMeasurement == "IU/L"

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 400 & data2 > 0

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore



******* alp
local test alp
local lbl = "ALP"
* Select relevant results
preserve 
keep if enttype == 155

* Replace unitMeasurement
replace unitMeasurement = "U/L" if unitsCode == 0
replace unitMeasurement = "U/L" if unitMeasurement == "IU/L"
 
tab unitMeasurement

* Only keep patients with "U/L" measurements 
keep if unitMeasurement == "U/L"

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

local cleaned 0
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore



******* AKP
local test akp
local lbl = "AKP"
* Select relevant results
preserve 
keep if enttype == 153

* Replace unitMeasurement 
replace unitMeasurement = "IU/L" if unitMeasurement == "U/L"

tab unitMeasurement

* Only keep patients with "IU/L" measurements 
keep if unitMeasurement == "IU/L" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 500 & data2 > 0

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


******* Bilirubin
local test bilirubin
local lbl = upper(substr(`"`test'"', 1, 1)) + substr(`"`test'"', 2, .)
* Select relevant results
preserve 
keep if enttype == 158

* Replace unitMeasurement 
replace unitMeasurement = "umol/L" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "umol/L" measurements 
keep if unitMeasurement == "umol/L" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 200 & data2 > 0

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


*******************************************************************************
* Urea & electrolytes
*******************************************************************************

******* Creatinine
local test creatinine
local lbl = upper(substr(`"`test'"', 1, 1)) + substr(`"`test'"', 2, .)
* Select relevant results
preserve 
keep if enttype == 165

* Replace unitMeasurement 
replace unitMeasurement = "umol/L" if unitsCode == 0
replace unitMeasurement = "umol/L" if  unitMeasurement == "mol/L"
replace unitMeasurement = "umol/L" if  unitMeasurement == "mmol/L"

tab unitMeasurement

* Only keep patients with "umol/L" measurements 
keep if unitMeasurement == "umol/L" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 800 & data2 > 0

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


******* Potassium
local test potassium
local lbl = upper(substr(`"`test'"', 1, 1)) + substr(`"`test'"', 2, .)
* Select relevant results
preserve 
keep if enttype == 190

* Replace unitMeasurement 
replace unitMeasurement = "mmol/L" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "mmol/L" measurements 
keep if unitMeasurement == "mmol/L" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 20 & data2 > 0

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


******* Sodium
local test sodium
local lbl = upper(substr(`"`test'"', 1, 1)) + substr(`"`test'"', 2, .)
* Select relevant results
preserve 
keep if enttype == 196

* Replace unitMeasurement 
replace unitMeasurement = "mmol/L" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "mmol/L" measurements 
keep if unitMeasurement == "mmol/L" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 200 & data2 > 50

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


******* Urea
local test urea
local lbl = upper(substr(`"`test'"', 1, 1)) + substr(`"`test'"', 2, .)
* Select relevant results
preserve 
keep if enttype == 204

* Replace unitMeasurement 
replace unitMeasurement = "mmol/L" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "mmol/L" measurements 
keep if unitMeasurement == "mmol/L" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 100 & data2 > 0

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore

******* GFR
local test gfr
local lbl = "GFR"
* Select relevant results
preserve 
keep if enttype == 466

* Replace unitMeasurement 
replace unitMeasurement = "mL/min" if unitsCode == 0
replace unitMeasurement = "mL/min" if unitMeasurement == "/min"

tab unitMeasurement

* Only keep patients with "mL/min" measurements 
keep if unitMeasurement == "mL/min" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)


* Clean up
keep if data2 < 150 & data2 > 0

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore

******************************************************************************
* Other
******************************************************************************

******* CRP
local test crp
local lbl = "CRP"
* Select relevant results
preserve 
keep if enttype == 280

* Replace unitMeasurement 
replace unitMeasurement = "mg/L" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "mg/L" measurements 
keep if unitMeasurement == "mg/L" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)


* Clean up
keep if data2 < 300 & data2 > 0

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore



******* hba1c
local test hba1c
local lbl = "HbA1c"
* Select relevant results
preserve 
keep if enttype == 275

* Replace unitMeasurement 
replace data2 = (data2-2.15)*10.929 if unitMeasurement == "%"
replace data2 = (data2-2.15)*10.929 if unitsCode ==0 & data2 > 20
replace unitMeasurement = "mmol/mol" if unitMeasurement == "%"
replace unitMeasurement = "mmol/mol" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "mmol/mol" measurements 
keep if unitMeasurement == "mmol/mol" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 200 & data2 > 0

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


******* totalprot
local test totalprot
local lbl = "Total Protein"
* Select relevant results
preserve
keep if enttype == 201

* Replace unitMeasurement
replace unitMeasurement = "g/L" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "g/L" measurements 
keep if unitMeasurement == "g/L"

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)


local cleaned 0
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`test'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


******* Urate
local test urate
local lbl = upper(substr(`"`test'"', 1, 1)) + substr(`"`test'"', 2, .)
* Select relevant results
preserve 
keep if enttype == 277

* Replace unitMeasurement 
replace data2 = data2/1000 if unitMeasurement == "umol/L"
replace data2 = data2/1000 if unitsCode == 0 & data2 > 10
replace unitMeasurement = "mmol/mol" if unitMeasurement == "umol/L"
replace unitMeasurement = "mmol/mol" if unitsCode == 0

tab unitMeasurement

* Only keep patients with "mmol/mol" measurements 
keep if unitMeasurement == "mmol/mol" 

* Raw
twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Raw") 
graph export "$output/hist`lbl'Raw_`window'.png", replace width(400)

* Clean up
keep if data2 < 10 & data2 > 0

local cleaned 1 
* Identify most recent recording
sort patid recent
bysort patid: gen earliest = _n
keep if earliest == 1
drop earliest

* Summarise
count
local patientCount = `r(N)'
local patientPropn = round(100*`r(N)'/`popn', 1.0)

post `denom`window'' ("`lbl'") (`cleaned') (`patientPropn')

twoway hist data2, scheme(s1mono) bcolor(navy%30) xtitle("`lbl'") title("Clean")
graph export "$output/hist`lbl'Clean_`window'.png", replace width(400)

* Save results
keep patid data2 
rename data2 `test'
save "$derived/results`lbl'_`window'.dta", replace

* Put PDF
if `output'==1 {
putpdf paragraph, halign(left)
putpdf text ("`lbl'"), underline
putpdf paragraph, halign(left)
putpdf text ("After cleaning, `patientCount' (`patientPropn'%) of patients have a measurement of `test' in the `window' year prior to index")
putpdf paragraph, halign(center)

putpdf image "$output/hist`lbl'Raw_`window'.png",  width(3in) height(3in)  
putpdf image "$output/hist`lbl'Clean_`window'.png",  width(3in) height(3in)  linebreak
}
restore


postclose `denom`window''

use "$derived/testSummary_`window'.dta", clear
export excel using "$derived/testSummary_`window'.xls", replace

}
putpdf save "$output/testResultsOutput.pdf", replace























