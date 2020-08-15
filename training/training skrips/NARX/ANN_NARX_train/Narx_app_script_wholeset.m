% clear all
% close all
% clc

%here we train on all of data_NarxN in order to then use the network which generates
%a hydrograph, which will show how difficult the testset data really is!


load('data_NarxN')
rng('shuffle');


INPUT=data_NarxN(:,1)';
TARGET=data_NarxN(:,2)';


X = tonndata(INPUT,true,false);
T = tonndata(TARGET,true,false);





% Choose a Training Function
trainFcn = 'trainlm';  % Bayesian Regularization backpropagation.

% Create a Nonlinear Autoregressive Network with External Input
nrun=1;
TF=2;
inputDelays = 0:3;
feedbackDelays = 1:3;
hidden1=3;
hidden2=2;
hiddenLayerSize = [hidden1,hidden2]; %4:5--> 2 hidden layers [4,5]




all_config_results=zeros(nrun,15);
for z=1:nrun
%     rng(z);
    %     rng('shuffle');
    
    net = narxnet(inputDelays,feedbackDelays,hiddenLayerSize,'open',trainFcn);
    
    net.trainParam.epochs=30;
    net.performParam.normalization='standard';
    net.trainParam.max_fail=4;
    
    
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
    net.divideParam.trainRatio = 70/100;
    net.divideParam.valRatio = 15/100;
    net.divideParam.testRatio = 15/100;
    
    
    
    
    
    % Train the Network
    [net,tr] = train(net,x,t,xi,ai);
    
    
    
    % % Recalculate Training, Validation and Test Performance
    % trainTargets = gmultiply(t,tr.trainMask);
    % valTargets = gmultiply(t,tr.valMask);
    % testTargets = gmultiply(t,tr.testMask);
    % trainPerformance = perform(net,trainTargets,y)
    % valPerformance = perform(net,valTargets,y)
    % % testPerformance = perform(net,testTargets,y)
    
    
    % % View the Network
    % view(net)
    
    % Plots
    % Uncomment these lines to enable various plots.
    %figure, plotperform(tr)
    %figure, plottrainstate(tr)
    %figure, ploterrhist(e)
    %figure, plotregression(t,y)
    %figure, plotresponse(t,y)
    %figure, ploterrcorr(e)
    %figure, plotinerrcorr(x,e)
    
    %calculate closed loop performance on the testset
    netc = closeloop(net);
    % netc.name = [net.name ' - Closed Loop'];
    % view(netc)
    [xc,xic,aic,tc] = preparets(netc,X,{},T);
    yc = netc(xc,xic,aic);
    
    
    %Performance on the testset
    Ts_e=gsubtract(tc,yc);
    Ts_e=cell2mat(Ts_e);
    % Ts_PBIAS=sum(Ts_e*100)/sum(TARGET);
    Ts_mse=mse(Ts_e);
    Ts_RMSE=(Ts_mse)^.5;
    [NSE] = ns_efficiency(cell2mat(tc),cell2mat(yc));
    [r,m,b]=regression(tc,yc);
    % % %     figure;
    % % %     plotregression(tc,yc);
    
    
    
    %----------------SAVE RESULTS--------------------------
    configuration= [inputDelays feedbackDelays TF hidden1 hidden2 z];
    configuration_results=[NSE r Ts_mse Ts_RMSE configuration];
    % % %     configuration_string=[sprintf('_%d') num2str(z) sprintf('_%d') num2str(inputDelays) sprintf('_%d') num2str(feedbackDelays) sprintf('_%d') num2str(TF) sprintf('_%d') num2str(hidden1) sprintf('_%d') num2str(hidden2)];
    % % %     filename = sprintf('net%s.mat',configuration_string);
    % % %     save(fullfile(pwd,'\save_nets\', filename ), 'net')
    
    
    all_config_results(z,:)=configuration_results;
    %--------------END TO SAVE RESULTS---------------------
    
end
all_config_results=sortrows(all_config_results,[1 4],{'descend' 'ascend'});





