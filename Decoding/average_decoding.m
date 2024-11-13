
% save the data from the brainstorm
% N = 15;
% path = sprintf('C:\\__My Own Drive__\\Pilot Data\\EEG\\sub%02d\\decoding',N);
% save(fullfile(path,sprintf('sub%02d_decoding.mat',N)),'decoding1','decoding2','decoding3','decoding4')

%% average decoding accuracy across participants

close all;
clear all;
clc

% needed path
path_codes = 'C:\__My Own Drive__\manuscript\Codes';
path_data = 'Z:\CNAI2\Mansoure';

% add statistic functions and color
addpath(fullfile(path_codes, 'Stat_visual'));
addpath(fullfile(path_codes, 'decoding', 'functions'));
colors;

% subjects number
N = [1 2 4 5 7 8 9 11 15 16 18 19 20:29 30:39 41 42];

% ABM = zeros(2,length(N));
% ABM(1,:) = [1 2 4 5 7 8 9 11 15 16 18 19 21:29 31:39 41 42];
% ABM(2,:) = [5, 5, 4.5, 1.2, 12.3, 12.8, 0.6, 1.1, 4.3, 5.3, 18.6, 2.7, 6.6, 12.4, 11.4, -3.9, -2.8, 4.9, 2.2, 16, 12.3, 2.3, 6.1, 9.4, 7.9, 0.3, 4.8, 0.9, 0.7, 1.5, 8.6, -9.7];
% 
% nonblinker = ABM(1,ABM(2,:)<0);
% blinker = ABM(1,ABM(2,:)>0);
% N = blinker;

nsubject = length(N);


% load decoding data
for i=1:nsubject
    path_sub = fullfile(path_data, sprintf('subject%02d',N(i)),'decoding');
    files = dir(fullfile(path_sub,'*.mat'));
    load(fullfile(files.folder, files.name));

    decoding_T1lag3(:,i) = decoding1.Value; % lag3
    decoding_T1lag7(:,i) = decoding2.Value; % lag7

    decoding_T2lag3(:,i) = decoding3.Value; % lag3
    decoding_T2lag7(:,i) = decoding4.Value; % lag7

end

% load time
time = (decoding1.Time)*1000;


%% plot individual participants

figure
t = tiledlayout(6,6);
for i=1:nsubject
    nexttile
    plot(time,decoding_T1lag3(:,i),color = blue1,LineWidth=2)
    title(sprintf("S%d",N(i)))
    yline(50,LineWidth=2)
    xline(0,LineWidth=2)

    xlim([-200 1000])
    ylim([40 65])
    %set(gca,'YTickLabel',[]);
end
title(t, "T1 lag3")
xlabel(t, "Time")
ylabel(t, "Decoding accuracy")


figure
t = tiledlayout(6,6);
for i=1:nsubject
    nexttile
    plot(time,decoding_T1lag7(:,i),color = blue1,LineWidth=2)
    title(sprintf("S%d",N(i)))
    yline(50,LineWidth=2)
    xline(0,LineWidth=2)

    xlim([-200 1000])
    ylim([40 65])
end

title(t, "T1 lag7")
xlabel(t, "Time")
ylabel(t, "Decoding accuracy")


figure
t = tiledlayout(6,6);
for i=1:nsubject
    nexttile
    plot(time,decoding_T2lag3(:,i),color = red1,LineWidth=2)
    title(sprintf("S%d",N(i)))
    yline(50,LineWidth=2)
    xline(0,LineWidth=2)

    xlim([-200 1000])
    ylim([40 65])
    %set(gca,'YTickLabel',[]);
end
title(t, "T2 lag3")
xlabel(t, "Time")
ylabel(t, "Decoding accuracy")


figure
t = tiledlayout(6,6);
for i=1:nsubject
    nexttile
    plot(time,decoding_T2lag7(:,i),color = red1,LineWidth=2)
    title(sprintf("S%d",N(i)))
    yline(50,LineWidth=2)
    xline(0,LineWidth=2)

    xlim([-200 1000])
    ylim([40 65])
end
title(t, "T2 lag7")
xlabel(t, "Time")
ylabel(t, "Decoding accuracy")

%% Average over all participants

