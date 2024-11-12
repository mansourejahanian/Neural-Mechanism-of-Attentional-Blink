
% This script calculate the accuracy of reporting targets

close all;
clear all;
clc;

% needed path
path_codes = 'C:\__My Own Drive__\manuscript\Codes';
path_data = 'Z:\CNAI2\Mansoure';

% add functions
addpath(fullfile(path_codes, 'Behavior', 'functions'));

% add color
addpath(fullfile(path_codes, 'Stat_visual'))
colors;

% load images
filetype = 'jpg';
directory = fullfile(path_codes, 'Stimuli', 'Orig stimuli', 'Targets');
im = load_images(filetype,directory);

% parameters
% which subjects? 
N = [1 2 4 5 7 8 9 11 15 16 18 19 20:29 30:39 41 42];
p.nsubjects = length(N);
p.ntarget = 16;

% for 2 lags conditions
p.lags = [3,7];
p.nlag = length(p.lags);
p.nrun = 22;
p.block_size = p.ntarget*p.nlag;

% load data
result = cell(1,p.nsubjects);
trial = cell(1,p.nsubjects);

for i=1:p.nsubjects
    % data path

    %path_sub = sprintf(strcat(path_data, '\\subject%02d\\behavior_data'),N(i));
    path_sub = fullfile(path_data, sprintf('subject%02d',N(i)),'behavior_data');
    
    files = dir(fullfile(path_sub, '*.mat'));
    
    result{i} = load(fullfile(files.folder, files.name), 'result').result;
    trial{i} = load(fullfile(files.folder, files.name), 'trial').trial;

end

%% for one participants 

% which participant? change N==32
NP = find(N==19);

% calculate the accuracy of reporting targets as a function of lags
% display = 1 indicates that we want all the plots to be displayed
[Acc_T1_lags, Acc_T2_lags] = Accuracy_Report(trial{NP}, result{NP}, p, 1);

% attentional blink magnitude
ABM1 = ((Acc_T1_lags(1)-Acc_T2_lags(1))./Acc_T1_lags(1) + (Acc_T1_lags(2)-Acc_T2_lags(2))./Acc_T1_lags(2) )/2*100;
ABM2 = (Acc_T2_lags(2)- Acc_T2_lags(1))*100;

% Calculate the accuracy as a function of images
%[Acc_T1_im, Acc_T2_im, CT1, CT2] = Accuracy_Images(trial{NP}, result{NP}, im, p, 1);

%% for all participants

% for first 2 subjects

for i=1:2
    p.nrun = 20;
    %p.nrun = 9;
    % calculate the accuracy of reporting targets as a function of lags
    % display = 0 indicates that we do not need to show the plots
    [Acc_T1_lags_all(i,:), Acc_T2_lags_all(i,:)] = Accuracy_Report(trial{i},result{i},p,0);
    
    % Calculate wthe accuracy as a function of images
    [Acc_T1_im_all(i,:), Acc_T2_im_all(i,:), Acc_T1_im_lags(i,:,:), Acc_T2_im_lags(i,:,:)] = Accuracy_Images(trial{i},result{i},im,p,0);

end


for i=3:p.nsubjects
    p.nrun = 22;
    %p.nrun = 11;
    % calculate the accuracy of reporting targets as a function of lags
    % display = 0 indicates that we do not need to show the plots
    [Acc_T1_lags_all(i,:), Acc_T2_lags_all(i,:)] = Accuracy_Report(trial{i},result{i},p,0);
    
    % Calculate wthe accuracy as a function of images
    [Acc_T1_im_all(i,:), Acc_T2_im_all(i,:), Acc_T1_im_lags(i,:,:), Acc_T2_im_lags(i,:,:)] = Accuracy_Images(trial{i},result{i},im,p,0);

end

% average over participants
mean_Acc_T1_lags = mean(Acc_T1_lags_all,1);
mean_Acc_T2_lags = mean(Acc_T2_lags_all,1);

