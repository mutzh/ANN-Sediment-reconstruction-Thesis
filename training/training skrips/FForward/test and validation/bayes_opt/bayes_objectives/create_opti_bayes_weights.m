function [func_bayesopt]=create_opti_bayes_weights(ANN1) %außere funktion die die daten reinlädt und ein function handle aus der inneren erstellt
    function [nse_used]=opti(NEURONS)  %objective function, bzw zu optimierende function
    % if NEURONS2 =0 we only have one HL, therefore we only need two
    % TFs! bayesopt() will still give a third transfer function to our
    % objective function here, but our objective function wont use it.
    % when giving back the best results, bayesopt will still show a
    % third TF, BUT we can igore it.
    
    
    
    %Der input vector "NEURONS" enthält die zu optimierenden hyperparameter, welche
    %der bayesopt ausprobiert und an unsere objective function übergibt um sie zu
    %evaluieren
    NEURONS1=NEURONS.NEURONS1;
    NEURONS2=NEURONS.NEURONS2;
    TF1=NEURONS.TF1;
    TF2=NEURONS.TF2;
    TF3=NEURONS.TF2;
%     WB=NEURONS.WB;
    

   


    rng(5);
    no_divisions=10;
    no_evaluations=1;
%     mse_evaluations_list=zeros(no_evaluations,1);
%     mse_divisions_list=zeros(no_divisions,1);
    
    nse_evaluations_list=zeros(no_evaluations,1);
    nse_divisions_list=zeros(no_divisions,1);
    
    division_matrix=zeros(no_divisions,no_evaluations); 
    for i=1:no_evaluations
        
        INPUT=ANN1(:,1);
        TARGET=ANN1(:,2);
        for division=1:no_divisions
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
            INPUT(1)=[];
            TARGET(1)=[];
            net.divideFcn='divideint';
            net.divideParam.trainRatio=.70;
            net.divideParam.valRatio=.15;
            net.divideParam.testRatio=.15;
            
            net.trainParam.epochs=30;
            net.trainParam.showWindow = 0;
            net.performParam.normalization='standard'; %normalization
            net.trainParam.max_fail=4;
            
            %loop um den mean mehrerer evaluationen desselben netzwerkes mit verschiedenen
            %initial weights zu bilden.
            %benutzt wird der mittlere mse von test und validation set
            
            [net,tr] = train(net,INPUT',TARGET');
            
            output = net(INPUT');
            
            targetd=TARGET';
            
%             %calculate mean between testset mse and valset mse : mse_v_and_ts
%             
%             tsTarg = targetd(tr.testInd);
%             tsOut = output(tr.testInd);
%             Ts_e=tsTarg-tsOut;
%             Ts_ferp=mse(Ts_e);
%             
%             %calculate mean between testset mse and valset mse : mse_v_and_ts
%             vTarg = targetd(tr.valInd);
%             vOut = output(tr.valInd);
%             V_e=vTarg-vOut;
%             V_ferp=mse(V_e);
%             
%             mse_v_ts=(Ts_ferp+V_ferp)*0.5;
%             mse_divisions_list(division,1)=mse_v_ts;
            


%             calculate mean between testset nse and valset nse: nse_v_and_ts
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
            
                    nse_v_ts=(Ts_nse+v_nse)*0.5;
                    nse_divisions_list(division,1)=(-1)*nse_v_ts;
        end
        nse_divisions_mean=mean(nse_divisions_list);
        nse_evaluations_list(i,1)=nse_divisions_mean;
        
%         mse_divisions_mean=mean(mse_divisions_list);
%         mse_evaluations_list(i,1)=mse_divisions_mean;
        division_matrix(:,i)=nse_divisions_list; %switch between mse and nse here
    end
% %     %mean bilden um zu sehen wie gut die einzelnen data divisions im schnitt sind
% %     division_matrix_mean=mean(division_matrix,2); %switch between mse and nse here
% %     disp(division_matrix_mean);
% %     
    nse_used=(mean((nse_evaluations_list)));
%     mse_used=(mean((mse_evaluations_list)));
    %man könnte anstatt mean() auch min() ausprobieren
    
    end
func_bayesopt=@opti; % erstellen eines function handle um dieses an bayesopt zu übergeben
    
end

