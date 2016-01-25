function calculateAttendPerf(p1,p2) 

%% This function calculates the performance at the attended and unattended locations depending on the number of stimuli in the attentional focus
%% Parameters
% p1 is a 13x1 matrix of values
% p2 is a 13x1 matrix of values
% delayNum must be an integer between 1 and 13 (should refer to the delay at which the difference between p1 and p2 is the largest, i.e. there is an attentional peak)

% performance at the attended location is abbreviated as ap and performance at the unattended location is abbreviated as up

% if there is ONE stimulus in the attentional focus
one_ap = 2*p1-p2;
one_up = p2;

% if there are TWO stimuli in the attentional focus
two_ap = (5*p1-p2)/4;
two_up = (25*p2-5*p1)/20;

% if there are THREE stimuli in the attentional focus
three_ap = p1;
three_up = 2*p2-p1;

% if there are FOUR stimuli in the attentional focus
% p1 = p2 = ap + up
four_stimuli = p1 == p2;

if four_stimuli
    truth = 'TRUE';
else
    truth = 'FALSE';
end

fprintf('-------------------------------------\n')
fprintf(['Given that p1 = ' num2str(p1*100) '%% and p2 = ' num2str(p2*100) '%%,\n'])
fprintf('the performance at the attended and unattended locations in the search\n')
fprintf('depending on the number of stimuli in the search display are the following:\n')
fprintf('-------------------------------------\n')
fprintf('ONE stimulus in the attentional focus\n')
fprintf(['Attended performance: ' num2str(one_ap*100) '%% \n'])
fprintf(['Unattended performance: ' num2str(one_up*100) '%% \n'])
fprintf('-------------------------------------\n')
fprintf('TWO stimuli in the attentional focus\n')
fprintf(['Attended performance: ' num2str(two_ap*100) '%% \n'])
fprintf(['Unattended performance: ' num2str(two_up*100) '%% \n'])
fprintf('-------------------------------------\n')
fprintf('THREE stimuli in the attentional focus\n')
fprintf(['Attended performance: ' num2str(three_ap*100) '%% \n'])
fprintf(['Unattended performance: ' num2str(three_up*100) '%% \n'])
fprintf('-------------------------------------\n')
fprintf('FOUR stimuli in the attentional focus\n')
fprintf('In this case, p1 must equal p2 and they are equal to the sum of ap + up.\n')
fprintf(['For these given values of p1 and p2, that is ' truth '.\n'])



