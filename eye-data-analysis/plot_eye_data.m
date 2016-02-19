function plot_eye_data(e)

% get all combination of parameters
[stimvol names trialNums] = getStimvolFromVarname('_every_',e.stimfile.myscreen,e.stimfile.task,e.stimfile.taskNum,e.stimfile.phaseNum);

% remove empty trialNums
for iTrialType = 1:length(trialNums)
  emptyTypes(iTrialType) = isempty(trialNums{iTrialType});
end
stimvol = {stimvol{find(~emptyTypes)}};
names = {names{find(~emptyTypes)}};
trialNums = {trialNums{find(~emptyTypes)}};
figure;

% display trial by trial.
for iTrialType = 1:length(trialNums)
  % get color
  c = getSmoothColor(iTrialType,length(trialNums),'hsv');
  % display horizontal eye trace
  subplot(2,3,1:2);
  plot(e.eye.time,e.eye.xPos(trialNums{iTrialType},:)','Color',c);
  hold on
  % display vertical eye trace
  subplot(2,3,4:5);
  plot(e.eye.time,e.eye.yPos(trialNums{iTrialType},:)','Color',c);
  hold on
  % display as an x/y plot the median eye trace for this condition
  subplot(2,3,[3 6]);
  xPos = nanmedian(e.eye.xPos(trialNums{iTrialType},:));
  yPos = nanmedian(e.eye.yPos(trialNums{iTrialType},:));
  plot(xPos,yPos,'.','Color',c);
  hold on
end

% figure trimmings
hMin = -15;hMax = 15;
vMin = -15;vMax = 15;
subplot(2,3,1:2);
% yaxis(hMin,hMax);
ylim([hMin,hMax]);
% xaxis(0,max(e.eye.time));
xlim([0,max(e.eye.time)]);
xlabel('Time (sec)');
ylabel('H. eyepos (deg)');
subplot(2,3,4:5);
% yaxis(vMin,vMax);
ylim([vMin,vMax]);
% xaxis(0,max(e.eye.time));
xlim([0,max(e.eye.time)]);
xlabel('Time (sec)');
ylabel('V. eyepos (deg)');
subplot(2,3,[3 6]);
% xaxis(hMin,hMax);
xlim([hMin,hMax]);
% yaxis(vMin,vMax);
ylim([vMin,vMax]);
xlabel('H. eyepos (deg)');
ylabel('V. eyepos (deg)');
title('Median eye position by trial type');
axis square


% figure;
% for iTrialType = 1:length(trialNums)
%   % get color
%   c = getSmoothColor(iTrialType,length(trialNums),'hsv');
%   pupilsize = nanmean(e.eye.pupil(trialNums{iTrialType},:));
%   plot(e.eye.time,pupilsize,'Color',c);
%   xlabel('Time (sec)');
%   ylabel('Pupil Diameter (pix)');
%   title('Pupil Size');
%   hold on
% end
% 
% figure;
% for iTrialType = 1:length(trialNums)
%   % get color
%   c = getSmoothColor(iTrialType,length(trialNums),'hsv');
%   pupilsize = nanmedian(e.eye.pupil(trialNums{iTrialType},:));
%   plot(e.eye.time,pupilsize,'Color',c);
%   xlabel('Time (sec)');
%   ylabel('Pupil Diameter (pix)');
%   title('Pupil Size');
%   hold on
% end

figure;
for iTrialType = 1:length(trialNums)
  % get color
  c = getSmoothColor(iTrialType,length(trialNums),'hsv');
  pupilsize = nanmean(e.eye.pupil(trialNums{iTrialType},:));
  plot(e.eye.time,pupilsize,'Color',c);
end
ymin = 3200;
ymax = 4200;
% Plot vertical lines to indicate specific moments in experiment
% Adjust xlim and legend for the specific experiment
exp_times = [0.1 0.167 0.22 0.72 0.82 1.62 1.67];
for i = 1:size(exp_times,2)
    line([exp_times(1,i) exp_times(1,i)], [ymin ymax]);
end
xlabel('Time (sec)');
% Units for pupil diameter are in pixels
ylabel('Pupil Diameter');
xlim([0 1.7])
ylim([ymin ymax])
title('Mean Pupil Size');
legend('Pupil Size','Fixation','Cue','Blank','Stimuli','Blank','Response Cue','Answer','Location','NorthWest')
hold on

figure;
for iTrialType = 1:length(trialNums)
  % get color
  c = getSmoothColor(iTrialType,length(trialNums),'hsv');
  pupilsize = nanmedian(e.eye.pupil(trialNums{iTrialType},:));
  plot(e.eye.time,pupilsize,'Color',c);
end
ymin = 3200;
ymax = 4200;
% Plot vertical lines to indicate specific moments in experiment
exp_times = [0.1 0.167 0.22 0.72 0.82 1.62 1.67];
for i = 1:size(exp_times,2)
    line([exp_times(1,i) exp_times(1,i)], [ymin ymax]);
end
xlabel('Time (sec)');
ylabel('Pupil Diameter');
xlim([0 1.7])
ylim([ymin ymax])
title('Median Pupil Size');
hold on
legend('Pupil Size','Fixation','Cue','Blank','Stimuli','Blank','Response Cue','Answer','Location','NorthWest')
end
