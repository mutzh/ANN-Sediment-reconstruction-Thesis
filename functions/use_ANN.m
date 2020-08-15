 %this function takes the following arguments: 
%1) a matrix with each row representing the hyperparameters for the selection of a
%network from the folder that is currently last on the path. usually this is "explicitly_saved_nets"
%2) a colum vector with the input (Q values)

%it then returns a matrix with the network outputs, each colum representing one net

function [network_outputs]=use_ANN(mynets, used_input)

no_of_inputs=length(used_input);



%number of nets in mynets
no_of_nets=size(mynets,1);

%preallocating the output matrix
network_outputs=num2cell(zeros(no_of_nets,no_of_inputs));

%loop over different nets from "mynets"
for i=1:no_of_nets
    %chose net from the folder thats indicated by current path "pwd". you
    %can choose the folder "saved_nets" or "explicitely_saved_nets"
    mynet=getnet_pwd(mynets(i,:));
%     network_outputs(i,:)=mynet(used_input');%predict the sediment on basis of the Q values
    network_outputs(i,:)=mynet(used_input);%predict the sediment on basis of the Q values

end

% network_outputs=network_outputs';%transpose
end