%please load " all relevant variables " before executing this skript


%create the following: data with smaller training set, so that we have daily semident values to reconstruct
%and compare with!!

%the training data is from the following timeframe: 01.01.1980-28.04.2017
%while the data we are trying to reconstruct will be from 01.01.1966-31.12.1979

%data that is going to be reconstructed
[Q_reconstruct, s_reconstruct]=adapt_frequency(zeitreihe_abfluss_stand(1227265:1718112), zeitreihe_value_stand_aufgeteilt(1227265:1718112),96);
ANN2_reconstruct=[Q_reconstruct, s_reconstruct];

[Q_INPUT, S_TARGET]=adapt_frequency(zeitreihe_abfluss_stand(1718113:end), zeitreihe_value_stand_aufgeteilt(1718113:end),96);
ANN2_train=[Q_INPUT, S_TARGET];

%3)create datetime vectors and plot everything

%reconstruct, these dates are actually representative of the data, since there arent
%any gaps in the flow or sediment
t1 = datetime(1966,01,01);
t2 = datetime(1979,12,31);
datetime_vec_reconstruct= t1:caldays(1):t2;

%train
t1 = datetime(1931,01,01);
t2 = datetime(1966,04,29);
datetime_vec_train= t1:caldays(1):t2;


%here you can plot flow and sediment: 
%either the reconstructed or the training set, depending on which vectors you give to the plot functions

figure
title('data 1')
hold all

yyaxis right
ylabel('abfluss')
plot(datetime_vec_train,Q_INPUT)


yyaxis left
ylabel('sediment')
plot(datetime_vec_train,S_TARGET)



