%using the best found network for prediction.
%use the hyperparameters to select it from the folder you are currently in:
%'pwd'

function [net]=getnet_pwd(hyper_param)
    z=num2str(hyper_param(1));
    TF=num2str(hyper_param(2));
    N1=num2str(hyper_param(3));
    N2=num2str(hyper_param(4));
    
    
    
    net=strcat(pwd,'\net','_',z,'_',TF,'_',N1,'_',N2,'.mat');
    
    netc=[];
    
    load(net);
    if isobject(netc)
        net=netc;
        clear netc;
    end
   
end
    %was passiert wenn wir nur 1 HL haben?
    %antwort: dann wird N2 halt einfach leer gelassen, und TF hat in
    %unserem trainingsskript halt auch nur 2 TF