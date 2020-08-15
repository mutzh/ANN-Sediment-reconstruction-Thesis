%NSE
function [NSE]=ns_efficiency(target,output)
NSE=1-sum((target-output).^2)/sum((target-mean(target)).^2);
end