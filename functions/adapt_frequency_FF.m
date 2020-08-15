function [v1_mean, v2_mean]=adapt_frequency(v1, v2, frequency_factor);

%frequency_factor is defined as desired duration(longer) divided by current
%underlying duration (shorter) e.g.: 24h/15 min=96

%function can be extended to more input features if needed later on

%it takes the vectors which are standardized to 15 min intervals and gives
%back for example values at a daily frequency.

%when there are only Nan in for example a 24h (96 values) window, no value
%can be calculated as the mean. this leads to a gap
%in order to train the network we must use datapoints where all input
%feastures, as well as the output have a value. this means if theres a gap
%in any of these, the datapoint will be excluded from the dataset used for
%the network

%the input vectors have to be of the same timeframe and same frequency(
%e.g.: both are from 01.01.1995-01.01.1997, and both have 15 min as the
%underlying frequency

%calculate number of values that play into calculating a mean, depending on
%the underlying and the desired frequency



l=length(v1);
i=1;
v1_mean=[];
v2_mean=[];
while i<l
    w=i+frequency_factor-1; %e.g.: w=1+96-1=96. then our section rnages from 1:96(1day)
    section_1=v1(i:w);
    section_2=v2(i:w);
    a_1=~isnan(section_1); %logical array to cut out NaNs before calculating mean
    a_2=~isnan(section_2);
    
    if and(sum(a_1)~=0, sum(a_2)~=0)
        v1_mean(end+1,1)=mean(section_1(a_1));
        v2_mean(end+1,1)=mean(section_2(a_2));
        %eventuell noch datetimes  vector mit jeweils der i-ten stelle  und
        %dann schauen was mit der Lücke und am Ende fabriziert wurde
     
    end
    i=w+1;
end
end

    


