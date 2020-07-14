%boxplot für wahl der data division

% %this part was used for creating of the workspace data and is now commented out
% NSE_ts=Ascending_z_TF_OL_Checking(:,16);
% grouping_N1=Ascending_z_TF_OL_Checking(:,23);
% grouping_TF=Ascending_z_TF_OL_Checking(:,22);
% grouping_N2=Ascending_z_TF_OL_Checking(:,24);


data_box= [NSE_ts,grouping_N1,grouping_N2,grouping_TF];

figure
boxplot(data_box(:,1),data_box(:,2))

figure
boxplot(data_box(:,1),data_box(:,3))

figure
boxplot(data_box(:,1),data_box(:,4))