error_T1_lags = std(Acc_T1_lags_all,[],1)./sqrt(p.nsubjects);
error_T2_lags = std(Acc_T2_lags_all,[],1)./sqrt(p.nsubjects);

mean_Acc_T1_im = mean(Acc_T1_im_all,1);
mean_Acc_T2_im = mean(Acc_T2_im_all,1);

error_T1_im = std(Acc_T1_im_all,[],1)./sqrt(p.nsubjects);
error_T2_im = std(Acc_T2_im_all,[],1)./sqrt(p.nsubjects);

mean_Acc_T1_im_lags = squeeze(mean(Acc_T1_im_lags,1));
mean_Acc_T2_im_lags = squeeze(mean(Acc_T2_im_lags,1));
%% histogram performance

x = 0.1:0.1:1;

figure
hold on
scatter(Acc_T1_lags_all(:,1),Acc_T1_lags_all(:,2),200,'filled')
scatter(Acc_T2_lags_all(:,1),Acc_T2_lags_all(:,2),200,'filled')

for i=1:p.nsubjects
text(Acc_T1_lags_all(i,1),Acc_T1_lags_all(i,2),num2str(i),FontSize=14)
text(Acc_T2_lags_all(i,1),Acc_T2_lags_all(i,2),num2str(i),FontSize=14)
end

xlabel('Acc Lag 3')
ylabel('Acc Lag 7')
legend('T1', 'T2', box = 'off',Location='bestoutside')
xlim([0.1,1])
ylim([0.1,1])
plot(x,x, LineWidth=4, color="black")
pbaspect([1 1 1])
ax = gca;
ax.LineWidth= 4;
ax.FontSize= 20;

%outlier
outlier = find(isoutlier(Acc_T1_lags_all(:,2),'mean'));


%% Accuracy as a function of lags

xlags = [4.2 4.35];
xr = randn(p.nsubjects);
figure
hold on

% showing all participants performance
for i=1:p.nsubjects
    scatter(xlags+xr(i)*0.015, Acc_T1_lags_all(i,:).*100, 200, blue1, 'o', 'filled', 'MarkerFaceAlpha', 0.3)
    scatter(xlags+xr(i)*0.015, Acc_T2_lags_all(i,:).*100, 200, red1, 'o', 'filled', 'MarkerFaceAlpha', 0.3)
end

% showing average performance
errorbar(xlags,mean_Acc_T1_lags.*100,error_T1_lags.*100,LineWidth=4, LineStyle = ":", color= blue1, CapSize=18)
p1 = plot(xlags,mean_Acc_T1_lags.*100,'-o',LineWidth=10, color= blue1);
errorbar(xlags, mean_Acc_T2_lags.*100, error_T2_lags.*100, LineWidth=4, color =red1, CapSize=18)
p2 = plot(xlags, mean_Acc_T2_lags.*100, '-o', LineWidth=10, color = red1);

ax=gca;
ax.XLim = [xlags(1)-0.08, xlags(2)+0.08];
ax.YLim = [30 100];
ax.YTick = [40,60,80,100];
ax.XTick = xlags;
ax.XTickLabel = ({'Lag 3','Lag 7'});
ax.FontSize = 48;
ax.LineWidth = 6;
ax.FontName = 'Calibri';
ylabel('Performance (%)')

% ttest between lag 3 and lag 7
height1 = (mean_Acc_T1_lags(2)+mean_Acc_T1_lags(1)).*50 +1;
height2 = (mean_Acc_T2_lags(2)+mean_Acc_T2_lags(1)).*50 +1;

[pv2, stat2] = ttest_function(Acc_T2_lags_all(:,end),Acc_T2_lags_all(:,end-1),p, height1./100);
[pv1, stat1] = ttest_function(Acc_T1_lags_all(:,end),Acc_T1_lags_all(:,end-1),p, height2./100);

%pv3 = ttest_function(Acc_T2_lags_all(:,end-1),Acc_T1_lags_all(:,end-1),p, height1./100);
%pv4 = ttest_function(Acc_T2_lags_all(:,end),Acc_T1_lags_all(:,end),p, height1./100);

