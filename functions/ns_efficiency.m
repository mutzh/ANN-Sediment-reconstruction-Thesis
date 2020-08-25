%NSE
%takes two nx1 numeric arrays as inputs
function [NSE]=ns_efficiency(target,output)
a=~isnan(output);
b=~isnan(target);
c=and(a,b);
output=output(c);
target=target(c);
NSE=1-sum((target-output).^2)/sum((target-mean(target)).^2);
end