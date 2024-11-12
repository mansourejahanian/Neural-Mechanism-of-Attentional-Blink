
function [mean_Acc_T1, mean_Acc_T2] = Accuracy_Report(trial,result,p,display)

% This function calculates Accuracy of reporting the targets in each lags
% inputs:
% trial and results are the behavior data
% p is a struct containing experiment parameters
% display indicate whether we want to see the graphs or not
% outputs:
% mean_Acc is the mean performance for both targets over 12 runs

for i = 1:p.nrun
Acc_T1_overall(i) = sum(result.right_Q1{i})./p.block_size;
Acc_T2_overall(i) = sum(result.right_Q2{i})./p.block_size;
end

% Accuracy T1 in each lag
% rows are lags, columns are runs
correct_T1_lags = zeros(p.nlag,p.nrun);

for i=1:p.nrun
    for j=1:p.block_size
        for k=1:p.nlag
    
            if trial{i}(j).lag == p.lags(k)
                correct_T1_lags(k,i) = correct_T1_lags(k,i)+result.right_Q1{i}(j);
            end

        end
    end
end

Acc_T1_lags = correct_T1_lags./(p.block_size/p.nlag);


% Accuracy T2 given T1

correct_T2_lags = zeros(p.nlag,p.nrun);

for i=1:p.nrun
    for j=1:p.block_size

        if ~result.right_Q1{i}(j) % if not, next j
            continue;
        end

        for k=1:p.nlag

            if trial{i}(j).lag == p.lags(k)
                correct_T2_lags(k,i) = correct_T2_lags(k,i)+result.right_Q2{i}(j);
            end

        end
    end
end

Acc_T2_lags = correct_T2_lags./(p.block_size/p.nlag);

Acc_T2_given_T1 = Acc_T2_lags ./Acc_T1_lags;

%  I am adding sth
Acc_T2_given_T1(:,isnan(Acc_T2_given_T1(1,:))|isnan(Acc_T2_given_T1(2,:)))=[];

% plot accuracy for all runs
if display

    if p.nlag == 2
        plot_labels = {'lag 3','lag 7'};
    else
        plot_labels = {'lag 1','lag 3','lag 7'};
    end
    
    figure
    cm = colormap(bone(p.nrun+3)); 
    for i=1:size(Acc_T1_lags,2)
        subplot(1,2,1)
        colormap bone
        plot(p.lags,Acc_T1_lags(:,i),'Color', cm(i,:),LineWidth=2)
        xticks(p.lags)
        xticklabels(plot_labels)
        ylim([0.1,1])
        hold on
    end
    title('T1 Accuracy')
    legend('run1 to run 20')
    
    for i=1:size(Acc_T2_given_T1,2)
        subplot(1,2,2)
        plot(p.lags,Acc_T2_given_T1(:,i),'Color', cm(i,:),LineWidth=2)
        xticks(p.lags)
        xticklabels(plot_labels)
        ylim([0.1,1])
        hold on
    end
    title('T2|T1 Accuracy')
    legend('run1 to run 20')

end

% plot mean accuracy

mean_Acc_T1 = mean(Acc_T1_lags,2);
mean_Acc_T2 = mean(Acc_T2_given_T1,2);

error_T1 = std(Acc_T1_lags,[],2)./sqrt(size(Acc_T1_lags,2));
error_T2 = std(Acc_T2_given_T1,[],2)./sqrt(size(Acc_T2_given_T1,2));

if display

    % plot mean accuracy
    figure
    hold on
    
    for i=1:p.nlag
    scatter(p.lags(i),Acc_T1_lags(i,:),'o', 'filled','blue','MarkerFaceAlpha',0.4)
    scatter(p.lags(i),Acc_T2_given_T1(i,:),'o','filled','red','MarkerFaceAlpha',0.4)
    end

    p1 = plot(p.lags,mean_Acc_T1,'-o',LineWidth=2, color = 'blue');
    errorbar(p.lags,mean_Acc_T1,error_T1,LineWidth=2, color = 'blue')
    p2 = plot(p.lags, mean_Acc_T2, '-o', LineWidth=2, color = 'red');
    errorbar(p.lags, mean_Acc_T2,error_T2, LineWidth=2, color = 'red')

    xlim([p.lags(1)-1, p.lags(2)+1])
    ylim([0.2 1])
    xticks(p.lags)
    xticklabels({'lag 3','lag 7'})
    title(sprintf('Average performance over %d participants',p.nsubjects))
    ylabel('performance')
    set(gca,'FontSize',12, 'YGrid', 'on', 'XGrid', 'off')
    
    % ttest
    ttest_function(Acc_T2_given_T1(end-1,:),Acc_T2_given_T1(end,:),p, 0.5);
    
    legend([p1, p2], 'T1', 'T2|T1', 'Location','northeast')
    hold off

end


end