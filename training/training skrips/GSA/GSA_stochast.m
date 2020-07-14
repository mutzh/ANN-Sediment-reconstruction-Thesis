%GSA_stochast
%LOAD DATA
% load('ANN2_train.mat') %daten laden für reconstruct
% ANN1=ANN2_train;
load('ANN1')

%start timer
tic;
%create function handle of objective function
ObjFun=GSA_objective_stochast(ANN1);

%define serach space to sample from
tic;
dim_N1=5;
stepN1=2;
%
dim_N2=5;
stepN2=2;
%
dim_TF1=2;
stepTF1=1;
%
dim_TF2=2;
stepTF2=1;
%
dim_TF3=2;
stepTF3=1;




%evaluate the different designs, save them, plot them, and return the best point
no_designs=(dim_N1/stepN1)*(dim_N2/stepN2)*(dim_TF1/stepTF1)*(dim_TF2/stepTF2)*(dim_TF3/stepTF3);
% % % design_space=zeros(no_designs,5);
place=1;
results=zeros(no_designs,1);
for a=1:stepN1:dim_N1
    for b=1:stepN2:dim_N2
        for c=1:stepTF1:dim_TF1
            for d=1:stepTF2:dim_TF2
                for e=1:stepTF3:dim_TF3
                    
                        design=[a,b,c,d,e];
% % %                       design_space(place,:)=design;
                        result=(feval(ObjFun,design));
                        results(place)=result;
                        place=place+1;
                    
                end
            end
        end
    end
end

%display best
best=min(results);
disp(best);

% % % %cut out the excess zeros that werent filled(MaxTime)
% % % B=results~=0;
% % % results=results(B);

%plot
figure
plot(1:length(results),results,'ro');

toc;
