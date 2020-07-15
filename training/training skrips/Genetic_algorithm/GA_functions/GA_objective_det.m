function [opti_func]=GA_objectives(ANN1)  %außere funktion die die daten reinlädt und ein function handle aus der inneren erstellt
    function [nse_v_and_ts]=opti(X)   %objective function, bzw zu optimierende function
    
    INPUT=ANN1(:,1);
    TARGET=ANN1(:,2);
    
% % %     %take out outliers
% % %     B=INPUT>150;
% % %     INPUT=INPUT(B);
% % %     TARGET=TARGET(B);
    
    INPUT(1)=[];
    TARGET(1)=[];
    
    
    %Der input vector "X" enthält die zu optimierenden hyperparameter, welche
    %der GA ausprobiert und an unsere objective function übergibt
    N1=X(1);
    N2=X(2);
    TF1=X(3);
    TF2=X(4);
    TF3=X(5);
    WB=X(6);
    
    rng(WB)
    
    
    net = feedforwardnet([N1 N2]);
    
    net.trainParam.showWindow = 0;
    net.performParam.normalization='standard'; %normalization
    net.trainParam.max_fail=4;
    
    net.divideFcn='divideint';
    net.divideParam.trainRatio=.70;
    net.divideParam.valRatio=.15;
    net.divideParam.testRatio=.15;
    
    net.trainParam.epochs=30;
    
    
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
    
    
    [net,tr] = train(net,INPUT',TARGET');
    output = net(INPUT');
    targetd=TARGET';
    
% % %     %calculate mean between testset mse and valset mse : mse_v_and_ts
% % %     tsTarg = targetd(tr.testInd);
% % %     tsOut = output(tr.testInd);
% % %     vTarg = targetd(tr.valInd);
% % %     vOut = output(tr.valInd);
% % %     
% % %     Ts_e=tsTarg-tsOut;
% % %     Ts_mse=mse(Ts_e);
% % %     
% % %     V_e=vTarg-vOut;
% % %     V_mse=mse(V_e);
% % %   
% % %     mse_v_and_ts=(Ts_mse+V_mse)*0.5;
% % %     RMSE=mse_v_and_ts^.5;
% % %     
     
    %calculate mean between testset nse and valset nse: nse_v_and_ts
    tsTarg = targetd(tr.testInd);
    tsOut = output(tr.testInd);
    vTarg = targetd(tr.valInd);
    vOut = output(tr.valInd);
    
    Ts_diff=tsTarg-tsOut;
    Ts_mean_observed_diff=tsTarg-mean(tsTarg);
    Ts_nse=1-(sum(Ts_diff.^2)/(sum(Ts_mean_observed_diff.^2)));
    
    v_diff=vTarg-vOut;
    v_mean_observed_diff=vTarg-mean(vTarg);
    v_nse=1-(sum(v_diff.^2)/(sum(v_mean_observed_diff.^2)));
    
    nse_v_and_ts=(Ts_nse+v_nse)*0.5;
    nse_v_and_ts=nse_v_and_ts*(-1);
   
    end
opti_func=@opti; %erstellen des function handle
end

