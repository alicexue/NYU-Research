function p_search_slope(obs, task, date, oneBlock, blockN)

%%% Example
%%% p_search_slope('ax', 'difficult', '150709', false, 5)

%% Parameters

%obs = 'ax';
%task = 'difficult'
%date = '150709';
%oneBlock? = false;
%blockN = 5;

% if oneBlock == true, then only blockN is analyzed
% if oneBlock == false, then the blocks with a number <= blockN are analyzed

%% Obtain pboth, pone and pnone for each run and concatenate over run
rt4_avg=[];
rt8_avg=[];
perf4_avg=[];
perf8_avg=[];
strOneBlock = 'T';
tmp = blockN;
numBlocks = 1;

if oneBlock == false
    numBlocks = blockN;
    strOneBlock = 'F';
end   

for i = 1:numBlocks;
    if oneBlock == false
        tmp = i;
    end
    if tmp < 10
        strBlockN = ['0', num2str(tmp)];
    else
        strBlockN = num2str(tmp);
    end  
    s = ['C:\Users\Alice\Documents\MATLAB\data\', obs, '\', task, '\', date, '_stim', strBlockN, '.mat'];    
    exists = exist(s,'file');
    if oneBlock == true && exists == 0;
        errorStruct.message = 'Data file blockN not found.';
        errorStruct.identifier = 'p_search_slope:fileNotFound'; 
        error(errorStruct);
    end
    if exists ~= 0
        [rt4,rt8,perf4,perf8] = search_slope(date,obs,tmp,task);

        rt4_avg = horzcat(rt4_avg,rt4);
        rt8_avg = horzcat(rt8_avg,rt8);
        perf4_avg = horzcat(perf4_avg,perf4);
        perf8_avg = horzcat(perf8_avg,perf8);
    end
end

%% Plot reaction time
rt = [mean(rt4_avg) mean(rt8_avg)];
rt_std = [std(rt4_avg) std(rt8_avg)];

figure;hold on;
errorbar(4:4:8,rt*1000,rt_std*1000,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])

xlim([3 9])
set(gca,'XTick', 4:4:8,'FontSize',25,'LineWidth',2,'FontName','Times New Roman')
ylim([0 500])
%set(gca,'YTick', 50:10:100)

% title([obs ' ' condition],'FontSize',14)
xlabel('set size','FontSize',25,'FontName','Times New Roman')
ylabel('RT (ms)','FontSize',25,'FontName','Times New Roman')
namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\' task '\rt\' 'rtSetSize' strOneBlock num2str(blockN)]);
print ('-djpeg', '-r500',namefig);

%% Plot performance
p = [mean(perf4_avg) mean(perf8_avg)];
p_std = [std(perf4_avg) std(perf8_avg)];

figure;hold on;
errorbar(4:4:8,p*100,p_std*100,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])

xlim([3 9])
set(gca,'XTick', 4:4:8,'FontSize',25,'LineWidth',2,'FontName','Times New Roman')
ylim([50 100])
set(gca,'YTick', 50:20:100,'FontSize',25,'LineWidth',2,'FontName','Times New Roman')

% title([obs ' ' condition],'FontSize',14)
xlabel('set size','FontSize',25,'FontName','Times New Roman')
ylabel('Accuracy','FontSize',25,'FontName','Times New Roman')

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\' task '\perf\' 'perfSetSize' strOneBlock num2str(blockN)]);
print ('-djpeg', '-r500',namefig);

end