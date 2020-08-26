% % % %LOAD DATA
% % % % load('ANN2_train.mat') %daten laden für reconstruct
% % % % ANN1=ANN2_train;
% % % load('ANN1')


function [best,best_candidate]= GSA_NARX_noise_timelimit(data_NarxN)

%start timer
tic;
%create function handle of objective function
ObjFun=GSA_objective_NARX_noise(data_NarxN);

%create serach space to sample from

dim_N1=7;
stepN1=3;
%
dim_N2=7;
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
ID=7;
stepID=3;
%
FD=7;
stepFD=3;

maxTime=1900;



%hier bitte vorsicht mit den no_designs, das teilen geht nicht immer ganz auf, da
%muss manuell nachgeholfen werden!!

% no_designs=((dim_N1-1)/stepN1+1)*((dim_N2-1)/stepN2+1)*(dim_TF1/stepTF1)*(dim_TF2/stepTF2)*(dim_TF3/stepTF3)*10;
no_designs=((dim_N1-1)/(stepN1)+1)*((dim_N2-1)/(stepN2)+1)*(dim_TF1/stepTF1)*(dim_TF2/stepTF2)*(dim_TF3/stepTF3)*((ID-1)/stepID+1)*((FD-1)/stepFD+1); %für gerade step width
% no_designs=((dim_N1)/stepN1)*((dim_N2)/stepN2)*(dim_TF1/stepTF1)*(dim_TF2/stepTF2)*(dim_TF3/stepTF3)*(ID+1)*FD; % für ungerade step width
design_space=zeros(no_designs,7);
place=1;
Results=zeros(no_designs,1);
for a=1:stepN1:dim_N1
    for b=1:stepN2:dim_N2
        for c=1:stepTF1:dim_TF1
            for d=1:stepTF2:dim_TF2
                for e=1:stepTF3:dim_TF3
                    for f=0:stepID:ID
                        for g=1:stepFD:FD
                                design=[a,b,c,d,e,f,g];
                                design_space(place,:)=design;
                                result=(feval(ObjFun,design));
                                Results(place)=result;
                                place=place+1;
                                
                                %maxTime
                                time=toc;
                                if time >= maxTime
                                    break;
                                end
                        end
                    end
                end
            end
        end
    end
end

%display best
best=min(Results);
best_candidate_position=find(Results==best,1);
best_candidate=design_space(best_candidate_position,:);
% disp(best);
%
% %cut out the excess zeros that werent filled(MaxTime)
% B=Results~=0;
% Results=Results(B);
% 
% %plot
% figure
% plot(1:length(Results),Results,'ro');
% 
% toc;
end