clear all
close all
clc

%laden des datasets
load('ANN1.mat')
% %verkleinern des datasets für testrun
% ANN1=(ANN1(1:2000,:));



%vektor der die verschiedenen optionen für den genetischen algorithmus enthält, als
%NAME/VALUE pairs
plots={@gaplotbestf};%,@gaplotbestindiv,@gaplotexpectation}^;
ga_opts=optimoptions('ga','Populationsize',25,'MaxGenerations',25, 'Display','diagnose','PlotFcn',plots);

IntCon=[1,2,3,4,5,6]; %unsere zu optimierenden variablen sind integer
A = [];             %unbenutzte erwartete variablen des GA() leer lassen
b = [];
Aeq = [];
beq = [];
lb = [3 3 1 1 1 1];   %untere grenze
ub = [10 10 1 1 1 250]; % obere grenze 
nonlcon = [];

opti_func = GA_objective_det(ANN1);  %GA() erwartet ein function handle, dies fkt. erstellt eines aus der objective function
[aa,fval,exitflag,output,population,scores]=ga(opti_func,6,A,b,Aeq,beq,lb,ub,nonlcon,IntCon,ga_opts);