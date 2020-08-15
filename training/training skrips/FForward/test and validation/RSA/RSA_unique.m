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

% % % 
% % % %LOAD DATA
% % % % load('ANN2_train.mat') %daten laden für reconstruct
% % % % ANN1=ANN2_train;
% % % load('ANN1')




function [best]= RSA_unique(ANN1)





% % % %loop to do multiple trials
% % % trials=1;
% % % no_trials=2;
% % % results_trials_GSA=zeros(no_trials,1);
% % % while trials< no_trials+1
    
    
    %create serach space to sample from
    tic;
    dim_N1=10;
    dim_N2=10;
    dim_TF1=2;
    dim_TF2=2;
    dim_TF3=2;
    dim_WB=5;
    
%     no_design_possibilites=dim_N1*dim_N2*dim_TF1*dim_TF2*dim_TF3*dim_WB;
    no_design_possibilites=dim_N1*dim_N2*dim_TF1*dim_TF2*dim_TF3*1;
    design_space=zeros(no_design_possibilites,6);
    place=1;
    for a=1:dim_N1
        for b=1:dim_N2
            for c=1:dim_TF1
                for d=1:dim_TF2
                    for e=1:dim_TF3
                        for f=dim_WB
                            design=[a,b,c,d,e,f];
                            design_space(place,:)=design;
                            
                            place=place+1;
                        end
                    end
                end
            end
        end
    end
    
    
    %RSA options
    maxTime=35;
    numIter=500;
    %candidate population
    rng('shuffle')
    candidate_indices=randsample(no_design_possibilites,numIter);
    
    ObjFun=RSA_objective_det(ANN1);
    

    
    Results=zeros(numIter,1);%one iteration takes about 5 s
    
    for i=1:numIter
        
        sample_index=candidate_indices(i);
        design_sample=design_space(sample_index,:);
        
        %     N1=randperm(dim_N1,1);
        %     N2=randperm(dim_N2,1);
        %     TF1=randperm(dim_TF1,1);
        %     TF2=randperm(dim_TF2,1);
        %     TF3=randperm(dim_TF3,1);
        %     WB=randperm(dim_WB,1);
        %
        %     design_candidate=[N1,N2,TF1,TF2,TF3,WB];
        
        result=(feval(ObjFun,design_sample));
        Results(i)=result;
        
        %maxTime
        time=toc;
        if time >= maxTime
            break;
        end
    end
    %display best
    best=min(Results);
% % %     disp(best);
% % %     
% % %     %cut out the excess zeros that werent filled(MaxTime)
% % %     B=Results~=0;
% % %     Results=Results(B);
% % %     
    
% % %     results_trials_GSA(trials)=best;
% % %     trials=trials+1;
% % % end

end

% % % %plot
% % %     figure
% % % plot(1:length(Results),Results,'ro');

% % % toc;




