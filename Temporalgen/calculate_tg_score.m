
% calculate temporal generalization score and do statistical test

%close all;
clear all;
clc; 

% needed path
path_codes = 'C:\__My Own Drive__\manuscript\Codes';
path_data = 'Z:\CNAI2\Mansoure';

% add statistics
addpath(fullfile(path_codes, 'Stat_visual'));

% add colors
colors;

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
    path_sub = fullfile(path_data, sprintf('subject%02d',N(i)),'temporalgen');
    files = dir(fullfile(path_sub,'*.mat'));
    load(fullfile(files.folder, files.name));

    TG_T1lag3(i,:,:) = TG1.Value; % lag3
    TG_T1lag7(i,:,:) = TG2.Value; % lag7

    TG_T2lag3(i,:,:) = TG3.Value; % lag3
    TG_T2lag7(i,:,:) = TG4.Value; % lag7

end

time = (TG1.Time)*1000;
time_short = time(1:513);

% you can choose to average with a window or with a specific step
% step is recommended since it has a constant length

%% averaging with bootstrapping step

stp = 102;
%stp = 205;
tp = round(size(TG_T1lag3,2)./stp);
ntest = 5000;

avg_T1L3 = zeros(ntest,tp,tp);
avg_T1L7 = zeros(ntest,tp,tp);

avg_T2L3 = zeros(ntest,tp,tp);
avg_T2L7 = zeros(ntest,tp,tp);

for i = 1:ntest

    r = randi([1 nsubject],1,nsubject);

    for j=1:tp
    for k=1:tp

        avg_T1L3(i,j,k) = mean(mean(mean(TG_T1lag3(r,stp*(j-1)+1:stp*j,stp*(k-1)+1:stp*k),3),2),1);
        avg_T1L7(i,j,k) = mean(mean(mean(TG_T1lag7(r,stp*(j-1)+1:stp*j,stp*(k-1)+1:stp*k),3),2),1);
    
        avg_T2L3(i,j,k) = mean(mean(mean(TG_T2lag3(r,stp*(j-1)+1:stp*j,stp*(k-1)+1:stp*k),3),2),1);
        avg_T2L7(i,j,k) = mean(mean(mean(TG_T2lag7(r,stp*(j-1)+1:stp*j,stp*(k-1)+1:stp*k),3),2),1);
    end
    end

end

%% averaging with bootstrapping window

% ntest = 1000;
% 
% WT = [-200:200:1000];
% tp = length(WT)-1;
% 
% avg_T1L3 = zeros(ntest,tp,tp);
% avg_T1L7 = zeros(ntest,tp,tp);
% 
% avg_T2L3 = zeros(ntest,tp,tp);
% avg_T2L7 = zeros(ntest,tp,tp);
% 
% for i = 1:ntest
% 
%     r = randi([1 nsubject],1,nsubject);
% 
%     for j=1:tp
% 
%         windowj = find(time > WT(j) & time < WT(j+1));
% 
%     for k=1:tp
% 
%         windowk = find(time > WT(k) & time < WT(k+1));
% 
%         avg_T1L3(i,j,k) = mean(mean(mean(TG_T1lag3(r,windowj,windowk),3),2),1);
%         avg_T1L7(i,j,k) = mean(mean(mean(TG_T1lag7(r,windowj,windowk),3),2),1);
%     
%         avg_T2L3(i,j,k) = mean(mean(mean(TG_T2lag3(r,windowj,windowk),3),2),1);
%         avg_T2L7(i,j,k) = mean(mean(mean(TG_T2lag7(r,windowj,windowk),3),2),1);
%     end
%     end
% 
% end

%% statistical test

diff1 = avg_T1L7 - avg_T1L3;
diff2 = avg_T2L7 - avg_T2L3;

p1 = zeros(tp,tp);
p2 = zeros(tp,tp);

for j=1:tp
for k=1:tp

    p1(j,k) = sum(diff1(:,j,k)<0)./size(diff1,1);
    p2(j,k) = sum(diff2(:,j,k)<0)./size(diff2,1);

end
end

% FDR multiple comparison
[p1_corr, ~] = fdr(p1(:), 0.05);
p1_corrected = reshape(p1_corr,[tp,tp]);

[p2_corr, ~] = fdr(p2(:), 0.05);
p2_corrected = reshape(p2_corr,[tp,tp]);


%% plot

figure
% T1
subplot(1,2,1)
p = squeeze(mean(diff1,1));
imagesc(p,[-1,1])
hold on
[i,j]=find(p1_corrected);
scatter(i,j, 600, '*','k')

ax = gca;
ax.YDir = 'normal';
xlabel('Train time (ms)')
ylabel('Test time (ms)')
ax.XTick = [1.5 2.5 3.5 4.5 5.5 6.5];
ax.XTickLabel = [0 200 400 600 800 1000];
ax.YTick = [0.5 1.5 2.5 3.5 4.5 5.5 6.5];
ax.YTickLabel = [-200 0 200 400 600 800 1000];
ax.YTickLabelRotation = 45;
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.FontName = 'Calibri';
ax.FontSize = 24;
pbaspect([1,1,1])
c = colorbar;
colormap("jet")
%c.Label.String = 'Average decoding accuracy';
c.FontSize = 26;
c.Ticks = [-1 0 1];
c.TickLabels = [-1 0 1];

% T2
subplot(1,2,2)
p = squeeze(mean(diff2,1));
imagesc(p,[-1,1])
hold on
[i,j]=find(p2_corrected);
scatter(i,j,600,'*','black')

ax = gca;
ax.YDir = 'normal';
xlabel('Train time (ms)')
ylabel('Test time (ms)')
ax.XTick = [1.5 2.5 3.5 4.5 5.5 6.5];
ax.XTickLabel = [0 200 400 600 800 1000];
ax.YTick = [0.5 1.5 2.5 3.5 4.5 5.5 6.5];
ax.YTickLabel = [-200 0 200 400 600 800 1000];
ax.YTickLabelRotation = 45;
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.FontName = 'Calibri';
ax.FontSize = 26;
pbaspect([1,1,1])
c = colorbar;
colormap("jet")
c.Label.String = 'Decoding accuracy difference (%)';
c.FontSize = 26;
c.Ticks = [-1 0 1];
c.TickLabels = [-1 0 1];
