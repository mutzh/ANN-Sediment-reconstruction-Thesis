%% Random Search Algorithm (Pure Random Search Algorithm)
% by : Reza Ahmadzadeh (seyedreza_ahmadzadeh@yahoo.com - reza.ahmadzadeh@iit.it)
% 14-10-2012
% This code finds the minimum of f(x) = x(1)^2 + x(2)^2
% in which -5 < x(i) < 5
% This function is a convex and the minimum is at (0,0)
% The RSA is the simplest algorithm to solve optimization problem
% it is not efficient and it sometimes cannot solve the problem
% for more information start from here: http://en.wikipedia.org/wiki/Random_search
% clc
% close all
% clear 


%LOAD DATA
% load('ANN2_train.mat') %daten laden für reconstruct
% ANN1=ANN2_train;
load('ANN1')



tic;
dim_N1=16;
dim_N2=16;
dim_TF1=2;
dim_TF2=2;
dim_TF3=2;


maxTime=1000;
numIter=100;
ObjFun=RSA_objective_stochast(ANN1);

figure
results =zeros(numIter,1);%one iteration takes about 5 s
% % % candidates=zeros(numIter,5);
for i=1:numIter
    rng('shuffle')
    N1=randperm(dim_N1,1);
    N2=randperm(dim_N2,1);
    TF1=randperm(dim_TF1,1);
    TF2=randperm(dim_TF2,1);
    TF3=randperm(dim_TF3,1);
   
    
    candidate=[N1,N2,TF1,TF2,TF3];
% % %     candidates(i,:)=candidate;
    result=(feval(ObjFun,candidate));
    results(i)=result;
    
    %maxTime
    time=toc;
    if time >= maxTime
        break;
    end
end
best=min(results);
disp(best);

%cut out the excess zeros that werent filled(MaxTime)
B=results~=0;
results=results(B);

%plot 
plot(1:length(results),results,'ro');
toc;
% just easy, no?! --> YES!!


