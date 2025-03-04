clear all

close all
clc





%was diese version von der unterscheidet die du mir geschickt hast:
%alles unn�tige rausgel�scht
%net.performParam.normalization='standard'   also normalisierung von [-1,1]
%eine waitbar die einem den fortschritt der "nrun" schleife anzeigt
%PBIAS als model evaluation parameter hinzugef�gt
%weniger validation checks
%divideint
%rng(0)
%epochs =30
%max validation fails=4




%initialize waitbar to track progress without much slowing
wb=waitbar(0,'Iterating...');
set(wb,'Name', 'training Networks');

% hier musst du dann deinen Input einf�gen.
load('ANN1')
ANN3=ANN1;
INPUT=ANN3(:,1);
TARGET=ANN3(:,2);


% % % %take out outliers
% % % B=INPUT>150;
% % % INPUT=INPUT(B);
% % % TARGET=TARGET(B);


INPUT(1)=[];
TARGET(1)=[];



%compute mean to later compare our models to it..
mean(TARGET);
sigma_TARGET=std(TARGET);
% % % % % % % % % % % % % % disp('the standard deviation of our observed sediment data is:')
% % % % % % % % % % % % % % disp(sigma_TARGET);
% % % % % % % % % % % % % % disp('according to singh et al. (2004) and RMSE of half that S.D. is considered low!')



nTF=[5]; % kombinationen der Transferfunction
% anzahl der neuronen im 1 hidden layser
hiddenLayerSize =[11];
% wenn gr��er 0, dann gibt es einen 2. hidden layer mit entsprechender
% anzahl von neuronen
secondhiddenLayerSize=[11];
% anzahl wie oft jede kombination trainiert werden soll. Vielleciht beim
% ersten mal nur wenige versuche und schauen was f�r ein ergebnis
% rauskommt.
nrun=1;
%times to repeat the whole process in order to get statistical significance up!
repetitions=1;

% % %  %control rng
%     rng(2);



%start timer
tic;

for rep=1:repetitions
    z_TF_OL_Checking=[];
    %---------------DESIRED TIME OF RUN-----------------------------------------------------------------------------------------
    for z=1:nrun
