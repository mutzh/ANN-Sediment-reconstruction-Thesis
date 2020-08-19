%analyze whole testset 
load('ANN1');
wholeset_inputs=ANN1(:,1)';
wholeset_observations=ANN1(:,2)';




%1) calculate network output from input data, we need to be in the folder that contains
%the net, so that it can be loaded from that folder!!!


wholeset_predictions=SRC_function(wholeset_inputs);


%2) construct datevec (not representative, for plotting purposes only)
t1 = datetime(1931,01,01);
t2 = datetime(1980,04,28);
date_vec_wholeset= t1:caldays(1):t2;
% date_vec_wholeset=date_vec_wholeset';



%3) plot the hydrographs
yRange=[0 4.5e+6];
compare_hydrograph(wholeset_predictions,wholeset_observations,date_vec_wholeset,yRange)


%4) cumulated sediment scaling factor for the visualisation included
cumulated_output_wholeset=cumsum(wholeset_predictions).*0.01;
cumulated_observations_wholeset=cumsum(wholeset_observations).*0.01;

plot(date_vec_wholeset,cumulated_observations_wholeset,'green')
plot(date_vec_wholeset,cumulated_output_wholeset,'magenta')



%6) also plot flow 
flow=wholeset_inputs;
%scling for visualisation
flow=flow.*10^2;
plot(date_vec_wholeset,flow,'black')
legend({'observed','output','sumObs','sumOut','flow'},'Location','North','NumColumns',5)


%6)BAR GRAPH TO COMPARE NETS AND MEAN OF TRAINING DATA

nan=~isnan(wholeset_predictions);
wholeset_predictions=wholeset_predictions(nan);


nan=~isnan(wholeset_observations);
wholeset_observations=wholeset_observations(nan);


Summe_pred=sum(wholeset_predictions,2);
Summe_obs=sum(wholeset_observations,2);
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


