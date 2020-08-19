load('data_NarxN')

% INPUT=ANN1(:,1);
% TARGET=ANN1(:,2);

INPUT=ANN1(:,1);
TARGET=ANN1(:,2);

%calculate output of power function SRC
[OUTPUT]= SRC_function(INPUT);

%calculate NSE
[NSE] = ns_efficiency(TARGET,OUTPUT)

%calculate R^2
TARGET=TARGET';
OUTPUT=OUTPUT';
[r,m,b]=regression(TARGET,OUTPUT);
R_squared=r^2