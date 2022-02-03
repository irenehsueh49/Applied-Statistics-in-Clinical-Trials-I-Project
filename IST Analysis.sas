/******************** International Stroke Trial Analysis  ********************/

/* Importing Dataset, Selecting Variables, Renaming Variables */
proc import 
	datafile = "C:/Irene Hsueh's Documents/MS Applied Biostatistics/BS 851 - Applied Statistics in Clinical Trials I/Project/IST.csv"
	out=raw
	(keep=sex age rconsc rvisinf rsbp rdef1 rdef2 rdef3 rdef4 rdef5 rdef6 rdef7 
		  rxasp rxhep ddiagha drsisc drsh drsunk 
	rename=(sex=sex age=age rconsc=conscious rvisinf=infarct_vis rsbp=sbp 
			rdef1=face_deficit rdef2=arm_deficit rdef3=leg_deficit rdef4=dysphasia rdef5=hemianopia 
			rdef6=visuospatial_disorder rdef7=brainstem_signs
			rxasp=aspirin rxhep=heparin ddiagha=initial_hemstroke
			drsisc=ischaemic_stroke drsh=hemorrhagic_stroke drsunk=other_stroke))
	DBMS=csv replace;
	getnames=yes;
run;


/* Creating Treatment and Outcome Variables */
data full_data;
set raw;
	if ischaemic_stroke="Y" or hemorrhagic_stroke="Y" or other_stroke="Y" then stroke="Y";
	else if ischaemic_stroke="N" and hemorrhagic_stroke="N" and other_stroke="N" then stroke="N";
	else if ischaemic_stroke="U" or hemorrhagic_stroke="U" or other_stroke="U" then stroke="U";
	if aspirin="Y" and heparin="N" then trt="Y";
	else if aspirin="N" and heparin="N" then trt="N";
run;


/* Subset of Subjects of Interest*/
proc format;
	value $sex_format "M"="Male" "F"="Female";
	value $conscious_format "F"="Alert" "D"="Drowsy" "U"="Unconscious";
	value $format "Y"="Yes" "N"="No" "C"="Can't Assess" "U"="Unknown";
	value $trt_format "Y"="Aspirin" "N"="Placebo";
run;

data ist;
	set full_data;
	where trt in ("Y", "N");
	drop aspirin heparin;
	id=_n_;
	
	attrib 
		id  					label="ID"
		sex						label="Sex" 										format=$sex_format.
		age						label="Age" 
		conscious				label="Conscious State" 							format=$conscious_format.
		infarct_vis				label="Visible Infarct" 							format=$format.
		sbp						label="SBP"
		face_deficit			label="Face Deficit"								format=$format.
		arm_deficit				label="Arm/Hand Deficit"							format=$format.
		leg_deficit				label="Leg/Foot Deficit"							format=$format.
		dysphasia				label="Dysphasia"									format=$format.
		hemianopia				label="Hemianopia" 									format=$format.
		visuospatial_disorder	label="Visuospatial Disorder"						format=$format.
		brainstem_signs			label="Brainstem/Cerebellar Signs"					format=$format.
		initial_hemstroke 		label="Initial Hemorrhagic Stroke"					format=$format.
		ischaemic_stroke		label="Recurrent Ischaemic Stroke within 14 Days" 	format=$format.
		hemorrhagic_stroke		label="Recurrent Hemorrgaic Stroke within 14 Days" 	format=$format.
		other_stroke			label="Recurrent Other Stroke within 14 Days" 		format=$format.
		stroke					label="Any Recurrent Stroke within 14 Days" 		format=$format.
		trt						label="Treatment"									format=$trt_format.
	;
run;

title "IST Data";
proc print data=ist (obs=50) label
	style(header) = {just=center verticalalign=middle};
	id id;
run;
title;



/* Descriptive Statistics */
ods excel file="C:/Irene Hsueh's Documents/MS Applied Biostatistics/BS 851 - Applied Statistics in Clinical Trials I/Project/OverallDescriptiveStatistics.xlsx";
title "Overall Descriptive Statistics";
proc freq data=ist;
tables sex conscious infarct_vis face_deficit arm_deficit leg_deficit dysphasia
	   hemianopia visuospatial_disorder brainstem_signs hemorrhagic_stroke initial_hemstroke / nocum;
run;
title;

