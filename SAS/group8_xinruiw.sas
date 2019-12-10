/* STATS 506 Project - Group 8 */
/* Topic : Relationship between eating habit and alcohol use of people. */
/* Data : datasets from NHANES 2005-2006 - ALQ_D.xpt, DBQ_D.xpt, DEMO_D.xpt */
/* Method: zero inflated negative binomial regression */
/* Author: Xinrui Wu */
/* Latest modify: Dec 10, 2019

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
  output out = outnb pred = prednb;
run;

/* store the predict value of the model */
proc sort data = outnb;
  by id;
run;

/* (2) zero-inflated negative binomial regression */
proc genmod data = alcohol_diet order = data;
  model alq = diet gender age pir /dist = zinb;
  zeromodel meal_out;
  output out = outzinb pred = predzinb pzero = p0;
run;

/* store the predict value of the model */
proc sort data = outzinb;
  by id;
run;
/* merge the predict values of the two model */
data predict;
  merge outnb outzinb;
  by id;
run;

/* 3. use vuong test to compare the two models */
%include "/folders/myfolders/vuong.sas";
%vuong(data = predict, response = alq,
	   model1 = nb,   p1 = prednb, dist1 = nb, scale1 = 0.6381,
	   model2 = zinb, p2 = predzinb, dist2 = zinb, scale2 = 0.2236, pzero2 = p0,
       nparm1 = 4, nparm2 = 5)




