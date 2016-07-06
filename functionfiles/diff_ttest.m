function [sig] = diff_ttest(x,difference)
% if difference is true, do ttest individually on x1 compared to 0 and x2
% compared to 0
% if difference is false, do ttest on x1-x2 compared to 0
if difference
    sig = NaN(size(x,1),1,size(x,3));
    for i=1:size(x,3)
        for delay=1:size(x,1);
            [t,p,ci,stats] = ttest(x(delay,:,i))
            sig(delay,1,i) = p;
        end
    end  
else
   sig = NaN(size(x,1),1);
   diff = x(:,:,1)-x(:,:,2);
   for i=1:size(diff,3)
       for delay=1:size(x,1);
        [t,p,ci,stats] = ttest(diff(delay,:,i))
        sig(delay,1,i) = p;
       end
    end
end