# International-Stroke-Trial-Analysis
For my final project for my BS 851 - Applied Statistics in Clinical Trials I course, I analyzed the International Stroke Trial database. The IST was a prospective, randomized control clinical trial conducted between 1991 and 1996 whose main goal was to determine whether early administration of aspirin, heparin, or both impacted the clinical course of acute ischemic stroke. More information about the IST can be found [here](https://github.com/irenehsueh49/International-Stroke-Trial-Analysis/blob/main/IST%20Information/International%20Stroke%20Trial%20Information.pdf) and [here](https://github.com/irenehsueh49/International-Stroke-Trial-Analysis/blob/main/IST%20Information/International%20Stroke%20Trial%20Database%20Information.pdf). I decided to investigate whether early administration of aspirin was associated with decrease in recurrent hemorrhagic stroke.  

In SAS, I ran 
1) crude logistic regression 
2) multivariate logistic regression, adjusting for sex and age
3) inverse probability weighted analysis to remove the confounding from age and sex
4) multivariate logistic regression to assess interaction between treatment and initial hemorrhagic stroke on the relationship between treatment and recurrent hemorragic stroke, adjuting for age and sex
5) stratitifed multivariate logistic regressions for final diagnosis of presence of initial hemorrhagic stroke 

In R, I ran
1) 

You can find my full report [here](https://github.com/irenehsueh49/International-Stroke-Trial-Analysis/blob/main/Irene%20Hsueh's%20IST%20Analysis.pdf). 


I'd like to thank Professor Sara Lodi and Benjamin Sweigart for a great class and teaching me so much about Clinical Trials statistics. 
Feel free to contact me at irenehsueh49@gmail.com with any questions about my code!
