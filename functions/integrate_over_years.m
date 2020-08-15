%function that intrgrates the output data of a network over the years to compare
%daily  predicted sediiment values[t/d] values with the annual load[t]

%leap year indices has to be a row vector, number_of_years an integer, network_output
%a matrix with the number of rows = number of data points
function [annual_loads]=integrate_over_years(number_of_years, leap_year_indices, network_output)


annual_loads=[];
w=1;
for i = 1:number_of_years %35for all old data, 10 for gap free old data
    
    if ismember(i,leap_year_indices)%check if the year is a leap year(366 days)
        prediction_annual_load=sum(network_output(w:w+365,:));
        w=w+366;
    else
        prediction_annual_load=sum(network_output(w:w+364,:));
        w=w+365;
    end
    annual_loads(end+1,:)=prediction_annual_load;
end
end

