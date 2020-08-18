%analyze whole testset 
load('data_NarxN');
testset_inputs=data_NarxN(1:2809,1)';
testset_observations=data_NarxN(1:2809,2)';







%1) calculate network output from input data, we need to be in the folder that contains
%the net, so that it can be loaded from that folder!!!


testset_predictions=SRC_function(testset_inputs);


%2) construct datevec (not representative, for plotting purposes only)
t1 = datetime(1966,01,01);
t2 = datetime(1973,09,09);
date_vec_testset= t1:caldays(1):t2;
date_vec_testset=date_vec_testset';



%3) plot the hydrographs
yRange=[0 4.5e+5];

%compare the hydrographs of observation and prediction
compare_hydrograph(testset_predictions,testset_observations,date_vec_testset,yRange)


%4) cumulated sediment scaling factor for the visualisation included
cumulated_output_wholeset=cumsum(testset_predictions).*0.01;
cumulated_observations_wholeset=cumsum(testset_observations).*0.01;

plot(date_vec_testset,cumulated_observations_wholeset,'green')
plot(date_vec_testset,cumulated_output_wholeset,'magenta')



%6) also plot flow 
flow=testset_inputs;
%scling for visualisation
flow=gmultiply(flow(:),2e+1);
plot(date_vec_testset,flow,'black')
legend({'observed','output','sumObs','sumOut','flow'},'Location','North','NumColumns',5)


%6)BAR GRAPH TO COMPARE NETS AND MEAN OF TRAINING DATA
%cut out NaN in order to take a sum
nan=~isnan(testset_predictions);
testset_predictions=testset_predictions(nan);


nan=~isnan(testset_observations);
testset_observations=testset_observations(nan);


Summe_pred=sum(testset_predictions,2);
Summe_obs=sum(testset_observations,2);
Summe=[Summe_pred, Summe_obs]
Summe=Summe';



figure
bar(Summe)
title('comparison cumulated sediment')


%7) calculate relative testset error
e=abs(Summe(1)-Summe(2));
e=e/Summe(2);
e=e*100;
disp('The cumulative error relative to the actual sum in [%] is:');
disp(e);


