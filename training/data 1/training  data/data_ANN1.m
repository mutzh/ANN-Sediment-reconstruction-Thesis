%INTENT:
%all availiable daily sediment values will be used along with daily Q
%values for training. Then we wiil try to reconstruct older daily sediment values
%(where we actually only have sparse data), using older daily Q values(which we have)

%the Q values that are already in a daily format are mean values not Q
%values according to GKD, so we will compute all other values as a mean as
%well to have a consistent data set

%as a basis we will use the Q vector:"zeitreihe_abfluss_stand" and the S
%vector "zeitreihe_value_stand_aufgeteilt"

%1) compile the daily Q values for donau ingolstadt (1966-2017), by
%calculating via mean() from 15 min values.
%these values are tasken from vectors that are standardized to 15 min
%intervalls, so that a daily value will show up as one value and 95 NaN.
%since the function "adapt_frequencies" cuts all NaN values out of each 96
%section, daily frequencies are not effected, because the mean of a scalar
%value equals that same skalar value. thus we can treat all the data with
%that one function.
%2) furthermore this skript will remove all datapoints that are missing (Q or S )from the Q data and thus
%leave in only datapoints that are viable training/testing data for the network
%3) plot the 2 means against a datetime vector to visualize and control for
%inconsistencies.
%the datetime vector has yet to be created. the dates are not correct but
%arbitrary...just random ones to plot against




%1) and 2)
[Q_INPUT, S_TARGET]=adapt_frequency(zeitreihe_abfluss_stand(1227265:end), zeitreihe_value_stand_aufgeteilt(1227265:end),96);
data_Q_S_1day=[Q_INPUT, S_TARGET];

%3)es lohnt sich nicht einen echten datetime vector zu machen, da lücken
%rausgeschnitten wurden

t1 = datetime(1931,01,01);
t2 = datetime(1980,04,28);
datetime_vec= t1:caldays(1):t2;

figure
title('data 1')
hold all

yyaxis right
ylabel('abfluss')
plot(datetime_vec,Q_INPUT)


yyaxis left
ylabel('sediment')
plot(datetime_vec,S_TARGET)



