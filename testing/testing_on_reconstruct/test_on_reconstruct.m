%test on reconstruct
%in order to properly execute this fuction, you have to be in the folder that
%contains the networks...usually "explicitly_saved_nets"

%1) load data
load('ANN2_reconstruct.mat');
input_reconstruct=ANN2_reconstruct(:,1);
load('ANN2_train.mat');

%2) used Predictors: nets and mean
%nets that we are going to test. they were trained using the ANN2_train
mynets=[48,6,10,10
        67,1,18,5
        101,1,18,5
        300,1,18,5
        317,1,18,5
        501,1,18,5
        734,1,18,5
        823,1,18,5
        863,1,18,5
        997,1,18,5];
    
%%calculate mean sediment from training data and data that is being reconstructed by the nets for comparisons
MEAN_train=mean(ANN2_train(:,2));
MEAN_reconstruct=mean(ANN2_reconstruct(:,2));



    
   
%3) load networks and calculate outputs
output_reconstruct=use_ANN(mynets,input_reconstruct);
output_reconstruct(:,end+1)=MEAN_train; % append mean_train to the output matrix
output_reconstruct(:,end+1)=MEAN_reconstruct; % append mean_reconstruct to the output matrix


%4)BAR GRAPH TO COMPARE NETS AND MEAN OF TRAINING DATA
%if this doesnt work, restart matlab

disp('this is the cumulated sediment. For this, the mean of the training data seems to be a better predictor than our networks');
Summe=sum(output_reconstruct);
Summe=Summe';

amount_of_nets=size(mynets,1);
x = 1:amount_of_nets;
x_append=["mean train","observed"];
x=categorical([x,x_append]);



b=bar(x,Summe);
title('relative comparison cumulated sediment, nets and mean as predictor')
b.FaceColor = 'flat';
b.CData(end,:) = [.5 0 .5];
b.CData(end-1,:) = [.5 0 .5];



%5) hydrograph to compare one of the network outputs with the observed data
%select one of the network outputs(here 1), and the observed data 
output=output_reconstruct(:,1);
observations=ANN2_reconstruct(:,2);

%construct datevec for "compare hydrographs"
t1 = datetime(1966,01,01);
t2 = datetime(1979,12,31);
datetime_vec_reconstruct= t1:caldays(1):t2;

%visualize
compare_hydrograph(output,observations,datetime_vec_reconstruct,[0 0.9e+6])
title('all values relative, scaling factor included for visualisation')


%6) also plot flow 
flow=input_reconstruct;
%scling for visualisation
flow=flow.*10^2;
plot(datetime_vec_reconstruct,flow,'black')




%7) cumulated sum to compare. this will be added to the plot from 5)
cumulated_output=cumsum(output);
cumulated_observations=cumsum(observations);
%scaling for the visualisation
cumulated_output=cumulated_output.*0.01;
cumulated_observations=cumulated_observations.*0.01;


yyaxis right
ylabel('output')
plot(datetime_vec_reconstruct,cumulated_observations,'green')

yyaxis right
ylabel('observations')
plot(datetime_vec_reconstruct,cumulated_output,'magenta')





legend({'observed','output','flow','sumObs','sumOut'},'Location','North','NumColumns',5)


