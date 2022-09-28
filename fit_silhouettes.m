function[parameters]=fit_silhouettes(all_silhouettes)
% function to get parameters from distribution of silhoeuttes 


% parameters is a [alpha beta negloglikelihood mean variance] vector 
parameters=nan(4,1);

pd = fitdist(all_silhouettes,'Beta');

parameters(1)=pd.a;
parameters(2)=pd.b;
parameters(3)=negloglik(pd);
parameters(4)=mean(all_silhouettes);
parameters(5)=var(all_silhouettes);


