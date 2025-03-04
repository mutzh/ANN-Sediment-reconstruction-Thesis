% clear all
% close all
% clc




% the difference to the other narx app script is, that here  the hyperparameters are
% taken from the best_cand_overall vektor, which is produced by the optimization
% trials
%furthermore instead of controlling the rng(seed) we simply let matlab return at what
%seed the rng was during initialization of the NN problem, and thus take out bias by
%having random rng states








load('opti_trials_NARX_final');
load('data_NarxN');


X_whole=data_NarxN(:,1)';
T_whole=data_NarxN(:,2)';
X_test=data_NarxN(1:2809,1)';
T_test=data_NarxN(1:2809,2)';
INPUT=data_NarxN(2810:end,1)';
TARGET=data_NarxN(2810:end,2)';

X_whole=tonndata(X_whole,true,false);
T_whole=tonndata(T_whole,true,false);
X_test=tonndata(X_test,true,false);
T_test=tonndata(T_test,true,false);
X = tonndata(INPUT,true,false);
T = tonndata(TARGET,true,false);


nrun=50;
% best_cand_overall=best_cand_overall(1:10,:);  %gekürzt zum testen

all_config_results=zeros(length(best_cand_overall)*nrun,10);
for i=1:length(best_cand_overall)
    
    %get hyperparameter set from the best candidates
    HP_candidate=best_cand_overall(i);
    HP_candidate=cell2mat(HP_candidate);

    % define structure and training parameters of the network
    trainFcn = 'trainlm';  % 

    TF1=HP_candidate(3);
    TF2=HP_candidate(4);
    TF3=HP_candidate(5);
    inputDelays = HP_candidate(6); %0:inputDelays
    feedbackDelays = HP_candidate(7);%1:feedbackDelays
    hidden1=HP_candidate(1);
    hidden2=HP_candidate(2);
    
    hiddenLayerSize = [hidden1,hidden2]; %4:5--> 2 hidden layers [4,5]
    
    
    
    
    
    for z=1:nrun

        
