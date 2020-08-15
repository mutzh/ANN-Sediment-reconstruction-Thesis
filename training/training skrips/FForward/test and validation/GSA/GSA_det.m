% % % %LOAD DATA
% % % % load('ANN2_train.mat') %daten laden für reconstruct
% % % % ANN1=ANN2_train;
% % % load('ANN1')




%start timer
tic;
%create function handle of objective function
ObjFun=GSA_objective_det(ANN1);

%create serach space to sample from
tic;
dim_N1=10;
stepN1=3;
%
dim_N2=10;
stepN2=3;
%
dim_TF1=2;
stepTF1=1;
%
dim_TF2=2;
stepTF2=1;
%
dim_TF3=2;
stepTF3=1;
%
dim_WB=5;




no_designs=((dim_N1-1)/stepN1+1)*((dim_N2-1)/stepN2+1)*(dim_TF1/stepTF1)*(dim_TF2/stepTF2)*(dim_TF3/stepTF3)*10;
%no_designs=((dim_N1-1)/stepN1+1)*((dim_N2-1)/stepN2+1)*(dim_TF1/stepTF1)*(dim_TF2/stepTF2)*(dim_TF3/stepTF3)*dim_WB;
% % % design_space=zeros(no_designs,6);
place=1;
Results=zeros(no_designs,1);
for a=1:stepN1:dim_N1
    for b=1:stepN2:dim_N2
        for c=1:stepTF1:dim_TF1
            for d=1:stepTF2:dim_TF2
                for e=1:stepTF3:dim_TF3
                    for f=dim_WB  %!!!!!!!!!!!!!look here if you are confused
                        design=[a,b,c,d,e,f];
% % %                       design_space(place,:)=design;
                        result=(feval(ObjFun,design));
                        Results(place)=result;
                        place=place+1;
                    end
                end
            end
        end
    end
end

%display best
best=min(Results);
disp(best);

%cut out the excess zeros that werent filled(MaxTime)
B=Results~=0;
Results=Results(B);

%plot
figure
plot(1:length(Results),Results,'ro');

toc;
