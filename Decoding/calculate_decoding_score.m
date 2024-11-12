

close all
clear all
clc

% needed path
path_codes = 'C:\__My Own Drive__\manuscript\Codes';
path_data = 'Z:\CNAI2\Mansoure';

% add functions
addpath(fullfile(path_codes, 'decoding', 'functions'));

% add color
addpath(fullfile(path_codes, 'Stat_visual'))
colors;

% subjects numbers
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
    path_sub = fullfile(path_data,sprintf('subject%02d',N(i)),'decoding');
    files = dir(fullfile(path_sub,'*.mat'));
    load(fullfile(files.folder, files.name));

    decoding_T1lag3(:,i) = decoding1.Value; % lag3
    decoding_T1lag7(:,i) = decoding2.Value; % lag7

    decoding_T2lag3(:,i) = decoding3.Value; % lag3
    decoding_T2lag7(:,i) = decoding4.Value; % lag7

end

time = (decoding1.Time)*1000;


%% find decoding score

ntest = 1000;
method = 1; % method = 1 step method %%%%%%% method = 2 window method
[score_T1lag3, score_T1lag7...
,score_T2lag3, score_T2lag7] = decoding_score(decoding_T1lag3, decoding_T1lag7, decoding_T2lag3, decoding_T2lag7, time, ntest, nsubject, method);


%% statistical test

for i=1:size(score_T1lag3,1)
    diff1 = score_T1lag7(i,:) - score_T1lag3(i,:);
    diff2 = score_T2lag7(i,:) - score_T2lag3(i,:);
    
    diff3 = score_T1lag3(i,:) - score_T2lag3(i,:);
    diff4 = score_T1lag7(i,:) - score_T2lag7(i,:);

    p1(i) = sum(diff1<0)./length(diff1);
    p2(i) = sum(diff2<0)./length(diff2);

    p3(i) = sum(diff3<0)./length(diff3);
    p4(i) = sum(diff4<0)./length(diff4);
end

% test against chance level

for i=1:size(score_T1lag3,1)
    DT1L3 = score_T1lag3(i,:) - 50;
    DT1L7 = score_T1lag7(i,:) - 50;
    DT2L3 = score_T2lag3(i,:) - 50;
    DT2L7 = score_T2lag7(i,:) - 50;
    
    p_T1L3(i) = sum(DT1L3<0)./length(DT1L3);
    p_T1L7(i) = sum(DT1L7<0)./length(DT1L7);
    p_T2L3(i) = sum(DT2L3<0)./length(DT2L3);
    p_T2L7(i) = sum(DT2L7<0)./length(DT2L7);
end

% correction
[p1_corr, ~] = fdr(p1(:), 0.05);
[p2_corr, ~] = fdr(p2(:), 0.05);

[p_T1L3_corr, ~] = fdr(p_T1L3(:), 0.05);
[p_T1L7_corr, ~] = fdr(p_T1L7(:), 0.05);
[p_T2L3_corr, ~] = fdr(p_T2L3(:), 0.05);
[p_T2L7_corr, ~] = fdr(p_T2L7(:), 0.05);

%% PLOT

x = {score_T1lag3',score_T1lag7',score_T2lag3',score_T2lag7'};

figure('Position',[400 75 500 500])
hold on

yline(50,LineStyle="-",LineWidth = 3,color="black")
xline(5, LineWidth = 3,color="black")
xline(10, LineWidth = 3,color="black")
xline(15, LineWidth = 3,color="black")
xline(20, LineWidth = 3,color="black")
xline(25, LineWidth = 3,color="black")

b = boxplotGroup(x,'PrimaryLabels',{'Lag 3','Lag 7','Lag 3','Lag 7'}, ...
'SecondaryLabels',{'-200 - 0 ms', '0 - 200 ms', '200- 400 ms', '400 - 600 ms', '600 - 800 ms', '800 - 1000 ms'},...
'GroupLabelType','Vertical','MedianStyle','line', 'OutlierSize',1,...
'Symbol','o','Widths',.4,...
'ExtremeMode','compress', 'GroupType','BetweenGroups','colors',[blue1;blue1;red1;red1], 'jitter',0.2, 'Whisker', inf);

set(b.xline,'LabelVerticalAlignment','bottom',FontSize = 12)

bx1 = findobj('Tag','boxplot');
set(bx1(1).Children,'LineWidth',3)
set(bx1(2).Children,'LineWidth',3)
set(bx1(3).Children,'LineWidth',3)
set(bx1(4).Children,'LineWidth',3)


% h=findobj('LineStyle','--'); 
% set(h, 'LineStyle','-', 'color',[128 128 128]./256);


pbaspect([2.8 1 1])
ylim([48 54])
ylabel('Average decoding accuracy (%)')
b.axis.LineWidth = 3;
b.axis.FontSize = 24;
b.axis.FontName = 'Calibri';
b.axis.Box = "off";
b.axis.YTick = [48 50 52 54];
xtickangle(90)

for i = 1:6
    if p_T1L3_corr(i)
        scatter(5*(i-1)+1,53.4,100,'*','black')
    end
    
    if p_T1L7_corr(i)
        scatter(5*(i-1)+2,53.4,100,'*','black')
    end
    
    if p_T2L3_corr(i)
        scatter(5*(i-1)+3,53.4,100,'*','black')
    end
    
    if p_T2L7_corr(i)
        scatter(5*(i-1)+4,53.4,100,'*','black')
    end

    if p1_corr(i)
        scatter(5*(i-1)+1.5,54,100,'*','black')
    end

    if p2_corr(i)
        scatter(5*(i-1)+1.5,54,100,'*','black')
    end
    
end

