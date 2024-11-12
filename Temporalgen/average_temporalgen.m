

% save the data from the brainstorm

% N = 30;
% path = sprintf('C:\\__My Own Drive__\\Pilot Data\\EEG\\sub%02d\\tempgen',N);
% save(fullfile(path,sprintf('sub%02d_TG.mat',N)),'TG1','TG2','TG3','TG4')

%% temporal generalization

clear all;
close all;
clc;

% needed path
path_codes = 'C:\__My Own Drive__\manuscript\Codes';
path_data = 'Z:\CNAI2\Mansoure';

% add statistic function
addpath(fullfile(path_codes, 'Stat_visual'))

N = [1 2 4 5 7 8 9 11 15 16 18 19 20:29 30:39 41 42];

% ABM = zeros(2,length(N));
% ABM(1,:) = [1 2 4 5 7 8 9 11 15 16 18 19 21:29 31:39 41 42];
% ABM(2,:) = [5, 5, 4.5, 1.2, 12.3, 12.8, 0.6, 1.1, 4.3, 5.3, 18.6, 2.7, 6.6, 12.4, 11.4, -3.9, -2.8, 4.9, 2.2, 16, 12.3, 2.3, 6.1, 9.4, 7.9, 0.3, 4.8, 0.9, 0.7, 1.5, 8.6, -9.7];
% 
% nonblinker = ABM(1,ABM(2,:)<0);
% blinker = ABM(1,ABM(2,:)>0);
% 
% N = blinker;

nsubject = length(N);

% load decoding data
for i=1:nsubject

    path_sub = fullfile(path_data, sprintf('subject%02d',N(i)),'temporalgen');

    files = dir(fullfile(path_sub,'*.mat'));
    load(fullfile(files.folder, files.name));

    TG_T1lag3(i,:,:) = TG1.Value; % lag3
    TG_T1lag7(i,:,:) = TG2.Value; % lag7

    TG_T2lag3(i,:,:) = TG3.Value; % lag3
    TG_T2lag7(i,:,:) = TG4.Value; % lag7

end

time = (TG1.Time)*1000;

%% cluster correction statistical test

nperm = 100;
cluster_th = 0.01;
sig_th = 0.05;

data1 = TG_T1lag3-50;
data2 = TG_T1lag7-50;

data3 = TG_T2lag3-50;
data4 = TG_T2lag7-50;

[SigTime_T1lag3, clusters1,clustersize1,StatMapPermPV] = permutation_cluster_1sample_2dim(data1, nperm, cluster_th, sig_th);
[SigTime_T1lag7, clusters2,clustersize2,StatMapPermPV] = permutation_cluster_1sample_2dim(data2, nperm, cluster_th, sig_th);

[SigTime_T2lag3, clusters3,clustersize3,StatMapPermPV] = permutation_cluster_1sample_2dim(data3, nperm, cluster_th, sig_th);
[SigTime_T2lag7, clusters4,clustersize4,StatMapPermPV] = permutation_cluster_1sample_2dim(data4, nperm, cluster_th, sig_th);

%% plot all targets, time 1s

dtlag3 = 252;
dtlag7 = 588;

% T1 lag3

figure
subplot(2,2,3)
imagesc(time, time, squeeze(mean(TG_T1lag3,1)),[48.5 55])
hold on
contour(time,time,SigTime_T1lag3,'LineColor','black','LineWidth',3)
xline(0, LineWidth=3, color="black")
yline(0, LineWidth=3, color="black")

ax = gca;
ax.YDir = 'normal';
ax.FontSize = 24;
ax.FontName = "Calibri";
%ax.XTick = -200:200:1000;
%ax.XTickLabel = -200:200:1000;
%ax.YTick = -200:200:1000;
%ax.YTickLabel = -200:200:1000;

xlabel('Train time (ms)')
ylabel('Test time (ms)')
%title('T1 lag3')
pbaspect([1,1,1])
c = colorbar;
colormap("jet")
c.Label.String = 'Decoding accuracy (%)';
c.FontSize = 24;


