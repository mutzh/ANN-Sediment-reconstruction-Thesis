%prediction and integration with the chosen networks on the older data,
%where only annual sediment data exists

%input vector with our daily old Q values
load('data_ANN1_old.mat')


input_test_old=data_ANN1_old_nogaps;



%mynets is a matrix containing the hyperparameters of my best candidate
%networks, with each row representing one network
mynets=[48,6,10,10
        237,1,21,9
        308,2,21,9
        212,2,21,9
        131,2,21,9
        142,2,21,9
        328,7,6,44];
      
%use nets to predict
output_test_old=use_ANN(mynets,input_test_old);

%umrechnen von [kg/15min] auf [t/day]
output_test_old=output_test_old.*(96*10^-3); 


%finally integrate to compare with older annual load 1956-1970. this will yield
%matrix where the colums represent the different networks and the rows represent the
%prediction of the annual load. use the following function:
%[annual_errors]=integrate_over_years(number_of_years, leap_year_indices, network_output)
%leap_years=[2,6,10,14,18,22,26,30,34]; for all old data
%leap_years=[1,5,9]; for gap free old data
predicton_annual_load=integrate_over_years(10,[1,5,9],output_test_old);
%predicton_annual_load=mean(predicton_annual_load,2); funny idea: take the mean of a
%couple networks, to be a better prdictor, similar to random forest regression
actual_annual_load=Fracht_ing_alt(1:10);
annual_error_absolute=abs(predicton_annual_load-actual_annual_load);
annual_error_relative=annual_error_absolute./actual_annual_load;
mean_error_relative=mean(annual_error_relative);



%use mean of the training data ANN1 to predict, to see if our models outperform it...mean_s= mean(TARGET)
load('ANN1');
targ=ANN1(:,2);
mean_s=mean(targ);
mean_s=mean_s*(96*10^-3); %einheitenumrechnung
mean_s_annual=365.25*mean_s; % this is obviously kind of an approximation, but that's okay in this context
annual_error_abs_s=abs(actual_annual_load-mean_s_annual);
annual_error_relative_s=annual_error_abs_s./actual_annual_load;
mean_error_relative_s=mean(annual_error_relative_s);


%BAR GRAPH to visualize the mean relative error of nets and mean. the mean is purple
y=[mean_error_relative,mean_error_relative_s];
figure
b=bar(y);
b.FaceColor = 'flat';
b.CData(end,:) = [.5 0 .5];
title('mean relative error over the 10 years, nets and mean');

%create corresponding datetime vector
t1 = datetime(1931,01,01);
t2 = datetime(1965,12,31);
datetime_test_on_old= t1:caldays(1):t2;
datetime_test_on_old=datetime_test_on_old';