function [func_RSA]=RSA_objective_NARX_det(data_NarxN) %außere funktion die die daten reinlädt und ein function handle aus der inneren erstellt
    function [NSE]=opti(X)  %objective function, bzw zu optimierende function
    
    test_set_input=data_NarxN(1:2809,1)';
    test_set_target=data_NarxN(1:2809,2)';
    INPUT=data_NarxN(2810:end,1)';
    TARGET=data_NarxN(2810:end,2)';
    

    
    test_set_input=tonndata(test_set_input,true,false);
    test_set_target=tonndata(test_set_target,true,false);
    INPUT = tonndata(INPUT,true,false);
    TARGET = tonndata(TARGET,true,false);
    
    
    %Der input vector "X" enthält die zu optimierenden hyperparameter, welche
    %der bayesopt ausprobiert und an unsere objective function übergibt um sie zu
    %evaluieren
    N1=X(1);
    N2=X(2);
    TF1=X(3);
    TF2=X(4);
    TF3=X(5);
    ID=X(6);
    FD=X(7);
 
    rng(5);
    
    
    
    inputDelays = 0:ID;
    feedbackDelays = 1:FD;
    hiddenSizes = [N1,N2] ;
    trainFcn = 'trainlm';
    
    
    net = narxnet(inputDelays,feedbackDelays,hiddenSizes,'open',trainFcn);
    
    net.trainParam.showWindow = 1;
    net.trainParam.epochs=30;
    net.trainParam.showWindow = 0;
    net.performParam.normalization='standard'; %normalization
    net.trainParam.max_fail=4;
    
    
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
    
    
    %aufteilen der daten mit divideint um immer dieselbe aufteilung zu erreichen und
    %damit den stochasitschen charakter unserer ANN objective function abzuschwächen
    net.divideMode = 'time';
    net.divideFcn='dividerand';
    net.divideParam.trainRatio=825/1000;
    net.divideParam.valRatio=175/1000;
    net.divideParam.testRatio=0;
    
    
    %prepare data(shifting and initial delays)
    [x,xi,ai,t] = preparets(net,INPUT,{},TARGET);
    
    
    
    %train the net in the open loop form
    [net,~] = train(net,x,t,xi,ai);
    
    %evaluate the closed-loop-performance (NSE) via reconstruction of the testset
    %data
    
    % connection from the output layer.
    netc = closeloop(net);
    % netc.name = [net.name ' - Closed Loop'];
    [xc,xic,aic,tc] = preparets(netc,test_set_input,{},test_set_target);
    
    %prediction in closed loop
    yc = netc(xc,xic,aic);
    
    %testparameters
    %     closedLoopPerformance = perform(net,tc,yc);
    [NSE] = -(ns_efficiency(cell2mat(tc),cell2mat(yc)));
    %     [r,m,b] = regression(tc,yc)
    end
func_RSA=@opti; % erstellen eines function handle um dieses an bayesopt zu übergeben


end

