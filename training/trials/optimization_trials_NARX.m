% run a number of trial for each optimization algorithm. GSA duration will determine
% the max-time for the other algorithms
load('data_NarxN.mat')


no_trials=8;


Best_det=cell(3,no_trials);
best_cand_det=cell(3,no_trials);

Best_noise=cell(4,no_trials);
best_cand_noise=cell(4,no_trials);

Best_rng=cell(3,no_trials);
best_cand_rng=cell(3,no_trials);

for trial=1:no_trials
    [Best_det{1,trial},best_cand_det{1,trial}]=RSA_unique_NARX_det(data_NarxN);
    [Best_det{2,trial},best_cand_det{2,trial}]=GA_NARX_det(data_NarxN);
    [Best_det{3,trial},best_cand_det{3,trial}]=bayes_opt_NARX_det(data_NarxN);
    
    [Best_noise{1,trial},best_cand_noise{1,trial}]=RSA_unique_NARX_noise(data_NarxN);
    [Best_noise{2,trial},best_cand_noise{2,trial}]=GA_NARX_noise(data_NarxN);
    [Best_noise{3,trial},best_cand_noise{3,trial}]=bayes_opt_NARX_noise(data_NarxN);
    [Best_noise{4,trial},best_cand_noise{4,trial}]=GSA_NARX_noise(data_NarxN);
    
    [Best_rng{1,trial},best_cand_rng{1,trial}]=RSA_unique_NARX_rng(data_NarxN);
    [Best_rng{2,trial},best_cand_rng{2,trial}]=GA_NARX_rng(data_NarxN);
    [Best_rng{3,trial},best_cand_rng{3,trial}]=bayes_opt_NARX_rng(data_NarxN);

    
    disp(trial);
end
Best_of_all_trials_det=cell(3,2);
Best_of_all_trials_noise=cell(4,2);
Best_of_all_trials_rng=cell(3,2);

%1)deterministic
Best_det=gmultiply(Best_det,-1);
Best_det=cell2mat(Best_det);

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


Best_det=Best_det';
Best_det(:,end+1)=0.6617;%add GSA manually



%2)Noisy
Best_noise=gmultiply(Best_noise,-1);
Best_noise=cell2mat(Best_noise);

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
c=max(Best_noise(4,:));
a=Best_noise(4,:)==c;
b=best_cand_noise(4,:);
Best_of_all_trials_noise{4,1}=b{a};
Best_of_all_trials_noise{4,2}=c;

Best_noise=Best_noise';




%3)rng()
Best_rng=gmultiply(Best_rng,-1);
Best_rng=cell2mat(Best_rng);

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

Best_rng=Best_rng';
Best_rng(:,end+1)=0.6595;%add GSA manually



%die besten kandidaten in ein array vereinigen, aber zuerst die kandidaten aus den
%manuellen GSA runs hinzufügen
%1) manuell GSA hinzufügen
best_cand_det(end+1,:)={[7,1,2,1,1,3,7]};
best_cand_rng(end+1,:)={[4,4,1,2,1,6,7]};

Best_of_all_trials_det(end+1,1)={[7,1,2,1,1,3,7]};
Best_of_all_trials_det(end,2)={0.6617};
Best_of_all_trials_rng(end+1,1)={[4,4,1,2,1,6,7]};
Best_of_all_trials_rng(end,2)={0.6595};
%2)beste candidaten der einzelnen trials in einen spaltenvektor vereinen, um diesen
%später durch Narx_app_script zu jagen
best_cand_overall=[best_cand_det',best_cand_noise',best_cand_rng'];
best_cand_overall=[best_cand_overall(:,1);best_cand_overall(:,2);best_cand_overall(:,3);best_cand_overall(:,4);best_cand_overall(:,5);best_cand_overall(:,6);best_cand_overall(:,7);best_cand_overall(:,8);;best_cand_overall(:,9);;best_cand_overall(:,10);;best_cand_overall(:,11);;best_cand_overall(:,12)];
%3) spaltenvektor mit den den 12 besten candidaten für jedes setup. also jeweils der
%beste aus allen 8 trials!!
Best_of_all_trials_overall=[Best_of_all_trials_det;Best_of_all_trials_noise;Best_of_all_trials_rng];

figure;
boxplot(Best_det)
title('RandsearchFixed                     GaFixed                              BayesoptFixed             GridsearchFixed')
ylabel('NSE')

figure;
boxplot(Best_noise)
title('RandsearchStochast                 GaStochast                             BayesoptStochast               GridsearchStochast')
ylabel('NSE')

figure;
boxplot(Best_rng)
title('RandsearchHP                     GaHP                              BayesoptHP             GridsearchHP')
ylabel('NSE')

