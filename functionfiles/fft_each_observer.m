function fft_each_observer(task,average)
%% This function takes the difference of p1 and p2 for each observer and does an FFT on the results
%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

average_fft=[];
if average 
    displayFg = false;
else
    displayFg = true;
end

files = dir('C:\Users\Alice\Documents\MATLAB\data');  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2 || fileL == 3) && ~strcmp(obs(1,1),'.')
        [p1,p2] = p_probe_analysis(obs,task,false);
        if ~isempty(p1)
            [diff] = p1p2_difference(p1,p2,obs,task,displayFg);
            m_diff = mean(diff,2);
            fft_r=fft(m_diff);
            fft_results=abs(fft_r);
            average_fft = horzcat(average_fft,fft_results);
    %         figure; hold on;
    %         plot(fft_results,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
    %         ylabel('Amplitude','FontSize',15,'Fontname','Ariel')
    %         xlabel('Frequency (Hz)','FontSize',15,'Fontname','Ariel')
            if ~average
                figure; hold on;
                plot([2.8 5.6 8.3 11.1 13.9 16.7],fft_results(2:7),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
                ylabel('Amplitude','FontSize',15,'Fontname','Ariel')
                xlabel('Frequency (Hz)','FontSize',15,'Fontname','Ariel')
                set(gca,'XTick',[2.8 5.6 8.3 11.1 13.9 16.7],'FontSize',12,'LineWidth',2','Fontname','Ariel')    
                set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
                title(['FFT on the individual data (' obs ')'])
                namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task  '\figures\time\' obs '_' condition '_FFT']);
                print ('-djpeg', '-r500',namefig);  
            end
            
        end
    end
end

if average
    figure; hold on;
    plot([2.8 5.6 8.3 11.1 13.9 16.7],average_fft(2:7),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
    ylabel('Amplitude','FontSize',15,'Fontname','Ariel')
    xlabel('Frequency (Hz)','FontSize',15,'Fontname','Ariel')
    set(gca,'XTick',[2.8 5.6 8.3 11.1 13.9 16.7],'FontSize',12,'LineWidth',2','Fontname','Ariel')    
    set(gca,'YTick',0:.2:1.6,'FontSize',12,'LineWidth',2','Fontname','Ariel')
    title(['FFT on the individual data'])
    ylim([0 1])
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\main_' task '\time' condition '_FFT_each']);
    print ('-djpeg', '-r500',namefig); 
end
end