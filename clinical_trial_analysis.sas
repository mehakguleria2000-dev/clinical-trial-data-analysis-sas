\import_file.sas\
proc import datafile="C:\Users\Ankit\OneDrive\Documents\SOURCE\demographics.csv" out=clinical_data
dbms=csv replace;
getname=yes
run;
proc print data=clinical_data;
run;

\cleaning_data\
data clean_data;
set clinical_data;
if patient_id=. then delete;
if age<18 or age>45 then delete;
run;
proc print data=clean_data;
run;

\summary_data\
proc means data=clean_data n nmiss;
run;
proc means data=clean_data mean std min max;
class _treatment_group;
var Age SBP DBP;
run;
proc freq data=clean_data;
tables _treatment_group*ae/ chisq;
run;

\reporting_data\
proc report data=clean_data nowd headline;
column _treatment_group outcome patient_id;
define treATMENT_GROUP / GROUP "treatment group";
define outcome / group "outcome";
define patient_id / n "count";
title "efficacy summary table";
run;

proc report data=clean_data nowd;
column patient_id _treatment_group ae ae_severity;
define patient_id / display;
define _treatment_group / group;
define ae / display;
define ae_severity / display;
title "adverse event listing";
run;