% average for T1 lag3 condition
mean_decoding_T1lag3 = mean(decoding_T1lag3,2);
error_T1lag3 = std(decoding_T1lag3,[],2)./sqrt(nsubject);
% find max
[max_T1lag3,imax_T1lag3]= max(mean_decoding_T1lag3);

% average for T1 lag7 condition
mean_decoding_T1lag7 = mean(decoding_T1lag7,2);
error_T1lag7 = std(decoding_T1lag7,[],2)./sqrt(nsubject);
% find max
[max_T1lag7,imax_T1lag7]= max(mean_decoding_T1lag7);

% average for T2 lag3 condition
mean_decoding_T2lag3 = mean(decoding_T2lag3,2);
error_T2lag3 = std(decoding_T2lag3,[],2)./sqrt(nsubject);
% find max
[max_T2lag3,imax_T2lag3]= max(mean_decoding_T2lag3);

% average for T2 lag7 condition
mean_decoding_T2lag7 = mean(decoding_T2lag7,2);
error_T2lag7 = std(decoding_T2lag7,[],2)./sqrt(nsubject);
% find max
[max_T2lag7,imax_T2lag7]= max(mean_decoding_T2lag7);

%% Cluster correction statistical test

% cluster correction parameters
nperm = 10000;
cluster_th = 0.05;
sig_th = 0.05;

% T1 lag3
data = decoding_T1lag3'-50;
[SigTime_T1lag3, clusters, clustersize, StatMapPermPV] = permutation_cluster_1sample(data, nperm, cluster_th, sig_th);

% T1 lag7
data = decoding_T1lag7'-50;
[SigTime_T1lag7, clusters, clustersize, StatMapPermPV] = permutation_cluster_1sample(data, nperm, cluster_th, sig_th);

% T2 lag3
data = decoding_T2lag3'-50;
[SigTime_T2lag3, clusters, clustersize, StatMapPermPV] = permutation_cluster_1sample(data, nperm, cluster_th, sig_th);

% T2 lag7
data = decoding_T2lag7'-50;
[SigTime_T2lag7, clusters, clustersize, StatMapPermPV] = permutation_cluster_1sample(data, nperm, cluster_th, sig_th);

% % difference

% data = decoding_T1lag7' - decoding_T1lag3';
% [SigTime_T1, clusters1, clustersize, StatMapPermPV] = permutation_cluster_1sample(data, nperm, cluster_th, sig_th);
% 
% data = decoding_T2lag7' - decoding_T2lag3';
% [SigTime_T2, clusters2, clustersize, StatMapPermPV] = permutation_cluster_1sample(data, nperm, cluster_th, sig_th);

%% ttest statistical test

% % one tail ttest T1 lag3
% chance_level = 50;
% 
% for i=1:length(time)
%     [h_T1lag3(i), P_T1lag3(i)] = ttest(decoding_T1lag3(i,:), chance_level, Alpha= 0.001, Tail="right");
% end
% 
% % one tail ttest T1 lag7
% for i=1:length(time)
%     [h_T1lag7(i), P_T1lag7(i)] = ttest(decoding_T1lag7(i,:), chance_level, Alpha= 0.001, Tail="right");
% end
% 
% % one tail ttest T2 lag3
% for i=1:length(time)
%     [h_T2lag3(i), P_T2lag3(i)] = ttest(decoding_T2lag3(i,:), chance_level, Alpha= 0.001, Tail="right");
% end
% 
% % one tail ttest T2 lag7
% for i=1:length(time)
%     [h_T2lag7(i), P_T2lag7(i)] = ttest(decoding_T2lag7(i,:), chance_level, Alpha= 0.001, Tail="right");
% end


%% plot all conditions

% plot T1 lag3
figure
subplot(2,2,1)
hold on
plot(time,mean_decoding_T1lag3,color = blue1,LineWidth=3)
fill([time fliplr(time)], [(mean_decoding_T1lag3+error_T1lag3)' (fliplr((mean_decoding_T1lag3-error_T1lag3)'))],blue1,FaceAlpha=0.2,linestyle='none')

% plot onset
xline(0,LineStyle='--',LineWidth=2,color='black')
% chance level
yline(50,LineStyle="--",LineWidth=2,color='black')

