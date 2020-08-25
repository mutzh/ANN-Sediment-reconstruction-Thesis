% % % clear all
% % % close all
% % % clc
% % % 
% % % %laden des datasets
% % % load('ANN1.mat')
% % % % %verkleinern des datasets für testrun
% % % % ANN1=(ANN1(1:2000,:));



function [fval,aa]= GA_NARX_rng_2(data_NarxN)

  rng('shuffle');


%vektor der die verschiedenen optionen für den genetischen algorithmus enthält, als
%NAME/VALUE pairs
plots={};%,@gaplotbestindiv,@gaplotexpectation}^;
ga_opts=optimoptions('ga','Populationsize',20,'MaxGenerations',1000, 'Display','off','PlotFcn',plots, 'maxTime',450,'EliteCount',3);

IntCon=[1,2,3,4,5,6,7,8]; %unsere zu optimierenden variablen sind integer
A = [];             %unbenutzte erwartete variablen des GA() leer lassen
b = [];
Aeq = [];
beq = [];
lb = [1 1 1 1 1 0 1 1];   %untere grenze
ub = [4 12 12 3 3 10 10 30] ; % obere grenze 
nonlcon = [];

opti_func = GA_objective_NARX_rng(data_NarxN);  %GA() erwartet ein function handle, dies fkt. erstellt eines aus der objective function
[aa,fval,~,~,~,~]=ga(opti_func,8,A,b,Aeq,beq,lb,ub,nonlcon,IntCon,ga_opts);

end