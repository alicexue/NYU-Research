function [sig] = diff_ttest(x1,x2,difference)
% if difference is true, do ttest individually on x1 compared to 0 and x2
% compared to 0
% if difference is false, do ttest on x1-x2 compared to 0
if difference
    sig = zeros(2,13);
    for delay=1:size(x1,1)
        [~,p,~,~] = ttest(x1(delay,:));
        sig(1,delay) = p;
        [~,p,~,~] = ttest(x2(delay,:));
        sig(2,delay) = p;
    end  
else
   sig = zeros(1,13); 
   diff = x1-x2;
   for delay=1:size(x1,1)
        [~,p,~,~] = ttest(diff(delay,:));
        sig(1,delay) = p;
    end
end