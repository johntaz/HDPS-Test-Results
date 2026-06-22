/*==============================================================================
FILE NAME:				dm_002_identify_relevant_test_results
AUTHOR:					John Tazare
DESCRIPTION OF FILE:	Identify all relevant test results for 1-year/2-years
*=============================================================================*/

* Create debugMode 
local debugMode 0 // 1 = Yes , 0 = No

* Import test data file
forvalues p = 1/11 {
use "$datadir/raw/test_part_`p'", replace 

* Grab sample for testing code
if `debugMode' == 1 {
keep if _n < 1000000
}

* Data prep
rename data3 unitsCode
drop if unitsCode == . 
keep if data2 > 0 & data2 !=.

* Merge the SUM look up.
merge m:1 unitsCode using "$lookups/SUM.dta"
keep if _merge == 3
drop _merge

* Merge patient indexdates
merge m:1 patid using "$datadir/derived/ppi_h2ra_cohort", keepusing(indexdate)
keep if _merge == 3 
drop _merge
format indexdate %td 

duplicates drop

* Only keep eventdates before or on indexdate 
keep if eventdate <= indexdate
gen recent = indexdate - eventdate

 save "$derived/relevantTest_`p'", replace
}

* Append files
foreach v of numlist 1 2 3 4 5 6 7 8 9 10  {
 append using "$derived/relevantTest_`v'"
 } 

* Save all the files to one dataset
save "$derived/relevantTestResults", replace

* Clean up individual files
foreach v of numlist 1 2 3 4 5 6 7 8 9 10 11  {
 rm "$derived/relevantTest_`v'.dta"
 } 
 
 * Vary baseline timewindows
foreach v of numlist 1 2 {
use "$derived/relevantTestResults", replace
drop if recent >= `v'*365.25
save "$derived/relevantTestResults_`v'Year", replace
 } 

 