% show the max
scatter(time(imax_T1lag3),1.01*max_T1lag3,Marker='v',MarkerEdgeColor='black',MarkerFaceColor='black')
text(time(imax_T1lag3),1.01*max_T1lag3+1,[num2str(round(time(imax_T1lag3),3)),' s'], fontsize=11)

% show significance interval
% cluster correction
if size(SigTime_T1lag3,2)>1
    scatter(time(SigTime_T1lag3), 57, 'filled', 'black');
end
%scatter(time(h_T1lag3==1), 57, 'filled', 'black');

xlim([-200 1000])
ylim([46 58])
xlabel('time (ms)')
ylabel('decoding accuracy')
legend('AVG','SE','T1 onset', 'Chance level', 'Peak', 'Significant',Location='bestoutside')
title( sprintf('Avg over %d Participants, T1 lag3' , nsubject) )
hold off

% plot T1 lag7
%figure
subplot(2,2,2)
hold on
plot(time,mean_decoding_T1lag7,color = blue1,LineWidth=3)
fill([time fliplr(time)], [(mean_decoding_T1lag7+error_T1lag7)' (fliplr((mean_decoding_T1lag7-error_T1lag7)'))],blue1,FaceAlpha=0.2,linestyle='none')

% plot onset
xline(0,LineStyle='--',LineWidth=2,color='black')
% chance level
yline(50,LineStyle="--",LineWidth=2,color='black')

% show the max
scatter(time(imax_T1lag7),max_T1lag7,Marker='v',MarkerEdgeColor='black',MarkerFaceColor='black')
text(time(imax_T1lag7),max_T1lag7+1,[num2str(round(time(imax_T1lag7),3)),' s'], fontsize=11)

% show significance interval
if size(SigTime_T1lag7,2)>1
    scatter(time(SigTime_T1lag7), 57, 'filled', 'black');
end
% ttest
%scatter(time(h_T1lag7==1), 57, 'filled', 'black');

xlim([-200 1000])
ylim([46 58])
xlabel('time (ms)')
ylabel('decoding accuracy')
title(sprintf('Avg over %d Participants, T1 lag7' , nsubject))
legend('AVG','SE','T1 onset', 'Chance level', 'Peak', 'Significant',Location='bestoutside')
hold off

% plot T2 lag3
%figure
subplot(2,2,3)
hold on
plot(time,mean_decoding_T2lag3,color = red1,LineWidth=3)
fill([time fliplr(time)], [(mean_decoding_T2lag3+error_T2lag3)' (fliplr((mean_decoding_T2lag3-error_T2lag3)'))],red1,FaceAlpha=0.2,linestyle='none')

% plot onset
xline(0,LineStyle='--',LineWidth=2,color='black')
% chance level
yline(50,LineStyle="--",LineWidth=2,color='black')

% show the max
scatter(time(imax_T2lag3),max_T2lag3,Marker='v',MarkerEdgeColor='black',MarkerFaceColor='black')
text(time(imax_T2lag3),max_T2lag3+1,[num2str(round(time(imax_T2lag3),3)),' s'], fontsize=11)

% show significance interval
if size(SigTime_T2lag3,2)>1
    scatter(time(SigTime_T2lag3), 57, 'filled', 'black');
end
% ttest
%scatter(time(h_T2lag3==1), 57, 'filled', 'black');

xlim([-200 1000])
ylim([46 58])
xlabel('time (ms)')
ylabel('decoding accuracy')
legend('AVG','SE','T2 onset', 'Chance level', 'Peak', 'Significant',Location='bestoutside')
title(sprintf('Avg over %d Participants, T2 lag3' , nsubject))
hold off


% plot T2 lag7
%figure
subplot(2,2,4)
hold on
plot(time,mean_decoding_T2lag7,color = red1,LineWidth=3)
fill([time fliplr(time)], [(mean_decoding_T2lag7+error_T2lag7)' (fliplr((mean_decoding_T2lag7-error_T2lag7)'))],red1,FaceAlpha=0.2,linestyle='none')

% plot onset
xline(0,LineStyle='--',LineWidth=2,color='black')
% chance level
yline(50,LineStyle="--",LineWidth=2,color='black')

% show the max
scatter(time(imax_T2lag7),max_T2lag7,Marker='v',MarkerEdgeColor='black',MarkerFaceColor='black')
text(time(imax_T2lag7),max_T2lag7+1,[num2str(round(time(imax_T2lag7),3)),' s'], fontsize=11)

