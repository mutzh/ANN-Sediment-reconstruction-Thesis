function [func_bayesopt]=create_opti_bayes_NARX_noise(data_NarxN) %außere funktion die die daten reinlädt und ein function handle aus der inneren erstellt
    function [NSE]=opti(NEURONS)  %objective function, bzw zu optimierende function
    
   
    test_set_input=data_NarxN(1:2809,1)';
    test_set_target=data_NarxN(1:2809,2)';
    INPUT=data_NarxN(2810:end,1)';
    TARGET=data_NarxN(2810:end,2)';
    
    
    test_set_input=tonndata(test_set_input,true,false);
    test_set_target=tonndata(test_set_target,true,false);
    INPUT = tonndata(INPUT,true,false);
    TARGET = tonndata(TARGET,true,false);
    
    
    %Der input vector "NEURONS" enthält die zu optimierenden hyperparameter, welche
    %der bayesopt ausprobiert und an unsere objective function übergibt um sie zu
    %evaluieren
    
    %MAL SEHEN OB WIR NICHT EVENTUELL DOCH AUF EINEN HIDDEN LAYER UMNSTEIGEN
    NEURONS1=NEURONS.NEURONS1;
    NEURONS2=NEURONS.NEURONS2;
    TF1=NEURONS.TF1;
    TF2=NEURONS.TF2;
    TF3=NEURONS.TF3;
    ID=NEURONS.ID;
    FD=NEURONS.FD;
  
    
    
    
    
    
    inputDelays = 0:ID;
    feedbackDelays = 1:FD;
    hiddenSizes = [NEURONS1,NEURONS2] ; 
    trainFcn = 'trainlm';
    
    
    net = narxnet(inputDelays,feedbackDelays,hiddenSizes,'open',trainFcn);
    
    net.trainParam.epochs=40;
    net.trainParam.showWindow = 0;
    net.performParam.normalization = 'standard'; %normalization
    net.trainParam.max_fail=4;
    
     
    %aufteilen der daten mit divideint um immer dieselbe aufteilung zu erreichen und
    %damit den stochasitschen charakter unserer ANN objective function ausschalten
%     INPUT(1)=[];
%     TARGET(1)=[];
    net.divideMode = 'time';
    net.divideFcn = 'dividerand';
    net.divideParam.trainRatio=.825;
    net.divideParam.valRatio=.175;
    net.divideParam.testRatio=.0;
    
    
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
    yc = netc(xc,xic,aic);
    %     closedLoopPerformance = perform(net,tc,yc);
    [NSE] = -(ns_efficiency(cell2mat(tc),cell2mat(yc)));
%     [r,m,b] = regression(tc,yc)
    

    end 
func_bayesopt=@opti; % erstellen eines function handle um dieses an bayesopt zu übergeben

end

