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
Neurons_one=optimizableVariable('NEURONS1',[2,45],'Type','integer');
Neurons_two=optimizableVariable('NEURONS2',[2,45],'Type','integer');
tf1=optimizableVariable('TF1',[1,4],'Type','integer');
tf2=optimizableVariable('TF2',[1,4],'Type','integer');
tf3=optimizableVariable('TF3',[1,2],'Type','integer');


objective_function=create_opti_bayes_multidim(ANN1);%erstellen des function handle
plot_functions={@plotAcquisitionFunction,@plotObjectiveModel,@plotMinObjective,@plotObjective,@plotObjectiveEvaluationTime};
% plot_functions={@plotMinObjective};

results=bayesopt(objective_function,[Neurons_one,Neurons_two,tf1,tf2,tf3],'IsObjectiveDeterministic',false,'Verbose',2,...
                'MaxObjectiveEvaluations',150,'PlotFcn','all','NumSeedPoints',4,'AcquisitionFunctionName',...
                'expected-improvement-plus','ExplorationRatio',0.4,'GPActiveSetSize',500);


 