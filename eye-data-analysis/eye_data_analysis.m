%% Eye data analysis

cd /Volumes/Whitehead/Local/Users/dugue/MATLAB/MRI/Data/nms/exo/nms140929/etc

%% Eye statistics
e = getTaskEyeTraces('140929_stim01','dispFig=1', 'removeBlink=0');

%removeBlink=0 if you want to see the blinks
%removeBlink=10 if you want to remove 10ms around the blink

plot(e.eye.time, e.eye.xPos(30,:))

%% Access to the data
d = mglEyelinkEDFRead('14091601.edf');
mydata = d.gaze;


