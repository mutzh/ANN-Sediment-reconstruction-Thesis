% % % clear all
% % % close all
% % % clc
% % % 
% % % %laden des datasets
% % % load('ANN1.mat')
% % % % %verkleinern des datasets für testrun
% % % % ANN1=(ANN1(1:2000,:));



function [fval]= GA_det(ANN1)




%vektor der die verschiedenen optionen für den genetischen algorithmus enthält, als
%NAME/VALUE pairs
plots={};%,@gaplotbestindiv,@gaplotexpectation}^;
ga_opts=optimoptions('ga','Populationsize',25,'MaxGenerations',500, 'Display','off','PlotFcn',plots, 'maxTime',38);

IntCon=[1,2,3,4,5]; %unsere zu optimierenden variablen sind integer
A = [];             %unbenutzte erwartete variablen des GA() leer lassen
b = [];
Aeq = [];
beq = [];
lb = [1 1 1 1 1];   %untere grenze
ub = [10 10 2 2 2]; % obere grenze 
nonlcon = [];

opti_func = GA_objective_det(ANN1);  %GA() erwartet ein function handle, dies fkt. erstellt eines aus der objective function
[aa,fval,exitflag,output,population,scores]=ga(opti_func,5,A,b,Aeq,beq,lb,ub,nonlcon,IntCon,ga_opts);
end