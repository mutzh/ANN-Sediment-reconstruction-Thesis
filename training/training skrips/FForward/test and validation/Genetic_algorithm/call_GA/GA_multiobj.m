close all
clc

%laden des datasets
load('ANN1.mat')
%verkleinern des datasets für testrun
% ANN1=(ANN1(1:10000));


plot_functions={@gaplotpareto};
%vektor der die verschiedenen optionen für den genetischen algorithmus enthält, als
%NAME/VALUE pairs
ga_opts=optimoptions('gamultiobj', 'Populationsize',45, 'MaxGenerations',10, 'Display','Iter', 'PlotFcn',plot_functions,...
    'CreationFcn', @int_pop,...
    'MutationFcn', @int_mutation,...
    'CrossoverFcn',@int_crossoverarithmetic);

A = [];             %unbenutzte erwartete variablen des GA() leer lassen
b = [];
Aeq = [];
beq = [];
%lb = [2 0 1 1 1];   %untere grenze
%ub = [35 35 3 3 2]; % obere grenze 
lb = [1 20 ];   %untere grenze
ub = [1 20 ]; % obere grenze 
nonlcon = [];

objectives = GA_objectives(ANN1);  %GA() erwartet ein function handle, dies fkt. erstellt eines aus der objective function

%aufrufen des GA_multiobj()
[aa,fval,exitflag,output,population,scores]=gamultiobj(objectives,2,A,b,Aeq,beq,lb,ub,nonlcon,ga_opts);
