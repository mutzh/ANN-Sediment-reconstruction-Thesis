function [opti_func]=GA_objectives(ANN1)  %außere funktion die die daten reinlädt und ein function handle aus der inneren erstellt
    function [Y]=opti(X)   %objective function, bzw zu optimierende function

    INPUT=ANN1(:,1);
    TARGET=ANN1(:,2);

    %Der input vector "X" enthält die zu optimierenden hyperparameter, welche
    %der GA ausprobiert und an unsere objective function übergibt
    X1=X(1);
    X2=X(2);
    TF1=X(3);
%     TF2=X(4);
%     TF3=X(5);
     
    no_evaluations=1; %gibt an wie oft jedes network design trainiert wird um später daraus den mean zu bilden
    mse_list=zeros(no_evaluations,1);%preallocate
    nse_list=zeros(no_evaluations,1);%preallocate
    
    


    
    %um den TF code zu verstehen muss man folgendes wissen: es kommen als output
    %layer TF nur 'tansig' und 'purelin' infrage, weil ich als
    %net.performParam.normalization == 'standard' verwende, was bedeutet, dass der
    %output auf ]-1,1[ normalisiert wird. Der wertebereich von 'logsig' ist ]0,1[ und bei
    %der 'radbas' konnte ich es nicht herausfinden, doch die hat sich in tests eindeutig nicht
    %beweisen können
    
   if X2 >0
      net = feedforwardnet([X1 X2]);
   else
        net = feedforwardnet(X1);
   end
    
   net.trainParam.showWindow = 0;
   
   net.layers{1}.transferFcn='tansig';
   net.layers{2}.transferFcn='tansig';
   
   if X2>0
   net.layers{3}.transferFcn='tansig';
   end
%    
%    if TF1==1
%        net.layers{1}.transferFcn='tansig';
%    elseif TF1==2
%        net.layers{1}.transferFcn='logsig';
%    elseif TF1==3
%        net.layers{1}.transferFcn='radbas';
%    end
%        
%    if X2 >0
%        if TF2==1
%            net.layers{2}.transferFcn='tansig';
%        elseif TF2==2
%            net.layers{2}.transferFcn='logsig';
%        elseif TF2==3
%            net.layers{2}.transferFcn='radbas';
%        end
%    elseif X2==0
%        if TF2==1
%            net.layers{2}.transferFcn='tansig';
%        elseif TF2==2
%            net.layers{2}.transferFcn='tansig';  %tansig is used twiced because we need 3 TF to not get an error when X2==0
%        elseif TF2==3
%            net.layers{2}.transferFcn='purelin';
%        end
%    end
%    
%    
%    if X2 >0
%        if TF3==1
%            net.layers{3}.transferFcn='tansig';
%        elseif TF3==2
%            net.layers{3}.transferFcn='purelin';
%        end
%    end
%    
   
 net.performParam.normalization='standard'; %normalization  
       
%loop die den mean(mse) und mean(nse) aus mehreren netzwerken bildet
%der mse ist hier der mittelwert aus dem testset und dem validation set und 
%nimmt an dass die beiden sets gleich groß sind
   for i=1:no_evaluations   
    net.divideFcn='dividerand';
    net.divideParam.trainRatio=.70;
    net.divideParam.valRatio=.15;
    net.divideParam.testRatio=.15;
    
    [net,tr] = train(net,INPUT',TARGET');
    output = net(INPUT');
    targetd=TARGET';
    
    %calculate mean between testset mse and valset mse : mse_v_and_ts
    tsTarg = targetd(tr.testInd);
    tsOut = output(tr.testInd);
    Ts_e=tsTarg-tsOut;
    Ts_mse=mse(Ts_e);
    
    
    vTarg = targetd(tr.valInd);
    vOut = output(tr.valInd);
    V_e=vTarg-vOut;
    V_mse=mse(V_e);
    
    
    mse_v_and_ts=(Ts_mse+V_mse)*0.5;
    mse_list(i,1)=mse_v_and_ts;
    
    %calculate mean between testset nse and valset nse: nse_v_and_ts
    Ts_diff=tsTarg-tsOut;
    Ts_mean_observed_diff=tsTarg-mean(tsTarg);
    Ts_nse=1-(sum(Ts_diff.^2)/(sum(Ts_mean_observed_diff.^2)));
    
    
    v_diff=vTarg-vOut;
    v_mean_observed_diff=vTarg-mean(vTarg);
    v_nse=1-(sum(v_diff.^2)/(sum(v_mean_observed_diff.^2)));
    
    nse_v_and_ts=(Ts_nse+v_nse)*0.5;
    nse_list(i,1)=nse_v_and_ts;
   end
    mse_used=mean(mse_list); 
    nse_used=mean(nse_list);
    nse_used=nse_used*(-1); % der NSE wird negativ genommen, damit die optimierung in die richtige richtung läuft
  
    Y=[mse_used,nse_used];
   end
opti_func=@opti; %erstellen des function handle
end

