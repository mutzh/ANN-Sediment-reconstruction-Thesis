load('GSA_noise')
load('get_opti_trials_FF_final')




Best_of_all_trials_det=cell(3,2);
Best_of_all_trials_noise=cell(4,2);
Best_of_all_trials_rng=cell(3,2);

% %1)deterministic
% Best_det=gmultiply(Best_det,-1);
% Best_det=cell2mat(Best_det);
% Best_det=Best_det';
Best_det(:,end)=0.6302;%add GSA manually

%1.1)RSA
c=max(Best_det(1,:));
a=Best_det(1,:)==c;
b=best_cand_det(1,:);
Best_of_all_trials_det{1,1}=b{a};
Best_of_all_trials_det{1,2}=c;
%1.2)GA
c=max(Best_det(2,:));
a=Best_det(2,:)==c;
b=best_cand_det(2,:);
Best_of_all_trials_det{2,1}=b{a};
Best_of_all_trials_det{2,2}=c;
%1.3)BO
c=max(Best_det(3,:));
a=Best_det(3,:)==c;
b=best_cand_det(3,:);
Best_of_all_trials_det{3,1}=b{a};
Best_of_all_trials_det{3,2}=c;







% %2)Noisy
% Best_noise=gmultiply(Best_noise,-1);
% Best_noise=cell2mat(Best_noise);
Best_noiseA=gmultiply(Best_noiseA,-1);
Best_noiseA=cell2mat(Best_noiseA);
Best_noiseA=Best_noiseA';
Best_noise(:,end)=Best_noiseA(:,1);%add GSA manually


%2.1)RSA
c=max(Best_noise(1,:));
a=Best_noise(1,:)==c;
b=best_cand_noise(1,:);
Best_of_all_trials_noise{1,1}=b{a};
Best_of_all_trials_noise{1,2}=c;
%2.2)GA
c=max(Best_noise(2,:));
a=Best_noise(2,:)==c;
b=best_cand_noise(2,:);
Best_of_all_trials_noise{2,1}=b{a};
Best_of_all_trials_noise{2,2}=c;
%2.3)BO
c=max(Best_noise(3,:));
a=Best_noise(3,:)==c;
b=best_cand_noise(3,:);
Best_of_all_trials_noise{3,1}=b{a};
Best_of_all_trials_noise{3,2}=c;
%2.4)GSA
c=max(Best_noiseA(4,:));
a=Best_noiseA(4,:)==c;
b=best_cand_noiseA(4,:);
Best_of_all_trials_noise{4,1}=b{a};
Best_of_all_trials_noise{4,2}=c;


% %3)rng()
% Best_rng=gmultiply(Best_rng,-1);
% Best_rng=cell2mat(Best_rng);
% Best_rng=Best_rng';
Best_rng(:,end)=0.6302;%add GSA manually

%3.1)RSA
c=max(Best_rng(1,:));
a=Best_rng(1,:)==c;
b=best_cand_rng(1,:);
Best_of_all_trials_rng{1,1}=b{a};
Best_of_all_trials_rng{1,2}=c;
%3.2)GA
c=max(Best_rng(2,:));
a=Best_rng(2,:)==c;
b=best_cand_rng(2,:);
Best_of_all_trials_rng{2,1}=b{a};
Best_of_all_trials_rng{2,2}=c;
%3.3)BO
c=max(Best_rng(3,:));
a=Best_rng(3,:)==c;
b=best_cand_rng(3,:);
Best_of_all_trials_rng{3,1}=b{a};
Best_of_all_trials_rng{3,2}=c;






%1)die besten 120 kandidaten (10 trials, 12 setups) in ein array vereinigen
%dafür zuerst die kandidaten aus GSA ergänzen
best_cand_det(end+1,:)={[11,11,2,1,1]};
best_cand_noise=[best_cand_noise;best_cand_noiseA(4,:)];
best_cand_rng(end+1,:)={[11,11,2,1,1]};
%dann array erstellen daraus
best_cand_overall=[best_cand_det',best_cand_noise',best_cand_rng'];
best_cand_overall=[best_cand_overall(:,1);best_cand_overall(:,2);best_cand_overall(:,3);best_cand_overall(:,4);best_cand_overall(:,5);best_cand_overall(:,6);best_cand_overall(:,7);best_cand_overall(:,8);;best_cand_overall(:,9);;best_cand_overall(:,10);;best_cand_overall(:,11);;best_cand_overall(:,12)];



%3) spaltenvektor mit den den 12 besten candidaten für jedes setup. also jeweils der
%beste aus allen 8 trials!
% dafür erstmal bei best of all trials noch die GSA ergebnisse eintragen
Best_of_all_trials_det(end+1,1)={[11,11,2,1,1]};
Best_of_all_trials_det(end,2)={0.6302};
Best_of_all_trials_rng(end+1,1)={[11,11,2,1,1]};
Best_of_all_trials_rng(end,2)={0.6302};
%dann erstellen 
best_of_all_trials_overall=[Best_of_all_trials_det;Best_of_all_trials_noise;Best_of_all_trials_rng];

figure;
boxplot(Best_det)
title('RandsearchFixed                     GaFixed                              BayesoptFixed               GridsearchFixed  ')
ylabel('NSE test')

figure;
boxplot(Best_noise)
title('RandsearchStochast               GaStochast                            BayesoptStochast             GridsearchStochast')
ylabel('NSE test')

figure;
boxplot(Best_rng)
title('RandsearchHP                  GaHP                             BayesoptHP             GridsearchHP')
ylabel('NSE test')

