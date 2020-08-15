function [func_RSA]=RSA_objective_FF_unique_noise(data_NarxN) %außere funktion die die daten reinlädt und ein function handle aus der inneren erstellt
    function [NSE]=opti(X)  %objective function, bzw zu optimierende function
    
    test_set_input=data_NarxN(1:2809,1)';
    test_set_target=data_NarxN(1:2809,2)';
    INPUT=data_NarxN(2810:end,1)';
    TARGET=data_NarxN(2810:end,2)';
    
    %Der input vector "X" enthält die zu optimierenden hyperparameter, welche
    %der bayesopt ausprobiert und an unsere objective function übergibt um sie zu
    %evaluieren
    N1=X(1);
    N2=X(2);
    TF1=X(3);
    TF2=X(4);
    TF3=X(5);
   
    

    net = feedforwardnet([N1 N2]);
    
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
    
    
  
    net.divideFcn='dividerand';
    net.divideParam.trainRatio=825/1000;
    net.divideParam.valRatio=175/1000;
    net.divideParam.testRatio=0;
    
    
  
    [net,~] = train(net,INPUT,TARGET);
    
    output = net(test_set_input);
    
    [NSE] = -(ns_efficiency(test_set_target,output));
    %     [r,m,b] = regression(tc,yc)
   
    end
func_RSA=@opti; 


end

