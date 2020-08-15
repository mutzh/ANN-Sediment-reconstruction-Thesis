%analyze whole testset 
load('data_NarxN');
wholeset_inputs=data_NarxN(:,1)';
wholeset_observations=data_NarxN(:,2)';

wholeset_inputs = tonndata(wholeset_inputs,true,false);
wholeset_observations = tonndata(wholeset_observations,true,false);

no_delays=input('what the max(input delays, feedback delays)? [0:3] counts as 3 for some reason:   ');% % % 




%1) calculate network output from input data, we need to be in the folder that contains
%the net, so that it can be loaded from that folder!!!
wholeset_net=[1,1,1,13];

[wholeset_inputs_shifted,wholeset_predictions]=use_ANN_narx(wholeset_net,wholeset_inputs,wholeset_observations,no_delays);


%2) construct datevec (not representative, for plotting purposes only)
t1 = datetime(1931,01,01);
t2 = datetime(1982,04,11);
date_vec_wholeset= t1:caldays(1):t2;
date_vec_wholeset=date_vec_wholeset';
date_vec_wholeset=date_vec_wholeset((no_delays+1):end,:);


%3) plot the hydrographs
yRange=[0 4.5e+6];
%adapt the observations vector with the initial delays, to make it the same length as
%the predicted vector
wholeset_observations=wholeset_observations(:,(no_delays+1):end);
%compare the hydrographs of observation and prediction
compare_hydrograph([wholeset_predictions{:}],[wholeset_observations{:}],date_vec_wholeset,yRange)


%4) cumulated sediment scaling factor for the visualisation included
cumulated_output_wholeset=cumsum([wholeset_predictions{:}]).*0.02;
cumulated_observations_wholeset=cumsum([wholeset_observations{:}]).*0.02;

plot(date_vec_wholeset,cumulated_observations_wholeset,'green')
plot(date_vec_wholeset,cumulated_output_wholeset,'magenta')



%6) also plot flow 
flow=wholeset_inputs_shifted;
%scling for visualisation
flow=[flow{:}].*10^2;
plot(date_vec_wholeset,flow,'black')
legend({'observed','output','sumObs','sumOut','flow'},'Location','North','NumColumns',5)


%6)BAR GRAPH TO COMPARE NETS AND MEAN OF TRAINING DATA
%cut out NaN in order to take a sum
wholeset_predictions=[wholeset_predictions{:}];
nan=~isnan(wholeset_predictions);
wholeset_predictions=wholeset_predictions(nan);

wholeset_observations=[wholeset_observations{:}];
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
disp('some nets went as low as 0.18');

