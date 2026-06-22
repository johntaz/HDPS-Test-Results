/*==============================================================================
FILE NAME:				dm_001_load_lookups
AUTHOR:					John Tazare
DESCRIPTION OF FILE:	Convert lookup files (specimen of unit measurement) 
						to Stata dta
*=============================================================================*/

* Import lookups and convert to .dta
insheet using "$lookups/SUM.txt", clear
rename code unitsCode
rename specimenunitofmeasure unitMeasurement
save "$lookups/SUM.dta", replace
use "$lookups/SUM.dta", replace

*=============================================================================*/


