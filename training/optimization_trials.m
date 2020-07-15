% run a number of trials for each optimization algorithm. GSA duration will determine
% the max-time for the other algorithms
load('ANN1')


no_trials=10;
Best=zeros(3,no_trials);
for trials=1:no_trials
    Best(1,trials)=RSA_unique(ANN1);
    Best(2,trials)=GA_det(ANN1);
    Best(3,trials)=bayes_opt_weights_simple(ANN1);
end

Best=Best.*-1;
Best=Best';


Best(:,end+1)=0.8671;
boxplot(Best)
title('Randsearch                     GA                               Baesopt')

ylabel('NSE')
