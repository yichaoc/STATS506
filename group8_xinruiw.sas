/* STATS 506 Project - Group 8 */
/* Topic : Relationship between eating habit and alcohol use of people. */
/* Data. : datasets from NHANES 2005-2006 - ALQ_D.xpt, DBQ_D.xpt, DEMO_D.xpt */
/* Method: zero inflated negative binomial regression */
/* Author: Xinrui Wu */

/* 0. read data */
proc import replace
	datafile='/folders/myfolders/STATS506_project/alq_diet.csv' 
	out=alcohol_diet;
run;

proc print data=alcohol_diet;
run;

/* 1. Basic checking */
proc means data = alcohol_diet mean var;
	var alq meal_out diet age gender pir;
run;

/* frequency graph of alcohol */
ods graphics / width=4in height=3in border=off;
proc sgplot data=alcohol_diet;
	histogram alq /binwidth=1;
run;
ods graphics off;

/* 2. model analysis */
/* (1) negative binomial regression */
proc genmod data = alcohol_diet;
  model alq = diet gender age pir /dist=negbin;
run;

/* (2) zero-inflated negative binomial regression */
proc genmod data = alcohol_diet order = data;
  model alq = diet gender age pir /dist=zinb;
  zeromodel meal_out;
run;








