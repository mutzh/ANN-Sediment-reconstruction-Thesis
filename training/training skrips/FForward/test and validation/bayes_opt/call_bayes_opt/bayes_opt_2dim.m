close all
%LOAD DATA
% load('ANN2_train.mat') %daten laden für reconstruct
% ANN1=ANN2_train;
load('ANN1');

%allgemein: beim bayesopt() werden die optionen, anders als beim ga(), nich als
%vektor, sonderen direkt als Name/Value pair übergeben
%zur besseren anschaulichkeit kann man mal nur 2 zu optimierende variablen angeben,
%dann kann noch ein 3d plot erstellt werden

%erstellen der verschiedenen zu optimierenden hyperpareameter
Neurons_one=optimizableVariable('NEURONS1',[15,20],'Type','integer');
Neurons_two=optimizableVariable('NEURONS2',[15,20],'Type','integer');


objective_function=create_opti_bayes_2dim(ANN1);%erstellen des function handle
plot_functions={@plotAcquisitionFunction,@plotObjectiveModel,@plotMinObjective,@plotObjective,@plotObjectiveEvaluationTime};
%plot_functions={@plotObjectiveModel};

results=bayesopt(objective_function,[Neurons_one,Neurons_two],'IsObjectiveDeterministic',false,'Verbose',2,...
                'MaxObjectiveEvaluations',200,'PlotFcn',plot_functions,'AcquisitionFunctionName',...
                'expected-improvement-plus','ExplorationRatio',0.5,'GPActiveSetSize',500, 'MaxTime',15);

 