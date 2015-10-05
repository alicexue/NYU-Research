function [p_out,delta_value] = delta_test(p_both_in,p_none_in)
% A function to try to help visualise what's going on with the delta and
% p1/p2 calculations. Basically, it plots the results for the different
% combinations of P_both and P_none (and the sum of these can never be
% greater than 1, so the upper right corner of the plots is blank). 
%
% The delta plot shows the curve (white) where delta is zero, and in green
% the contours for positive delta values (at 0.2, 0.4 ...), and in red for
% negative values.
%
% The P1 and P2 plots have the same colour scale: dark to bright green is
% for valid values, from 0 to 1. Red is for negative values, blue is for
% values greater than 1.
%
% And you can send sample p_both and p_none values to the function to get
% the P1 and P2 values back, and see where they lie on the plots.

% As regards the out-of-bounds values, you can see that these are near to
% the diagonal where P_both + P_none = 1. At P_both = P_none = 0.5, you
% get a 'valid' value of P1 = 0 and P2 = 1, which makes sense (ignoring for
% now the P2>P1). Increasing Pboth from here, P2 goes out of bounds above
% 1; increasing Pnone yields P1 out of bounds below zero. Why are these
% areas near the diagonal problematic? Well, remember that when P_none +
% P_both = 1 (or close to), then we're also saying that P_single = 0 (or 
% close to), so we're forcing
% the system to find solutions where the outcome is often both correct or
% neither correct, but almost never just one correct - and that's basically
% not possible from our starting point of two independent probabilities of
% identifying each object (P1 and P2). So the numbers go out of bounds.

% Actually though, much of that logic applies to the whole delta<0 area:
% those results shouldn't exist. They only reason they do is that we're
% estimating these probabilities from a (very) finite number of samples,
% and noise can take us to weird places. So, one other fun thing to try if
% you're trying to make sense of what's going on with these measures is to
% run a virtual experiment: pick a pair of values for P1 and P2 (say, 0.8
% and 0.25), from which you know what P_both/P_single/P_none you expect
% (0.2,0.65 and 0.15 here). Then get your program to generate a number of
% trials (2 random numbers, 0 - 1, for each trial, test whether they're
% less than P1 and P2 respectively). Then you can see the range of
% P_both/P_none values you get out for a given number of trials - it's
% quite scary.

handles = delta_contours_plot;

for which_subplot = 1:3
    plot(handles.plot(which_subplot),p_none_in,p_both_in,'om','MarkerSize',8,'MarkerFaceColor','c')
end

b = -(1+p_both_in - p_none_in);
c = p_both_in;

delta_value = b.^2 - 4*c;
p_out(1) = (-b + sqrt(abs(delta_value)).*sign(delta_value))./2;
p_out(2) = (-b - sqrt(abs(delta_value)).*sign(delta_value))./2;




function handles = delta_contours_plot()
pB = 0:0.001:1;
pN = 0:0.001:1;
delta = zeros(1001,1001);
b_values = zeros(size(delta));
for pbind  = 1:1001
    for pnind  = 1:1001
        if (pB(pbind)+pN(pnind))<=1
            b_values(pbind,pnind) = -(1+pB(pbind) - pN(pnind));
            delta(pbind,pnind) = (b_values(pbind,pnind).^2 - 4*pB(pbind));
        else
            delta(pbind,pnind) = NaN;
            b_values(pbind,pnind) = NaN;
        end
    end
end

p1 = (-b_values + sqrt(abs(delta)).*sign(delta))/2;
p2 = (-b_values - sqrt(abs(delta)).*sign(delta))/2;

rounding=0.01;
delta0 = and((delta<rounding),(delta>-rounding));
rounding = 0.001;
delta_p2 = and((delta)>(-rounding),(delta)>(-rounding))*0.2;
delta_p4 = and((delta)>(0.2-rounding),(delta)>(-rounding))*0.2;
delta_p6 = and((delta)>(0.4-rounding),(delta)>(-rounding))*0.2;
delta_p8 = and((delta)>(0.6-rounding),(delta)>(-rounding))*0.2;
delta_p10 = and((delta)>(0.8-rounding),(delta)>(-rounding))*0.2;

delta_n2 = and((delta)<(rounding),(delta)<(-0.0+rounding))*0.2;
delta_n4 = and((delta)<(rounding),(delta)<(-0.2+rounding))*0.2;
delta_n6 = and((delta)<(rounding),(delta)<(-0.4+rounding))*0.2;
delta_n8 = and((delta)<(rounding),(delta)<(-0.6+rounding))*0.2;
delta_n10 = and((delta)<(rounding),(delta)<(-0.8+rounding))*0.2;

delta_contours = zeros([size(delta) 3]);
delta_contours(:,:,2) = delta_p2 + delta_p4 + delta_p6 + delta_p8 + delta_p10;
delta_contours(:,:,1) = delta_n2 + delta_n4 + delta_n6 + delta_n8 + delta_n10;
helper = repmat(delta0,[1 1 3]);
delta_contours(helper) = 1;

p1_colours = zeros([size(p1) 3]);
p1_green = and(p1>=0,p1<=1);
p1_colours(:,:,2) = p1_green.*p1;
p1_red = p1<0;
p1_colours(:,:,1) = p1_red.*(1+p1);
p1_blue = p1>1;
p1_colours(:,:,3) = p1_blue.*(2-p1);
p1_colours(p1_colours<0) = 0;
p1_colours(p1_colours>1) = 1;
p1_colours(helper) = 1;

p2_colours = zeros([size(p2) 3]);
p2_green = and(p2>=0,p2<=1);
p2_colours(:,:,2) = p2_green.*p2;
p2_red = p2<0;
p2_colours(:,:,1) = p2_red.*(1+p2);
p2_blue = p2>1;
p2_colours(:,:,3) = p2_blue.*(2-p2);
p2_colours(p2_colours<0) = 0;
p2_colours(p2_colours>1) = 1;
p2_colours(helper) = 1;

figure
handles.plot(1) = subplot(1,3,1);
hold on
title('Delta')
image(pN,pB,delta_contours)
xlim([0 1])
ylim([0 1])
ylabel('Prob(both)')

handles.plot(2) = subplot(1,3,2);
hold on
title('P(1)')
xlabel('Prob(none)')
% imagesc(pN,pB,p1);
set(gca,'YDir','normal')
image(pN,pB,p1_colours);
xlim([0 1])
ylim([0 1])

handles.plot(3) = subplot(1,3,3);
hold on
title('P(2)')
% imagesc(pN,pB,p2);
set(gca,'YDir','normal')
image(pN,pB,p2_colours);
xlim([0 1])
ylim([0 1])

end

end