%       Create a Nonlinear Autoregressive Network with External Input

        net = narxnet([0:inputDelays],[1:feedbackDelays],hiddenLayerSize,'open',trainFcn);
        
        net.trainParam.epochs=30;%!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        
        net.trainParam.max_fail=4;%!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        
        net.trainParam.showWindow = 0;   % <== This does it

        %transfer functions
        %-----------------------------------------------------------------
        if TF1==1
            net.layers{1}.transferFcn='tansig';
        elseif TF1==2
            net.layers{1}.transferFcn='logsig';
        end
        
        
        if TF2==1
            net.layers{2}.transferFcn='tansig';
        elseif TF2==2
            net.layers{2}.transferFcn='logsig';
        end
        
        
        if TF3==1
            net.layers{3}.transferFcn='tansig';
            
        elseif TF3==2
            net.layers{3}.transferFcn='purelin';
        end
        % % %     if TF==1
        % % %         net.layers{1}.transferFcn='tansig';
        % % %         net.layers{2}.transferFcn='tansig';
        % % %         net.layers{3}.transferFcn='tansig';
        % % %     end
        % % %     if TF==2
        % % %         net.layers{1}.transferFcn='tansig';
        % % %         net.layers{2}.transferFcn='tansig';
        % % %         net.layers{3}.transferFcn='purelin';
        % % %     end
        % % %     if TF==3
        % % %         net.layers{1}.transferFcn='tansig';
        % % %         net.layers{2}.transferFcn='logsig';
        % % %         net.layers{3}.transferFcn='tansig';
        % % %     end
        % % %     if TF==4
        % % %         net.layers{1}.transferFcn='tansig';
        % % %         net.layers{2}.transferFcn='logsig';
        % % %         net.layers{3}.transferFcn='purelin';
        % % %     end
        % % %     if TF==5
        % % %         net.layers{1}.transferFcn='logsig';
        % % %         net.layers{2}.transferFcn='tansig';
        % % %         net.layers{3}.transferFcn='tansig';
        % % %     end
        % % %     if TF==6
        % % %         net.layers{1}.transferFcn='logsig';
        % % %         net.layers{2}.transferFcn='tansig';
        % % %         net.layers{3}.transferFcn='purelin';
        % % %     end
        % % %     if TF==7
        % % %         net.layers{1}.transferFcn='logsig';
        % % %         net.layers{2}.transferFcn='logsig';
        % % %         net.layers{3}.transferFcn='tansig';
        % % %     end
        % % %     if TF==8
        % % %         net.layers{1}.transferFcn='logsig';
        % % %         net.layers{2}.transferFcn='logsig';
        % % %         net.layers{3}.transferFcn='purelin';
        % % %     end
        %-----------------------------------------------------------------
        
        
        
        % Prepare the Data for Training and Simulation
        % The function PREPARETS prepares timeseries data for a particular network,
        % shifting time by the minimum amount to fill input states and layer
        % states. Using PREPARETS allows you to keep your original time series data
        % unchanged, while easily customizing it for networks with differing
        % numbers of delays, with open loop or closed loop feedback modes.
        [x,xi,ai,t] = preparets(net,X,{},T);
        
        % Setup Division of Data for Training, Validation, Testing
        net.divideMode= 'time';
        net.divideFcn='dividerand';
        net.divideParam.trainRatio = 82.5/100;
        net.divideParam.valRatio = 17.5/100;
        net.divideParam.testRatio = 0/100;
        net.performParam.normalization='standard'; %normalization
        

        %shuffle rng
        rng('shuffle');

        % Train the Network
        [net,tr] = train(net,x,t,xi,ai);
        %return rng state
        rng_seed=rng;
        rng_state=rng_seed.Seed;
        
        rng('shuffle');
        
        % % Recalculate Training, Validation and Test Performance
        % trainTargets = gmultiply(t,tr.trainMask);
        % valTargets = gmultiply(t,tr.valMask);
        % testTargets = gmultiply(t,tr.testMask);
        % trainPerformance = perform(net,trainTargets,y)
        % valPerformance = perform(net,valTargets,y)
        % % testPerformance = perform(net,testTargets,y)
        
        
        %------------------------------------------------------------------------------------------
        %calculate closed loop performance on the testset and train/val set
        netc = closeloop(net);
        % netc.name = [net.name ' - Closed Loop'];
        % view(netc)
        [xc,xic,aic,tc] = preparets(netc,X_test,{},T_test);
        yc = netc(xc,xic,aic);

        [NSE_t] = ns_efficiency(cell2mat(tc),cell2mat(yc));
        
        
        %         %Performance on the testset
        %         Ts_e=gsubtract(tc,yc);
        %         Ts_e=cell2mat(Ts_e);
        %         % Ts_PBIAS=sum(Ts_e*100)/sum(TARGET);
        %         Ts_mse=mse(Ts_e);
        %         Ts_RMSE=(Ts_mse)^.5;
        % %         [r,m,b]=regression(tc,yc);
        %         % % %     figure;
        %         % % %     plotregression(tc,yc); 
        
        
        %Performance on the wholeset
        [xc,xic,aic,tc] = preparets(netc,X_whole,{},T_whole);
        yc = netc(xc,xic,aic);
        [NSE_w] = ns_efficiency(cell2mat(tc),cell2mat(yc));
        
        
        %----------------SAVE RESULTS--------------------------
        %für die auswertung der opti trials einfach nur NSE_t und NSW_w verwenden
        configuration= [hidden1,hidden2,TF1,TF2,TF3,inputDelays,feedbackDelays,rng_state];
        configuration=double(configuration);
        configuration_results=[NSE_t NSE_w configuration];
        % % %     configuration_string=[sprintf('_%d') num2str(z) sprintf('_%d') num2str(inputDelays) sprintf('_%d') num2str(feedbackDelays) sprintf('_%d') num2str(TF) sprintf('_%d') num2str(hidden1) sprintf('_%d') num2str(hidden2)];
        % % %     filename = sprintf('net%s.mat',configuration_string);
        % % %     save(fullfile(pwd,'\save_nets\', filename ), 'net')
        
        
        all_config_results((i-1)*nrun+z,:)=configuration_results;
        %--------------END TO SAVE RESULTS---------------------
        
    end
end
% all_config_results=sortrows(all_config_results,[1 4],{'descend' 'ascend'});


%extract the 12 setups from the results so that each setup is represented by a
%coulumn
count=8*nrun;%8 because we ran 8 trials of the optimization setups for the NARX net

Boxplot_matrix_testset=[all_config_results(1:count,1),all_config_results(1+count:count*2,1),...
    all_config_results(1+count*2:count*3,1),all_config_results(1+count*3:count*4,1),...
    all_config_results(1+count*4:count*5,1),all_config_results(1+count*5:count*6,1),...
    all_config_results(1+count*6:count*7,1),all_config_results(1+count*7:count*8,1),...
    all_config_results(1+count*8:count*9,1),all_config_results(1+count*9:count*10,1),...
    all_config_results(1+count*10:count*11,1),all_config_results(1+count*11:count*12,1)];

Boxplot_matrix_wholeset=[all_config_results(1:count,2),all_config_results(1+count:count*2,2),...
    all_config_results(1+count*2:count*3,2),all_config_results(1+count*3:count*4,2),...
    all_config_results(1+count*4:count*5,2),all_config_results(1+count*5:count*6,2),...
    all_config_results(1+count*6:count*7,2),all_config_results(1+count*7:count*8,2),...
    all_config_results(1+count*8:count*9,2),all_config_results(1+count*9:count*10,2),...
    all_config_results(1+count*10:count*11,2),all_config_results(1+count*11:count*12,2)];


%if you wish to take out the outliers, uncomment this part
%via:"Boxplot_matrix_testset(Boxplot_matrix_testset<(0))=(0);" 
%and Boxplot_matrix_wholeset(Boxplot_matrix_wholeset<(0))=(0);


%visualize the testset NSE via boxplot and bargraph(based on mean)
figure
boxplot(Boxplot_matrix_testset)
title('all setups in order: fixed[RSA,GA,BO,GSA],stochast[RSA,GA,BO,GSA],HP[RSA,GA,BO,GSA]')
ylabel('testset NSE')

means_testset=mean(Boxplot_matrix_testset,1);
x=categorical({'RSA fixed','GA fixed','BO fixed','GSA fixed','RSA stochast','GA stochast','BO stochast','GSA stochast','RSA HP','GA HP','BO HP','GSA HP'});
x=reordercats(x,{'RSA fixed','GA fixed','BO fixed','GSA fixed','RSA stochast','GA stochast','BO stochast','GSA stochast','RSA HP','GA HP','BO HP','GSA HP'});

figure
bar(x,means_testset)
title('MEAN :all setups in order: det[RSA,GA,BO,GSA],noise[RSA,GA,BO,GSA],rng[RSA,GA,BO,GSA]')
ylabel('testset NSE')

%visualize the wholeset NSE via boxplot and bargraph(based on mean)
figure;
boxplot(Boxplot_matrix_wholeset)
title('all setups in order: fixed[RSA,GA,BO,GSA],stochast[RSA,GA,BO,GSA],HP[RSA,GA,BO,GSA]')
ylabel('wholeset NSE')

means_wholeset=mean(Boxplot_matrix_wholeset,1);
x=categorical({'RSA fixed','GA fixed','BO fixed','GSA fixed','RSA stochast','GA stochast','BO stochast','GSA stochast','RSA HP','GA HP','BO HP','GSA HP'});
x=reordercats(x,{'RSA fixed','GA fixed','BO fixed','GSA fixed','RSA stochast','GA stochast','BO stochast','GSA stochast','RSA HP','GA HP','BO HP','GSA HP'});

figure
bar(x,means_wholeset)
title('MEAN :all setups in order: det[RSA,GA,BO,GSA],noise[RSA,GA,BO,GSA],rng[RSA,GA,BO,GSA]')
ylabel('wholeset NSE')