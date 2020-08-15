%using the best found network for prediction.
%use the hyperparameters to select it from 'saved_nets'

function [net]=getnet(hyper_param)
    z=num2str(hyper_param(1));
    TF=num2str(hyper_param(2));
    N1=num2str(hyper_param(3));
    N2=num2str(hyper_param(4));
    
    
    
    net=strcat('C:\Users\mutzh\Desktop\uni\uni 7. semester\Bachelorarbeit\Matlab\netzwerkdaten\save_nets\','\net','_',z,'_',TF,'_',N1,'_',N2,'.mat');
   
    load(net)
end
    %was passiert wenn wir nur 1 HL haben?
    %antwort: dann wird N2 halt einfach leer gelassen, und TF hat in
    %unserem trainingsskript halt auch nur 2 TF