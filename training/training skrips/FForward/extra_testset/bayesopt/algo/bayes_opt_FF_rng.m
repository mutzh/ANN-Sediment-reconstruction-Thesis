% % % close all
% % % 
% % % %LOAD DATA
% % % % load('ANN2_train.mat') %daten laden für reconstruct
% % % % ANN1=ANN2_train;
% % % load('ANN1');


function [minObjective,bestNet]= bayes_opt_FF_rng(data_NarxN)

rng('shuffle');

%allgemein: beim bayesopt() werden die optionen, anders als beim ga(), nich als
%vektor, sonderen direkt als Name/Value pair übergeben
%zur besseren anschaulichkeit kann man mal nur 2 zu optimierende variablen angeben,
%dann kann noch ein 3d plot erstellt werden

%erstellen der verschiedenen zu optimierenden hyperpareameter
Neurons_one=optimizableVariable('NEURONS1',[1,11],'Type','integer');
Neurons_two=optimizableVariable('NEURONS2',[1,11],'Type','integer');
tf1=optimizableVariable('TF1',[1,2],'Type','integer');
tf2=optimizableVariable('TF2',[1,2],'Type','integer');
tf3=optimizableVariable('TF3',[1,2],'Type','integer');
seed=optimizableVariable('SEED',[1,100],'Type','integer');


objective_function=create_opti_bayes_FF_rng(data_NarxN);%erstellen des function handle
% plot_functions={@plotAcquisitionFunction,@plotObjectiveModel,@plotMinObjective,@plotObjective,@plotObjectiveEvaluationTime};
plot_functions={}; 
%  plot_functions={@plotMinObjective};%the plot has a bug, when using a deterministic objective: estimated and observed min objective should always 
%                                      % be the same, but when the min observed
%                                      % objective does not get smaller in the first
%                                      % couple steps, the plot will show a different
%                                      % minEstimatedObjective than the
%                                      % minObservedObjective. But Verbose will show
%                                      % the right values and as soon as the
%                                      % minObjective improves, the bug is gone

            
            
results=bayesopt(objective_function,[Neurons_one,Neurons_two,tf1,tf2,tf3,seed],'IsObjectiveDeterministic',true,'Verbose',0,...
                'MaxObjectiveEvaluations',1000,'PlotFcn',plot_functions,'NumSeedPoints',4,'AcquisitionFunctionName',...
                'expected-improvement-plus','ExplorationRatio',0.6,'GPActiveSetSize',1000,'MaxTime',10000);

minObjective=results.MinObjective;
bestNet=results.XAtMinObjective;
bestNet=table2array(bestNet);
end