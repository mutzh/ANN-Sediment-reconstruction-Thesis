% run a number of trials for each optimization algorithm. GSA duration will determine
% the max-time for the other algorithms
load('ANN1')


no_trials=2;
trials=1;
Best=zeros(1,no_trials);
for trials=1:no_trials

    Best(trials,1)=bayes_opt_weights_simple(ANN1);
  
end
    