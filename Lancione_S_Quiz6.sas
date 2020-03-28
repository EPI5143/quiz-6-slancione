/*
EPI5143 Winter 2020 Quiz 6

Lancione, Samantha (300140003)

Using the Nencounter table from the class data:
a) How many patients had at least 1 inpatient encounter that started in 2003?
b) How many patients had at least 1 emergency room encounter that started in 2003? 
c) How many patients had at least 1 visit of either type (inpatient or emergency
room encounter) that started in 2003?
d) In patients from c) who had at least 1 visit of either type, create a variable
that counts the total number encounters (of either type)-for example,
a patient with one inpatient encounter and one emergency room encounter 
would have a total encounter count of 2. Generate a frequency table of 
total encounter number for this data set, and paste the (text) table 
into your assignment
*/


/*SET UP*/
/*Library pointing to data that WON'T be modified*/
libname ldata '/folders/myfolders/largedata';

/*Library pointing to what will be used to modify*/
libname class '/folders/myfolders/largedata/workfolder/Data';

/*Creating a copy of the encounter file in the class library to use*/
data class.nencounter;
	set ldata.nencounter;
run;
/*The data set CLASS.NENCOUNTER has 24531 observations*/

/*STEP 1 - Create a dataset with patient encounters that start in 2003
and encounter type flag*/
data class.ptencounter;
set class.nencounter;
if year(datepart(encStartdtm)) ne 2003 then delete;
inptenc=0;
if EncVisitTypeCd = 'INPT' then inptenc=1;
emerenc=0;
if EncVisitTypeCd = 'EMERG' then emerenc=1;
run;
/*The data set CLASS.PTENCOUNTER has 3327 observations*/

/*STEP 2 - Creating one row per patient ID (i.e flatfiling)
Looking at the max value and sum for flag variables*/
Proc means data=class.ptencounter noprint;
class EncPatWID;
types EncPatWID;
var inptenc emerenc;
output out=tempencounter 
max(inptenc)=inptenc sum(inptenc)=insum max(emerenc)=emerenc sum(emerenc)=emsum;
run;
/*The data set WORK.TEMPENCOUNTER has 2891 observations*/

/*Part a*/
proc freq data=tempencounter;
Tables inptenc;
run;
/* The amount of patients that had at least 1 inpatient encounter in 2003
was 1074*/

/*Part b*/
proc freq data=tempencounter;
Tables emerenc;
run;
/* The amount of patients that had at least 1 emergency encounter in 2003
was 1978*/

/*
proc freq data=tempencounter nlevels;
	tables EncPatWID;
	run;

TEMPENCOUNTER: 2891 unique variables
SUCCESSFULLY FLATFILED*/	

/*Part c*/
proc freq data=tempencounter;
Tables emerenc*inptenc;
run;
/*The amount of patients that had at least 1 visit of either type in 2003 
was 2891*/

/*Part d - Creating a dataset that contains a count variable (totalsum) 
that counts the total number of encounters of either type*/
data tempencounter2; 
set tempencounter;
if insum > 0 OR emsum > 0;
totalsum = insum + emsum;
run; 

/*Frequency table of totalsum variable*/
proc freq data=tempencounter2;
Tables totalsum;
run;


/*
			The FREQ Procedure
			
total							Cumulative	Cumulative
sum		Frequency	Percent		Freq		Percent	
1		2556		88.41		2556		88.41
2		270			9.34		2826		97.75
3		45			1.56		2871		99.31
4		14			0.48		2885		99.79
5		3			0.10		2888		99.90
6		1			0.03		2889		99.93
7		1			0.03		2890		99.97
12		1			0.03		2891		100.00

*/



