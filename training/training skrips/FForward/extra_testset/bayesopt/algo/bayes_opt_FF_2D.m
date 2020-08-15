% % % close all
% % % 
% % % %LOAD DATA
% % % % load('ANN2_train.mat') %daten laden für reconstruct
% % % % ANN1=ANN2_train;
% % % load('ANN1');


function [minObjective,bestNet]= bayes_opt_FF_2D(data_NarxN)



%allgemein: beim bayesopt() werden die optionen, anders als beim ga(), nich als
%vektor, sonderen direkt als Name/Value pair übergeben
%zur besseren anschaulichkeit kann man mal nur 2 zu optimierende variablen angeben,
%dann kann noch ein 3d plot erstellt werden

%erstellen der verschiedenen zu optimierenden hyperpareameter
Neurons_one=optimizableVariable('NEURONS1',[1,10],'Type','integer');
Neurons_two=optimizableVariable('NEURONS2',[1,10],'Type','integer');




objective_function=create_opti_bayes_FF_2D(data_NarxN);%erstellen des function handle
plot_functions={@plotAcquisitionFunction,@plotObjectiveModel,@plotMinObjective};
%  plot_functions={@plotMinObjective};

     
            
results=bayesopt(objective_function,[Neurons_one,Neurons_two],'IsObjectiveDeterministic',true,'Verbose',2,...  %dann noch mit deterministic =true
                'MaxObjectiveEvaluations',30,'PlotFcn',plot_functions,'NumSeedPoints',4,'AcquisitionFunctionName',...
                'expected-improvement-plus','ExplorationRatio',0.6,'GPActiveSetSize',500,'MaxTime',1000);

minObjective=results.MinObjective;
bestNet=results.XAtMinEstimatedObjective;
end