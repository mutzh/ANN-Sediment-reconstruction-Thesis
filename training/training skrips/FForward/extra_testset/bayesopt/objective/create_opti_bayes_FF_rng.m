function [func_bayesopt]=create_opti_bayes_FF_rng(data_NarxN) %außere funktion die die daten reinlädt und ein function handle aus der inneren erstellt
    function [NSE]=opti(NEURONS)  %objective function, bzw zu optimierende function
    
    test_set_input=data_NarxN(1:2809,1)';
    test_set_target=data_NarxN(1:2809,2)';
    INPUT=data_NarxN(2810:end,1)';
    TARGET=data_NarxN(2810:end,2)';
    
    %Der input vector "NEURONS" enthält die zu optimierenden hyperparameter, welche
    %der bayesopt ausprobiert und an unsere objective function übergibt um sie zu
    %evaluieren
    NEURONS1=NEURONS.NEURONS1;
    NEURONS2=NEURONS.NEURONS2;
    TF1=NEURONS.TF1;
    TF2=NEURONS.TF2;
    TF3=NEURONS.TF3;
    SEED=NEURONS.SEED;
    
    rng(SEED);
    
    
    net = feedforwardnet([NEURONS1 NEURONS2]);
    
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
%     INPUT(1)=[];
%     TARGET(1)=[];
    net.divideFcn='dividerand';
    net.divideParam.trainRatio=825/1000;
    net.divideParam.valRatio=175/1000;
    net.divideParam.testRatio=0;
    
    
    %loop um den mean mehrerer evaluationen desselben netzwerkes mit verschiedenen
    %initial weights zu bilden.
    %benutzt wird der mittlere mse von test und validation set
    
    [net] = train(net,INPUT,TARGET);
    
    output = net(test_set_input);

    [NSE] = -(ns_efficiency(test_set_target,output));
%     [r,m,b] = regression(tc,yc)
    
   
    end
func_bayesopt=@opti; % erstellen eines function handle um dieses an bayesopt zu übergeben

end