legend([p1, p2], 'T1', 'T2|T1', Location='bestoutside',box='off');
pbaspect([1 1.6 1])

hold off

%% Accuracy as a function of images

% correct T1
figure
bar(1:p.ntarget,mean_Acc_T1_im,0.5,'EdgeColor','none',FaceColor=blue1)
hold on
errorbar(1:p.ntarget,mean_Acc_T1_im,error_T1_im./2,error_T1_im./2,LineWidth=2,color='black',LineStyle='none')
%title('correct T1 for all participants')
ylabel('performance')
ylim([0 1])
xticks([])
set(gca,'FontSize',20)
grid on

% labels
for i = 1:p.ntarget
ax(i) = axes('Position',[0.14+0.045*(i-1) 0.02 0.08 0.08]); % desired position
imshow(im{i});
end

% correct T2
figure
bar(1:p.ntarget,mean_Acc_T2_im,0.5,'EdgeColor','none',FaceColor=red1);
hold on
errorbar(1:p.ntarget,mean_Acc_T2_im,error_T2_im./2,error_T2_im./2,LineWidth=2,color='black',LineStyle='none')

%title('correct T2 for all participants')
grid on
ylabel('performance')
ylim([0 1])
xticks([])
set(gca,'FontSize',20)
% labels
for i = 1:p.ntarget
ax(i) = axes('Position',[0.14+0.045*(i-1) 0.02 0.08 0.08]);
imshow(im{i});
end

% corecct T1 over lags
figure
b2 = bar(1:p.ntarget,mean_Acc_T1_im_lags,'EdgeColor','none');
b2(1).FaceColor = blue1;
b2(2).FaceColor = blue2;
legend('lag3', 'lag7', Fontsize= 20)

%title('correct T1 for all participants')
set(gca,'FontSize',20)
grid on
ylabel('performance')
xticks([])
% labels
for i = 1:p.ntarget
ax(i) = axes('Position',[0.11+0.049*(i-1) 0.02 0.08 0.08]);
imshow(im{i});
end

% corecct T2 over lags
figure
b1 = bar(1:p.ntarget,mean_Acc_T2_im_lags,'EdgeColor','none');
b1(1).FaceColor = red1;
b1(2).FaceColor = red2;
legend('lag3', 'lag7', Fontsize= 20)

%title('correct T2|T1 for all participants')
set(gca,'FontSize',13)
ylabel('performance')
xticks([])
grid on
% labels
for i = 1:p.ntarget
ax(i) = axes('Position',[0.11+0.049*(i-1) 0.02 0.08 0.08]); % desired position og images
imshow(im{i});
end

%% calculating reaction time

% reaction time without NAN

% reaction_time_Q1 = zeros(1,p.nsubjects);
% reaction_time_Q2 = zeros(1,p.nsubjects);
% 
% for j = 1:p.nsubjects
%     for i=1:p.nrun
%         a = not(isnan(result{j}.respTime_Q1{i}));
%         Q1(i) = mean(result{j}.respTime_Q1{i}(find(a)));
%         a = not(isnan(result{j}.respTime_Q2{i}));
%         Q2(i) = mean(result{j}.respTime_Q2{i}(find(a)));
%     end
%     reaction_time_Q1(j)=mean(Q1);
%     reaction_time_Q2(j)=mean(Q2);
% end
% 
% % reaction time with NAN = 1.3 (Max time = 1.2 s)
% 
% reaction_time_Q1 = zeros(1,p.nsubjects);
% reaction_time_Q2 = zeros(1,p.nsubjects);
% 
% for j = 1:p.nsubjects
%     for i=1:p.nrun
%         a = result{j}.respTime_Q1{i};
%         b = find(isnan(a));
%         a(b)=1.3;
%         Q1(i) = mean(a);
% 
%         a = result{j}.respTime_Q2{i};
%         b = find(isnan(a));
%         a(b)=1.3;
%         Q2(i) = mean(a);
%     end
%     reaction_time_Q1(j)=mean(Q1);
%     reaction_time_Q2(j)=mean(Q2);
% end