% T1 lag7

subplot(2,2,1)
imagesc(time, time, squeeze(mean(TG_T1lag7,1)),[48.5 55])
hold on
contour(time,time,SigTime_T1lag7,'LineColor','black','LineWidth',3)
xline(0, LineWidth=3, color="black")
yline(0, LineWidth=3, color="black")

ax = gca;
ax.YDir = 'normal';
ax.FontSize = 24;
ax.FontName = "Calibri";
xlabel('Train time (ms)')
ylabel('Test time (ms)')
%title('T1 lag3')
pbaspect([1,1,1])
c = colorbar;
colormap("jet")
c.Label.String = 'Decoding accuracy (%)';
c.FontSize = 24;

% target 2
subplot(2,2,4)
imagesc(time, time, squeeze(mean(TG_T2lag3,1)),[48.5 55])
hold on
contour(time,time,SigTime_T2lag3,'LineColor','black','LineWidth',3)
xline(0, LineWidth=3, color="black")
yline(0, LineWidth=3, color="black")

ax = gca;
ax.YDir = 'normal';
ax.FontSize = 24;
ax.FontName = "Calibri";
xlabel('Train time (ms)')
ylabel('Test time (ms)')
%title('T1 lag3')
pbaspect([1,1,1])
c = colorbar;
colormap("jet")
c.Label.String = 'Decoding accuracy (%)';
c.FontSize = 24;

% T2 lag7
subplot(2,2,2)
imagesc(time, time, squeeze(mean(TG_T2lag7,1)),[48.5 55])
hold on
contour(time,time,SigTime_T2lag7,'LineColor','black','LineWidth',3)
xline(0, LineWidth=3, color="black")
yline(0, LineWidth=3, color="black")

ax = gca;
ax.YDir = 'normal';
ax.FontSize = 24;
ax.FontName = "Calibri";
xlabel('Train time (ms)')
ylabel('Test time (ms)')
%title('T1 lag3')
pbaspect([1,1,1])
c = colorbar;
colormap("jet")
c.Label.String = 'Decoding accuracy (%)';
c.FontSize = 24;


%% plot diff

% ttest difference
% nperm = 10000;
% cluster_th = 0.05;
% sig_th = 0.05;
% 
% data5 = data2 - data1;
% data6 = data4 - data3;
% 
% [SigTime_diffT1, clusters5,clustersize5,StatMapPermPV] = permutation_cluster_1sample_2dim(data5, nperm, cluster_th, sig_th);
% [SigTime_diffT2, clusters6,clustersize6,StatMapPermPV] = permutation_cluster_1sample_2dim(data6, nperm, cluster_th, sig_th);


diffT1 = squeeze(mean(TG_T1lag7,1)) - squeeze(mean(TG_T1lag3,1));

% T1
figure
subplot(2,1,1)
imagesc(time, time, diffT1)
hold on
contour(time,time,SigTime_diffT1,'LineColor','yellow')

ax = gca;
ax.YDir = 'normal';
xlabel('Training time', FontSize=12)
ylabel('Testing time', FontSize=12)
title('T1')
pbaspect([1,1,1])
c = colorbar;
colormap("jet")
c.Label.String = 'decoding accuracy';
c.FontSize = 12;

diffT2 = squeeze(mean(TG_T2lag7,1)) - squeeze(mean(TG_T2lag3,1));

% T2
subplot(2,1,2)
imagesc(time, time, diffT2)
hold on
contour(time,time,SigTime_diffT2,'LineColor','yellow')

ax = gca;
ax.YDir = 'normal';
xlabel('Training time', FontSize=12)
ylabel('Testing time', FontSize=12)
title('T2')
pbaspect([1,1,1])
c = colorbar;
colormap("jet")
c.Label.String = 'decoding accuracy';
c.FontSize = 12;
