  % clear all
% close all
% clc

load('data_NarxN');
rng('shuffle');

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




% Choose a Training Function
trainFcn = 'trainlm';  % 

% Create a Nonlinear Autoregressive Network with External Input
nrun=1;
TF=2;
inputDelays = 2; %0:inputDelays
feedbackDelays = 7;%1:feedbackDelays
hidden1=7;
hidden2=4;

hiddenLayerSize = [hidden1,hidden2]; %4:5--> 2 hidden layers [4,5]


tic;

all_config_results=zeros(nrun,11);
for z=1:nrun
    rng(5);
    %     rng('shuffle');
    
    net = narxnet([0:inputDelays],[1:feedbackDelays],hiddenLayerSize,'open',trainFcn);
    
    net.trainParam.epochs=30;%!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      
    net.trainParam.max_fail=4;%!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    
    %transfer functions
    %-----------------------------------------------------------------
    if TF==1
        net.layers{1}.transferFcn='tansig';
        net.layers{2}.transferFcn='tansig';
        net.layers{3}.transferFcn='tansig';
    end
    if TF==2
        net.layers{1}.transferFcn='tansig';
        net.layers{2}.transferFcn='tansig';
        net.layers{3}.transferFcn='purelin';
    end
    if TF==3
        net.layers{1}.transferFcn='tansig';
        net.layers{2}.transferFcn='logsig';
        net.layers{3}.transferFcn='tansig';
    end
    if TF==4
        net.layers{1}.transferFcn='tansig';
        net.layers{2}.transferFcn='logsig';
        net.layers{3}.transferFcn='purelin';
    end
    if TF==5
        net.layers{1}.transferFcn='logsig';
        net.layers{2}.transferFcn='tansig';
        net.layers{3}.transferFcn='tansig';
    end
    if TF==6
        net.layers{1}.transferFcn='logsig';
        net.layers{2}.transferFcn='tansig';
        net.layers{3}.transferFcn='purelin';
    end
    if TF==7
        net.layers{1}.transferFcn='logsig';
        net.layers{2}.transferFcn='logsig';
        net.layers{3}.transferFcn='tansig';
    end
    if TF==8
        net.layers{1}.transferFcn='logsig';
        net.layers{2}.transferFcn='logsig';
        net.layers{3}.transferFcn='purelin';
    end
    %-----------------------------------------------------------------
    net.trainParam.showWindow = 0;   % <== This does it
                            
    
    
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

    
    
    
    
    
    % Train the Network
    [net,tr] = train(net,x,t,xi,ai);
    
    
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
    
    
    %Performance on the testset
    Ts_e=gsubtract(tc,yc);
    Ts_e=cell2mat(Ts_e);
    % Ts_PBIAS=sum(Ts_e*100)/sum(TARGET);
    Ts_mse=mse(Ts_e);
    Ts_RMSE=(Ts_mse)^.5;
    [NSE_t] = ns_efficiency(cell2mat(tc),cell2mat(yc));
    [r,m,b]=regression(tc,yc);
    % % %     figure;
    % % %     plotregression(tc,yc);
    
    
    %Performance on the wholeset
    [xc,xic,aic,tc] = preparets(netc,X_whole,{},T_whole);
    yc = netc(xc,xic,aic);
    [NSE_w] = ns_efficiency(cell2mat(tc),cell2mat(yc));
    
    
    %----------------SAVE RESULTS--------------------------
    %für die auswertung der opti trials einfach nur NSE_t und NSW_w verwenden
    configuration= [inputDelays feedbackDelays TF hidden1 hidden2 z];
    configuration_results=[NSE_t NSE_w r Ts_mse Ts_RMSE configuration];
    % % %     configuration_string=[sprintf('_%d') num2str(z) sprintf('_%d') num2str(inputDelays) sprintf('_%d') num2str(feedbackDelays) sprintf('_%d') num2str(TF) sprintf('_%d') num2str(hidden1) sprintf('_%d') num2str(hidden2)];
    % % %     filename = sprintf('net%s.mat',configuration_string);
    % % %     save(fullfile(pwd,'\save_nets\', filename ), 'net')
    
    
    all_config_results(z,:)=configuration_results;
    %--------------END TO SAVE RESULTS---------------------
    
end
all_config_results=sortrows(all_config_results,[1 4],{'descend' 'ascend'});


toc


