function [pb_all,pn_all,n1_all,n2_all] = p1p2_test(p1,p2,trials)
n1_all = [];
n2_all = [];

pb_all = [];
pn_all = [];

pb_all = horzcat(pb_all,p1*p2);
pn_all = horzcat(pn_all,(1-p1)*(1-p2));
n1_all = horzcat(n1_all,p1);
n2_all = horzcat(n2_all,p2);

n = 1; 
while size(pb_all,2) < 6
%     pboth = p1*p2;
%     pnone = (1-p1)*(1-p2);
%     pone = 1 - (pboth + pnone);
     
    n1 = rand;
    n2 = rand;
    
    pboth = n1*n2;
    pnone = (1-n1)*(1-n2);
    
    if n1<p1 && n2<p2
        n1_all = horzcat(n1_all,n1);
        n2_all = horzcat(n2_all,n2);
        pb_all = horzcat(pb_all,pboth);
        pn_all = horzcat(pn_all,pnone);
    else
        n = n + 1;
    end
end

end


