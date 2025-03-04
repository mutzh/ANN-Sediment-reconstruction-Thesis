clear all
close all
clc

%laden des datasets
load('ANN1.mat')
%verkleinern des datasets für testrun
ANN1=(ANN1(1:1000,:));



%vektor der die verschiedenen optionen für den genetischen algorithmus enthält, als
%NAME/VALUE pairs
ga_opts=optimoptions('ga','Populationsize',20,'MaxGenerations',5, 'Display','Iter');

IntCon=[1,2,3,4,5]; %unsere zu optimierenden variablen sind integer
A = [];             %unbenutzte erwartete variablen des GA() leer lassen
b = [];
Aeq = [];
beq = [];
lb = [1 1 1 1 1];   %untere grenze
ub = [16 16 2 2 2]; % obere grenze 
nonlcon = [];

opti_func = GA_objective_stochast(ANN1);  %GA() erwartet ein function handle, dies fkt. erstellt eines aus der objective function
[aa,fval,exitflag,output,population,scores]=ga(opti_func,5,A,b,Aeq,beq,lb,ub,nonlcon,IntCon,ga_opts);