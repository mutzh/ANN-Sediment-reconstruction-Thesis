
% % % %LOAD DATA
% % % % load('ANN2_train.mat') %daten laden für reconstruct
% % % % ANN1=ANN2_train;
% % % load('ANN1')


%%% this RSA works by counting the number of designt possibilies, creating the
%%% design space, where each row vector represents one design, and then sampling
%%% without putting back. We sample from the number of design probabilies(= size of
%%% the second dimension of our design space) and then evaluate the design via out
%%% objective function . This yields and algorithm that doesnt sample the same design
%%% multiple times, which would be a waste



function [best,best_candidate]= RSA_unique_FF_rng(data_NarxN)





% % % %loop to do multiple trials
% % % trials=1;
% % % no_trials=2;
% % % results_trials_GSA=zeros(no_trials,1);
% % % while trials< no_trials+1
    
    
    %create serach space to sample from
    tic;
    dim_N1=11;
    dim_N2=11;
    dim_TF1=2;
    dim_TF2=2;
    dim_TF3=2;
    dim_SEED=100;
    
%     no_design_possibilites=dim_N1*dim_N2*dim_TF1*dim_TF2*dim_TF3*dim_SEED;
    no_design_possibilites=dim_N1*dim_N2*dim_TF1*dim_TF2*dim_TF3*dim_SEED;
    design_space=zeros(no_design_possibilites,6);
    place=1;
    for a=1:dim_N1
        for b=1:dim_N2
            for c=1:dim_TF1
                for d=1:dim_TF2
                    for e=1:dim_TF3
                        for f=1:dim_SEED
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
    maxTime=10000;
    numIter=50000;
    %candidate population
    rng('shuffle')
    %here it is decided which rows(designs) are going to be evaluated on the
    %objective function
    candidate_indices=randsample(no_design_possibilites,numIter);
    
    ObjFun=RSA_objective_FF_unique_rng(data_NarxN);
    

    
    Results=zeros(numIter,1);%one iteration takes about 5 s
    
    for i=1:numIter
        
        sample_index=candidate_indices(i);
        design_sample=design_space(sample_index,:);
        
        
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
    best_candidate_position=find(Results==best,1);
    best_candidate_position=candidate_indices(best_candidate_position);
    best_candidate=design_space(best_candidate_position,:);
% % %     disp(best);
% % %     
% % %     %cut out the excess zeros that werent filled(MaxTime)
% % %     B=Results~=0;
% % %     Results=Results(B);
% % %     
    
% % %     results_trials_GSA(trials)=best;
% % %     trials=trials+1;
% % % end


% %plot
% figure
% plot(1:length(Results),Results,'ro');
% toc;
end