% show significance interval
if size(SigTime_T2lag7,2)>1
    scatter(time(SigTime_T2lag7), 57, 'filled', 'black');
end
% ttest
%scatter(time(h_T2lag7==1), 57, 'filled', 'black');

xlim([-200 1000])
ylim([46 58])
xlabel('time (ms)')
ylabel('decoding accuracy')
legend('AVG','SE','T2 onset', 'Chance level', 'Peak', 'Significant',Location='bestoutside')
title(sprintf('Avg over %d Participants, T2 lag7' , nsubject))
hold off


%% plot T1 and T2 in each lag

% plot lag 7 condition for T1 and T2

dtlag3 = 252;
dtlag7 = 588;

f1=figure;
f1.Position = [100 100 1000 400];
hold on
plot(time, mean_decoding_T1lag7, Color=blue1,LineWidth=5)
plot(time+dtlag7, mean_decoding_T2lag7, Color=red1,LineWidth=5)

% plot T1 onset
xline(0,LineStyle='--',LineWidth=3,color=blue1)
% plot T2 onset
xline(dtlag7,LineStyle="--",LineWidth=3,color=red1)
% chance level
yline(50,LineStyle="--",LineWidth=3,color='black')

% significance
if size(SigTime_T1lag7,2)>1
    scatter(time(SigTime_T1lag7), 55.5, [], blue1, 'filled');
end
if size(SigTime_T2lag7,2)>1
    scatter(time(SigTime_T2lag7)+dtlag7, 55.8, [], red1, 'filled');
end

xlim([-200 1200])
ylim([46 56])
ax = gca;
ax.FontSize = 22;
ax.LineWidth = 3;
ax.FontName = 'Calibri';
pbaspect([3.3 1 1])
ax.YTick = ([46 50 56]);
ax.YTickLabel = ([46 50 56]);
ax.YLabel.Position(1) = -280;
xlabel('Time (ms)')
%title('Lag 7')
ylabel('Decoding accuracy (%)')
legend('T1','T2','T1 onset','T2 onset', Location='bestoutside',box='off',Fontsize=24)


% plot lag 3 condition for T1 and T2 

f2=figure;
f2.Position = [100 100 1000 400];
hold on
% plot T1 decoding
plot(time,mean_decoding_T1lag3, LineWidth=5,Color=blue1)
% plot T2 decoding
plot(time+dtlag3,mean_decoding_T2lag3, LineWidth=5, Color=red1)


% plot T1 onset
xline(0,LineStyle='--',LineWidth=3,color=blue1)
% plot T2 onset
xline(dtlag3,LineStyle="--",LineWidth=3,color=red1)
% chance level
yline(50,LineStyle="--",LineWidth=3,color='black')

% significancy
if size(SigTime_T1lag3,2)>1
    scatter(time(SigTime_T1lag3), 55.5, [], blue1, 'filled');
end
if size(SigTime_T2lag3,2)>1
    scatter(time(SigTime_T2lag3)+dtlag3, 55.8, [], red1, 'filled');
end

xlim([-200 1200])
ylim([46 56])
ax = gca;
ax.FontSize = 22;
ax.LineWidth = 3;
ax.FontName = 'Calibri';
ax.YTick = ([46 50 56]);
ax.YTickLabel = ([46 50 56]);
pbaspect([3.3 1 1])
ax.YLabel.Position(1) = -280;

legend('T1','T2','T1 onset','T2 onset', Location='bestoutside',box='off',Fontsize=24)
xlabel('Time (ms)')
ylabel('Decoding accuracy (%)')
%title('Lag 3')
%title(sprintf('Avg over %d Participants, lag3' , nsubject))
hold off



%% plot lag 3 and lag 7 for each target

% plot target1

figure
subplot(2,1,1)
hold on
plot(time,mean_decoding_T1lag3,Color=[0 0.4470 0.7410],LineWidth=5)
plot(time,mean_decoding_T1lag7, Color=[0 0.4470 0.7410 0.5],LineWidth=5)

plot([0 0],[40 60], 'LineStyle','--', Color=[0 0.4470 0.7410],LineWidth=3)
% chance level
plot([-200 1000],[50 50],'black','LineStyle','--',LineWidth=3)

