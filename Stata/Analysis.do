/* Group project
	Amanda Ketner
	STATS 506, Fall 2019
	December 4, 2019
*/

cd "/Users/amandaketner/Documents/Grad_School/U_of_M/Semester_5 _Fall_2019/STATS_506/Group_project/"


*Import data
import sasxport5 "ALQ_D.xpt", clear
save "Alcohol.dta", replace
import sasxport5 "DBQ_D.xpt", clear
save "Diet.dta", replace
import sasxport5 "Demo_D.xpt", clear
save "Demographic.dta", replace

*Clean data and drop unwanted variables
use "Alcohol.dta", clear
keep seqn alq130
replace alq130=. if alq130==999
replace alq130=0 if alq130==1
rename alq130 alq_drink
save "Alcohol.dta", replace

use "Diet.dta", clear
keep seqn dbd091 dbq700
replace dbd091=0 if dbd091==6666
replace dbd091=21 if dbd091==5555
replace dbd091=. if dbd091==7777 | dbd091==9999
replace dbq700=. if dbq700==7 | dbq700==9
rename dbd091 meal_out
rename dbq700 diet
save "Diet.dta", replace

use "Demographic.dta", replace
keep seqn ridageyr riagendr indfmpir
replace riagendr=0 if riagendr==2
rename ridageyr age
rename riagendr gender
rename indfmpir pir
save "Demographic.dta", replace

*Merge data together and drop minors
use "Alcohol.dta", clear
merge 1:1 seqn using "Diet.dta", nogen
merge 1:1 seqn using "Demographic.dta", nogen
drop if Age<21
save "Final.dta", replace


*(Non zero-inflated) negative binomial model
nbreg alq_drink diet i.gender age pir
outreg2 using NegBin.xls, stats(coef se tstat pval) noaster replace

*Zero-inflated negative binomial model (default is logit)
zinb alq_drink diet i.gender age pir, inflate(meal_out) forcevuong
outreg2 using ZeroNegBin.xls, stats(coef se tstat pval) noaster replace