title "Overall Descriptive Statistics";
proc means data=ist mean std;
	var age sbp;
run;
title;
ods excel close;


proc sort data=ist;
	by trt;
run; 

ods excel file="C:/Irene Hsueh's Documents/MS Applied Biostatistics/BS 851 - Applied Statistics in Clinical Trials I/Project/TreatmentDescriptiveStatistics.xlsx";
title "Descriptive Statistics by Treatment";
proc freq data=ist;
	by trt;
tables sex conscious infarct_vis face_deficit arm_deficit leg_deficit dysphasia 
	   hemianopia visuospatial_disorder brainstem_signs hemorrhagic_stroke / nocum;
run;
title;

title "Descriptive Statistics by Treatment";
proc means data=ist mean std;
	class trt;
	var age sbp;
run;
title;
ods excel close;



/* Logistic Regressions */ 
title "Unadjusted Logistic Regression";
proc logistic data=ist;
	where hemorrhagic_stroke in ("Y", "N");
	class trt (ref="Placebo") / param=ref;
	model hemorrhagic_stroke (event="Yes") = trt / risklimits cl; 
run;
title;


title "Adjusted Logistic Regression";
proc logistic data=ist;
	where hemorrhagic_stroke in ("Y", "N");
	class trt (ref="Placebo") sex (ref="Female") / param=ref;
	model hemorrhagic_stroke (event="Yes") = trt sex age / risklimits cl;
run;
title;



/* Inverse Probability Weighing */ 
/* Step 1: Calculate probability of treatment assignment from on baseline covariates. */
proc logistic data=ist;
	where hemorrhagic_stroke in ("Y", "N");
	class sex (ref="Female") / param=ref;
	model trt (event="Aspirin") = sex age / risklimits;
	output out=estimated_trt_prob p=probability_trt;
run;

/* Step 2: Calculate inverse probability weights. */
data estimated_trt_prob;
	set estimated_trt_prob;
	where hemorrhagic_stroke in ("Y", "N");
	if trt="Aspirin" then weight=1/probability_trt;
	else if trt="Placebo" then weight=1/(1-probability_trt);
run;

proc means data=estimated_trt_prob;
	var weight;
run;

/* Step 3: Calculate treatment effect in the weighted population. */
proc genmod data=estimated_trt_prob;
	class trt (ref="Placebo") id / param=ref; 
	weight weight;
	model hemorrhagic_stroke (event="Y") = trt / dist=binomial link=logit;
	repeated subject=id / type=ind;
	estimate "Odds Ratio" trt 1 / exp;
run;



/* Assessing Interaction between Treatment and Initial Hemorrhagic Stroke */ 
title "Hemorrgagic Stroke Reoccurence by Initial Hemorrhagic Stroke";
proc freq data=ist;
	where initial_hemstroke in ("Y", "N") and hemorrhagic_stroke in ("Y", "N");
	tables initial_hemstroke*trt*hemorrhagic_stroke / nopercent nocol oddsratio (CL=wald) cmh bdt;
run;
title;


title "Adjusted Logistic Regression for no Initial Hemorrhagic Stroke";
proc logistic data=ist;
	where hemorrhagic_stroke in ("Y", "N") and initial_hemstroke="N";
	class trt (ref="Placebo") sex (ref="Female") / param=ref;
	model hemorrhagic_stroke (event="Yes") = trt sex age / risklimits cl;
run;
title;


title "Adjusted Logistic Regression for Initial Hemorrhagic Stroke";
proc logistic data=ist;
	where hemorrhagic_stroke in ("Y", "N") and initial_hemstroke="Y";
	class trt (ref="Placebo") sex (ref="Female") / param=ref;
	model hemorrhagic_stroke (event="Yes") = trt sex age / risklimits cl;
run;
title;


title "Adjusted Logistic Regression with Interaction Term";
proc logistic data=ist;
	where hemorrhagic_stroke in ("Y", "N") and hemorrhagic_stroke in ("Y", "N");
	class trt (ref="Placebo") initial_hemstroke (ref="No") sex (ref="Female") / param=ref;
	model hemorrhagic_stroke (event="Yes") = trt|initial_hemstroke sex age / risklimits cl;
	oddsratio trt / at (initial_hemstroke=all);
run;
title;


ODS HTML close;
ODS HTML;