%         rng(z)
        %----------------END----------------------------------------------------------------------------------
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Prefix'F' means final of each
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% property
        %%%%To store thing which run during whole simulation process%%%
        TF_OL_Checking=[];
        %%FF means function final output
        FBest_Solution=[];
        FBest_output=[];
        
        %--------------------------SELECT TRANSFER FUNCTION---------------------------------------------------------------------
        %%%functions. total transfer function are 7.
        for TF=nTF;  %1:7;
            %--------------------------END------------------------------------------------------------------------------
            OL_Checking=[];
            kk=0;
            for ANNRT=1:1
                
                
                %                 ppsc=2* round((numneu)^.5) +1;
                %                 fpsc=2*(numneu) + 1;
                %---------------SELECTION OF NEURONS IN HIDDEN LAYERS DEFINED BY--------------------------------------------------------------------------------------------
                %Fletcher, D., and Goss, E., "Forecasting with neural networks: an application using bankruptcy data", Information & Management, 24(3), 159-167; 1993.
                for NEURONS = hiddenLayerSize %ppsc:fpsc %1 JUST FOR TEST
                    if NEURONS ==0
                        NEURONS=1
                    end
                    for NEURONS2=secondhiddenLayerSize
                        %                             targetd=cell2mat(Y(FEEDBACKDELAYS+1:end));
                        
                        kk=kk+1;
                        %%
                        %%the value inbetween two this '%%' lines is just for checking and
                        %%cross validation purpose of programme (written code), k denote that
                        %%parameter belong to counter cheking operation
                        NN_hiddenlayer(kk)=NEURONS; %%%number of neurons in hidden layer%%this is only for checking and validation
                        
                        TF_Used(kk,:)=[TF]; %%tansfer function used.
                        %%
                        %%%%% use following training functions in loop
                        %                 for trainf=1:3
                        %                     if trainf==1
                        %                         net.trainFcn='trainlm'
                        %                     end
                        
                        
                        %%trainlm
                        %%trainbfg
                        %%trainrp
                        %         net = feedforwardnet([layer1]);
                        % DM: NEURONS= anzahl der neuronen im 1 hidden layer NEURONS2=anzahl der neuronen im 2tn hidden layer wenn NEURONS2 gr��er 0 dann gibt es einen 2tn hidden layer
                        % sonst nicht
                        
                        if NEURONS2 >0
                            net = feedforwardnet([NEURONS NEURONS2]);
                        else
                            net = feedforwardnet([NEURONS]);
                        end
                        
                        net.trainParam.showWindow = 1;   % <== This does it
                        %%with different transfer functions DM: wenn du das
                        %%training fesnter sehen magst musst die zeile
                        %%kommentieren %
                        if TF==1
                            net.layers{1}.transferFcn='tansig';
                            net.layers{2}.transferFcn='tansig';
                            if NEURONS2 >0
                                net.layers{1}.transferFcn='tansig';
                                net.layers{2}.transferFcn='tansig';
                                net.layers{3}.transferFcn='tansig';
                            end
                        end
                        if TF==2
                            net.layers{1}.transferFcn='logsig';
                            net.layers{2}.transferFcn='tansig';
                            if NEURONS2 >0
                                net.layers{1}.transferFcn='tansig';
                                net.layers{2}.transferFcn='tansig';
                                net.layers{3}.transferFcn='purelin';
                            end
                            
                        end
                        if TF==3
                            net.layers{1}.transferFcn='radbas';
                            net.layers{2}.transferFcn='purelin';
                            if NEURONS2 >0
                                net.layers{1}.transferFcn='tansig';
                                net.layers{2}.transferFcn='logsig';
                                net.layers{3}.transferFcn='tansig';
                            end
                        end
                        if TF==4
                            net.layers{1}.transferFcn='logsig';
                            net.layers{2}.transferFcn='logsig';
                            if NEURONS2 >0
                                net.layers{1}.transferFcn='tansig';
                                net.layers{2}.transferFcn='logsig';
                                net.layers{3}.transferFcn='purelin';
                            end
                        end
                        if TF==5
                            net.layers{1}.transferFcn='tansig';
                            net.layers{2}.transferFcn='tansig';
                            if NEURONS2 >0
                                net.layers{1}.transferFcn='logsig';
                                net.layers{2}.transferFcn='tansig';
                                net.layers{3}.transferFcn='tansig';
                            end
                        end
                        if TF==6
                            net.layers{1}.transferFcn='tansig';
                            net.layers{2}.transferFcn='tansig';
                            if NEURONS2 >0
                                net.layers{1}.transferFcn='logsig';
                                net.layers{2}.transferFcn='tansig';
                                net.layers{3}.transferFcn='purelin';
                            end
                        end
                        if TF==7
                            net.layers{1}.transferFcn='tansig';
                            net.layers{2}.transferFcn='tansig';
                            if NEURONS2 >0
                                net.layers{1}.transferFcn='logsig';
                                net.layers{2}.transferFcn='logsig';
                                net.layers{3}.transferFcn='tansig';
                            end
                        end
                        if TF==8
                            net.layers{1}.transferFcn='tansig';
                            net.layers{2}.transferFcn='tansig';
                            if NEURONS2 >0
                                net.layers{1}.transferFcn='logsig';
                                net.layers{2}.transferFcn='logsig';
                                net.layers{3}.transferFcn='purelin';
                            end
                        end
                        
                        %--------------------------DATA DIVISION------------------------------------------------------------------------------------------------------------------
                        
                        %                     rng(1);
                        net.divideFcn='dividerand';
                        net.divideParam.trainRatio=.70;
                        net.divideParam.valRatio=.15;
                        net.divideParam.testRatio=.15;
                        
                        
                        net.trainParam.epochs=30;
                        net.performParam.normalization='standard';
                        net.trainParam.max_fail=4;
                        
                        %                     net.inputs{1}.processFcns={'mapstd'};
                        %                     net.outputs{3}.processFcns={'mapminmax'};
                        %                      net.outputs{3}.processFcns={'mapstd'};
                        %                       net.outputs{3}.processFcns={};
                        
                        rng(z);
                        [net,tr] = train(net,INPUT',TARGET');
                        
                                             plotfit(net,INPUT',TARGET')
                        
                        %-------------------------END OF DATA DIVISION---------------------------------------------------------------------------------------------------------------
                        %-------------------------SAVE RESULTS-------------------------------------------------------------------------------------------------------------------
                        zQTFlater2level(kk,:)=[z TF NEURONS  NEURONS2 ];
                        zQTFlater1=[sprintf('_%d') num2str(z) sprintf('_%d') num2str(TF) sprintf('_%d') num2str(NEURONS) sprintf('_%d') num2str(NEURONS2)];
                        filename = sprintf('net%s.mat',zQTFlater1);
                        
                        save(fullfile(pwd,'\save_nets\', filename ), 'net');
                        %--------------------------END TO SAVE RESULTS------------------------------------------------------------------------------------------------------------------
                        output = net(INPUT');
                        
                        
                        targetd=TARGET';
                        
                        %%%%overall%%%%
                        e=[targetd-output]; %%to calculate over all error
                        
                        O_PBIAS=sum(e*100)/sum(TARGET);
                        ferp=mse(e); %%%%RMSE of ANN output and target
                        RMSE_1=(ferp)^.5;
                        %%
                        O_RMSE_k(kk)=RMSE_1;
                        
                        %%%%For calculation of mean absolute error
                        %%the value inbetween two this '%%' lines is just for checking and cross validation purpose
                        MAE_1=mae(e);
                        %%
                        O_MAE_k(kk)=MAE_1;
                        %%
                        O_PBIAS_k(kk)=O_PBIAS;
                        %%
                        
                        trOut = output(tr.trainInd);
                        vOut = output(tr.valInd);
                        tsOut = output(tr.testInd);
                        trTarg = targetd(tr.trainInd);
                        vTarg = targetd(tr.valInd);
                        tsTarg = targetd(tr.testInd);
                        
                        
                        %%%%for testing%%%
                        Ts_e=tsTarg-tsOut;
                        Ts_PBIAS=sum(Ts_e*100)/sum(TARGET);
                        Ts_ferp=mse(Ts_e);
                        Ts_RMSE=(Ts_ferp)^.5;
                        %%
                        Ts_RMSE_k(kk)=Ts_RMSE;
                        %%
                        Ts_MAE=mae(Ts_e);   %%%% mean absolute error
                        %%
                        Ts_MAE_k(kk)=Ts_MAE;
                        %%
                        Ts_PBIAS_k(kk)=Ts_PBIAS;
                        
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %%%%%for training%%%%%
                        Tr_e=trTarg-trOut;
                        Tr_ferp=mse(Tr_e);
                        Tr_RMSE=(Tr_ferp)^.5;
                        %%
                        Tr_RMSE_k(kk)=Tr_RMSE;
                        %%
                        Tr_MAE=mae(Tr_e);
                        %%
                        Tr_MAE_k(kk)=Tr_MAE;
                        
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %%%%%for validation%%%%%%%%%
                        
                        V_e=vTarg-vOut;
                        V_PBIAS=sum(V_e*100)/sum(TARGET);
                        V_ferp=mse(V_e);
                        V_RMSE=(V_ferp)^.5;
                        %%
                        V_RMSE_k(kk)=V_RMSE;
                        %%
                        V_MAE=mae(V_e);
                        %%
                        V_MAE_k(kk)=V_MAE;
                        %%
                        V_PBIAS_k(kk)=V_PBIAS;
                        
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        Training(NEURONS)=regression(trTarg,trOut);
                        Tr_R=Training(NEURONS);
                        %%
                        Tr_R_k(kk)=Tr_R;
                        %%
                        Testing(NEURONS)=regression(tsTarg,tsOut);
                        Ts_R=Testing(NEURONS);
                        %%
                        Ts_R_k(kk)=Ts_R;
                        %%
                        Validation(NEURONS)=regression(vTarg,vOut);
                        V_R=Validation(NEURONS);
                        %%
                        V_R_k(kk)=V_R;
                        
                        %%formula for regression
                        target_STATISTIC=reshape(targetd',[],1);
                        target_STATISTIC=target_STATISTIC';
                        output_STATISTICS=reshape(output',[],1);
                        output_STATISTICS=output_STATISTICS';
                        [r(NEURONS),m(NEURONS),b(NEURONS)]=regression(target_STATISTIC,output_STATISTICS); %for regression
                        %%%over all regression%%%
                        O_R=r(NEURONS);
                        %%
                        O_R_k(kk)=O_R;
                        
                        %%%%NSE train
                        Tr_diff=trTarg-trOut;
                        Tr_mean_observed_diff=trTarg-mean(trTarg);
                        Tr_nse_k(kk)=1-(sum(Tr_diff.^2)/(sum(Tr_mean_observed_diff.^2)));
                        %%%%NSE test
                        Ts_diff=tsTarg-tsOut;
                        Ts_mean_observed_diff=tsTarg-mean(tsTarg);
                        Ts_nse_k(kk)=1-(sum(Ts_diff.^2)/(sum(Ts_mean_observed_diff.^2)));
                        %%%%NSE Overall
                        diff=target_STATISTIC-output_STATISTICS;
                        mean_observed_diff=target_STATISTIC-mean(target_STATISTIC);
                        O_nse_k(kk)=1-(sum(diff.^2)/(sum(mean_observed_diff.^2)));
                        %DM: felder des ascending_z_TF_OL_CHECKING arrays der
                        %in finalresults.mat gespeichert wird. TR= training,
                        %tS=testung usw..
                        Checking = [TF_Used  NN_hiddenlayer' Tr_R_k' Tr_RMSE_k' Tr_MAE_k' Ts_R_k' Ts_RMSE_k' Ts_MAE_k' V_R_k' V_RMSE_k' V_MAE_k' O_R_k' O_RMSE_k' O_MAE_k' Tr_nse_k' Ts_nse_k' O_nse_k'  Ts_PBIAS_k'  V_PBIAS_k' O_PBIAS_k' zQTFlater2level]; %%rearranged according to output result for easiness to compare the results
                    end
                end
                
                
                %%%%%Store the values afte completing one loop
                OL_Checking=[OL_Checking;Checking];
            end
            %%%%%Store After completion of Transfer Funciton Loop.
            TF_OL_Checking=[TF_OL_Checking;OL_Checking];
        end
        %%%%%Store After completion of z loop of one whole simulation set.
        z_TF_OL_Checking=[z_TF_OL_Checking;TF_OL_Checking];
        
        %----------------------------CHANGE BEST RESULT SELECTION CRITERIA----------------------------------------------------------------------------------------------------------------
        Ascending_z_TF_OL_Checking=sortrows(z_TF_OL_Checking,7);
        %-----------------------------END SELECTION CRITERIA---------------------------------------------------------------------------------------------------------------
        
        
        
    end
    %waitbar
    waitbar(rep/repetitions)
    
    
    
    repe=num2str(rep);
    filename = strcat('finalresults',repe,'.mat');
    save(fullfile(pwd,'\save_net\',filename ),'Ascending_z_TF_OL_Checking')
end
toc;
%delete waitbar
delete(wb)