% significancy
scatter(time(SigTime_T1lag3), 57, [], [33 102 172]./256, 'filled');
scatter(time(SigTime_T1lag7), 57.5, [], [33 102 172]./256, 'filled', 'MarkerFaceAlpha', 0.3);

ax = gca;
ax.FontSize = 20;
ax.LineWidth = 2;
ax.FontName = 'arial';

xlim([-200 1000])
ylim([46 58])
title('T1')
xlabel('Time (ms)')
ylabel('Decoding accuracy (%)')
legend('lag3','lag7','T1 onset', Location='bestoutside',box='off')
pbaspect([3.4 1 1])
hold off


% plot target 2

%figure
subplot(2,1,2)
hold on
plot(time,mean_decoding_T2lag3, Color=[0.6350 0.0780 0.1840 1],LineWidth=5)
plot(time,mean_decoding_T2lag7, Color=[0.6350 0.0780 0.1840 0.5],LineWidth=5)

plot([0 0],[40 60], 'LineStyle','--', Color=[0.6350 0.0780 0.1840 1],LineWidth=3)

% chance level
plot([-200 1000],[50 50],'black','LineStyle','--',LineWidth=3)

% significancy
scatter(time(SigTime_T2lag3), 57, [], [178 24 43]./256, 'filled');
scatter(time(SigTime_T2lag7), 57.5, [], [178 24 43]./256, 'filled', 'MarkerFaceAlpha', 0.3);

ax = gca;
ax.FontSize = 20;
ax.LineWidth = 2;
ax.FontName = 'arial';

xlim([-200 1000])
ylim([46 58])
%title(sprintf('Avg over %d Participants, T2' , nsubject))
title('T2')
xlabel('Time (ms)')
ylabel('Decoding accuracy (%)')
legend('lag3','lag7','T2 onset', Location='bestoutside',box='off')
pbaspect([3.4 1 1])

hold off


%% plot both lags and both targets on one figure

figure
hold on
plot(time,lowpass(mean_decoding_T1lag3, 30, 512, ImpulseResponse='iir'), LineWidth=4, Color=blue1)
plot(time,lowpass(mean_decoding_T1lag7, 30, 512, ImpulseResponse='iir'), LineWidth=4, Color=[33,102,172 154]./256)

%plot(time,lowpass((mean_decoding_T1lag3+mean_decoding_T1lag7)./2, 30, 512, ImpulseResponse='iir'), LineWidth=4, Color=[0 0.4470 0.7410 1])

plot(time+dtlag3,lowpass(mean_decoding_T2lag3, 30, 512, ImpulseResponse='iir'), LineWidth=4, Color=red1)
plot(time+dtlag7,lowpass(mean_decoding_T2lag7, 30, 512, ImpulseResponse='iir'), LineWidth=4, Color=[178 24 43 154]./256)

% chance level
plot([-200 1200],[50 50],'black','LineStyle','--',Linewidth=1.5)

% onset of second T
plot([0 0],[40 60], 'LineStyle','--', Linewidth=1.5, Color=blue1)
plot([dtlag3 dtlag3],[40 60], 'LineStyle','--', Linewidth=1.5, Color=red1)
plot([dtlag7 dtlag7],[40 60], 'LineStyle','--', Linewidth=1.5, Color=red1)

scatter(time(SigTime_T1lag3), 56, [], [33 102 172]./256, 'filled');
scatter(time(SigTime_T1lag7), 56.2, [], [33 102 172]./256, 'filled', 'MarkerFaceAlpha', 0.3);
scatter(time(SigTime_T2lag3)+dtlag3, 56.4, [], [178 24 43]./256, 'filled');
scatter(time(SigTime_T2lag7)+dtlag7, 56.6, [], [178 24 43]./256, 'filled', 'MarkerFaceAlpha', 0.3);

xlim([-200 1200])
ylim([46 58])
title(['Avg over ' num2str(nsubject) ' Participants'])
xlabel('time')
ylabel('decoding accuracy')
legend('T1 lag3','T1 lag7','T2 lag3','T2 lag7', 'chance level', 'T1 onset', 'T2 onset', '' ,'Significant',Location='bestoutside')
hold off


