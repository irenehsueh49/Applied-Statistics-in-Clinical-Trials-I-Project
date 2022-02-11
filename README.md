# International-Stroke-Trial-Analysis
For my final project for my BS 851 - Applied Statistics in Clinical Trials I course, I analyzed the International Stroke Trial database. The IST was a prospective, randomized control clinical trial conducted between 1991 and 1996 whose main goal was to determine whether early administration of aspirin, heparin, or both impacted the clinical course of acute ischemic stroke. More information about the IST can be found [here](https://github.com/irenehsueh49/International-Stroke-Trial-Analysis/blob/main/IST%20Information/International%20Stroke%20Trial%20Information.pdf) and [here](https://github.com/irenehsueh49/International-Stroke-Trial-Analysis/blob/main/IST%20Information/International%20Stroke%20Trial%20Database%20Information.pdf). I decided to investigate whether early administration of aspirin was associated with decrease in recurrent hemorrhagic stroke within the 14 days of follow-up.  

In SAS, I ran 
- crude logistic regression 
- multivariate logistic regression, adjusting for sex and age
- inverse probability weighted analysis to remove the confounding from age and sex
- multivariate logistic regression to assess interaction between treatment and initial hemorrhagic stroke on the relationship between treatment and recurrent hemorragic stroke, adjuting for age and sex
- stratitifed multivariate logistic regressions for final diagnosis of presence of initial hemorrhagic stroke 

In R, I ran
- mediation analysis to account for potential mediator of pulmonary embolism, adjusting for sex and age 
![Full Causal Chart](https://user-images.githubusercontent.com/74632124/153634405-a59c87cd-d8e2-4be4-a534-70142e952581.png)
In conclusion, I found 
1) no effect of aspirin on recurrent hemorrhagic stroke within 14 days of follow-up
2) no effect of aspirin on recurrent hemorrhagic stroke within 14 days of follow-up, adjusting for confounders of age and sex
3) no interaction between treatment type and initial hemorrhagic stroke on recurrent hemorrhagic stroke
4) no effect of aspirin on recurrent hemorrhagic stroke through mediator of pulmonary emobolism, adjusting for confounders of age and sex

You can read my full report [here](https://github.com/irenehsueh49/International-Stroke-Trial-Analysis/blob/main/Irene%20Hsueh's%20IST%20Analysis.pdf). I'd like to thank Professor Sara Lodi and Benjamin Sweigart for a great class and teaching me so much about Clinical Trials statistics. 
Feel free to contact me at irenehsueh49@gmail.com with any questions about my code!
