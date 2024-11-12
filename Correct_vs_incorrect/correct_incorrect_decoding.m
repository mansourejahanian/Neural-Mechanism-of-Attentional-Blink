
% run this section to calculate correct vs incorrect decoding/temporal generalization and save the results

close all
clear all
clc

% needed path
path_codes = 'C:\__My Own Drive__\manuscript\Codes';
path_data = 'Z:\CNAI2\Mansoure';

%add functions
addpath(genpath(fullfile(path_codes, 'Correct_vs_incorrect','functions')));

% add statistics
addpath(fullfile(path_codes, 'Stat_visual'));

% add colors
colors;

% id of subjects
%N = [1 2 4 5 7 8 9 11 15 16 18 19 20:29 30:39 41 42];
N = [15, 16, 18:39, 41, 42];

% Do you want pairwise decoding (m=1) or temporal generalization (m=2)?
m = 1;

if m==1
    method_name = 'decoding';
else
    method_name = 'TG';
end

for i=N
    
    % change lag3 or lag7 based on desired lag
    %path_sub = fullfile(path_data,sprintf('subject%02d',i),'correct_incorrect_data',sprintf('sub%02d_band_lag3',i));
    path_sub = fullfile('C:\BrainStorm\brainstorm_db\EEG_Data\data', sprintf('Subject%02d',i), sprintf('sub%02d_band_T1L3',i));
    mean_decoding = BootStrap(path_sub,m);
    
    % save data
    % change lag3 or lag7 based on desired lag
    %path_save = fullfile(path_data,sprintf('subject%02d',i), 'correct_incorrect_data', 'decoding_lag3', sprintf('%s_sub%02d.mat',method_name, i));
    path_save = fullfile('C:\__My Own Drive__\Pilot Data\EEG\corrVSincorr\T1', sprintf('%s_sub%02d.mat',method_name, i));
    save(path_save,'mean_decoding');

end


%% run the following sections to plot saved results

% plot correct vs incorrect decoding

clear all
close all
clc

% needed path
path_codes = 'C:\__My Own Drive__\manuscript\Codes';
path_data = 'Z:\CNAI2\Mansoure';

%add functions
addpath(fullfile(path_codes, 'Correct_vs_incorrect','functions'));

% add statistics
addpath(fullfile(path_codes, 'Stat_visual'));

% add colors
colors;

% load time
load(fullfile(path_data,'time','time.mat'))
time = time*1000;

% id of subjects
N = [1 2 4 5 7 8 9 11 15 16 18 19 20:29 30:39 41 42];

nsubject = length(N);

%% average over all participants decoding

% load data

for i=1:nsubject
    path_save = fullfile(path_data,sprintf('subject%02d',N(i)), 'correct_incorrect_data', 'decoding_lag7', sprintf('decoding_sub%02d.mat',N(i)));
    load(path_save)
    decoding(i,:) = mean_decoding;
end

% calculate the error
error = std(decoding,[],1)./sqrt(nsubject);

% cluster correction parameters
nperm = 10000;
cluster_th = 0.05;
sig_th = 0.05;

% cluster correction
data = decoding-50;
[SigTime, clusters, clustersize, StatMapPermPV] = permutation_cluster_1sample(data, nperm, cluster_th, sig_th);


% plot the avearge decoding

figure
%subplot(2,1,1)
hold on
plot(time, mean(decoding,1), LineWidth=5, color=gray)
%fill([time fliplr(time)], [mean(decoding,1)+error , fliplr((mean(decoding,1)-error))], red ,FaceAlpha=0.2,linestyle='none');

% onset
xline(0, 'LineStyle','--', color='black', LineWidth=3)

% chance level
yline(50, 'LineStyle','--', color='black',LineWidth=3)

% show significance interval
if length(SigTime)>=1
    scatter(time(SigTime), 59, [], gray, 'filled');
end

xlim([-200 1000])
ylim([45 60])
%title(sprintf('T2 detected vs T2 not detected, Avg over %d participants', nsubject))
xlabel('Time (ms)')
ylabel('Decoding accuracy (%)')
legend('Correct VS Incorrect', box = 'off')

ax = gca;
ax.FontName = "Calibri";
ax.FontSize = 24;
ax.YTick = [45 50 60];
ax.XTick = [-200 0 200 400 600 800 1000];
ax.LineWidth = 3;
pbaspect([3.5 1.1 1])

%% average over all participants temporal generalization

%load data

for i=1:nsubject
    path_save = fullfile(path_data,sprintf('subject%02d',N(i)), 'correct_incorrect_data', 'temporalgen_lag3', sprintf('TG_sub%02d.mat',N(i)));
    load(path_save)
    tempgen(i,:,:) = squeeze(mean_decoding);
end

% cluster correction
nperm = 10000;
cluster_th = 0.01;
sig_th = 0.05;

data = tempgen-50;
[SigTimes, clusters,clustersize,StatMapPermPV] = permutation_cluster_1sample_2dim(data, nperm, cluster_th, sig_th);

% plot
figure
imagesc(time, time, squeeze(mean(tempgen,1)), [48 58])
hold on
contour(time,time,SigTimes,'LineColor','black',LineWidth=3)
xline(0, LineWidth=3, color="black")
yline(0, LineWidth=3, color="black")
%plot(time_short,time_short, color = "black")

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
c.Ticks = ([48 50 54 58]);
