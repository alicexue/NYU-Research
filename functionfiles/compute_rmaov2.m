function compute_rmaov2(task)
%% This function loads the p1 p2 data into a matrix and does RMAOV2
p1 = zeros(10000,4);
p2 = zeros(10000,4);

index = 1;
numObs = 0;

files = dir('C:\Users\Alice\Documents\MATLAB\data');  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2 || fileL == 3) && ~strcmp(obs(1,1),'.')
        [p1obs,p2obs] = p_probe_analysis(obs,task,false);
        p1(index:index+12,1) = p1obs;
        p2(index:index+12,1) = p2obs;
        
        p1(index:index+12,4) = numObs+1;
        p2(index:index+12,4) = numObs+1;        
        numObs = numObs + 1;
    end
end
end