function []=compare_hydrograph(output,target,date_vec,yRange)

%!!!!!!!!!!!!!!!!!!   this function need the "zoom package" folder in order to work    !!!!!!!!!!!!!!!!!!

% on the left axis we have the OUTPUT of the neural network, on the right the TARGET
%date_vec is some datetime vector, which we use to get a plot. the datetimes dont
%have to be correct
%yRange is a 1x2 row vector, which gives the range for the y axes

% %this datetime vec is not the right on, just a help to plot
% t1 = datetime(1931,01,01);
% %t2 for the testset
%     %t2 = datetime(1938,5,25);
% %t2 for all of the network data: training, validation and testing
%     t2 = datetime(1980,04,28);
% %t2 for the gap free historic data 
%     %t2=datetime(1940,12,31);
% %the datetime vec for reconstruct is gernerated in the skript " dataANN2_"


figure
title('data 1')



yyaxis left
%ylim(yRange)
ylabel('observations')
plot(date_vec,target)



yyaxis right
ylim(yRange)
ylabel('output')
plot(date_vec,output)

hold on

h = zoom;
% Listen to zoom events.
set(h, 'ActionPreCallback', @saveAxisStatus);
set(h, 'ActionPostCallback', @zoomSecondAxis);
set(h, 'Enable', 'on');
end


