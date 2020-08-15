%save net from 'saved_nets' to the folder you are currently in

%!!!!!!!!!THIS FUNCTION SAVES TO THE FOLDER YOU ARE CURRENTLY IN!!!!!!!!!!

%this function uses another function 'getnet' to load a chosen net from
%'saved_nets

%the input chosen_net is a row vector containing the hyperparameters of the net
%in the following order: [z,TF,N1,N2]
function []=save_net_explicitely(chosen_net)
    z=num2str(chosen_net(1));
    TF=num2str(chosen_net(2));
    N1=num2str(chosen_net(3));
    N2=num2str(chosen_net(4));

    net=getnet(chosen_net);%chose net from folder "saved_nets"
    filename=strcat('net','_',z,'_',TF,'_',N1,'_',N2);
    save(filename,'net')%save to the folder you are currently in
end



