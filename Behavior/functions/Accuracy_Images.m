

function [CT1, CT2, CT1_lags, CT2_lags] = Accuracy_Images(trial,result,im,p,display)

% This function ...


% find correct trials and find their triggers
correct_T1 = zeros(p.nrun,p.block_size);
correct_T2 = zeros(p.nrun,p.block_size);

for i=1:p.nrun
    for j=1:p.block_size
        if result.right_Q1{i}(j)
            correct_T1(i,j) = trial{i}(j).trigger1;

            if result.right_Q2{i}(j)
                correct_T2(i,j) = trial{i}(j).trigger2;
            end
        end
    end
end

% count the number of correct images in each run
Ncorrect_T1 = zeros(12,16);
Ncorrect_T2 = zeros(12,16);

for i=1:p.nrun
Ncorrect_T1(i,:) = histc(correct_T1(i,:), 1:p.ntarget);
Ncorrect_T2(i,:) = histc(correct_T2(i,:), 1:p.ntarget);
end

% corrects in all runs
CT1 = sum(Ncorrect_T1)./(p.nrun*p.nlag);
%CT2 = sum(Ncorrect_T2)./sum(Ncorrect_T1);

for i=1:p.nrun
    for j=1:p.ntarget
        if Ncorrect_T2(i,j)
            a = [trial{i}.trigger2];
            b = [trial{i}.trigger1];
            c = find(a==j); % find the trigger1 for that trigger2
            Ncorrect_T2(i,j) = Ncorrect_T2(i,j)./ Ncorrect_T1(i,b(c(1)));
        end
    end
end

CT2 = mean(Ncorrect_T2,1);

% plot

if display 

    figure
    bar(1:p.ntarget,CT2,0.5, 'EdgeColor','none', FaceColor='#77AC30');
    title('correct T2|T1')
    ylabel('performance')
    xticks([])
    set(gca,'FontSize',13)
    grid on
    % labels
    for i = 1:p.ntarget
    ax(i) = axes('Position',[0.14+0.045*(i-1) 0.02 0.08 0.08]); % desired position of images
    imshow(im{i});
    end
    
    figure
    bar(1:p.ntarget,CT1,0.5, 'EdgeColor','none', FaceColor='#EDB120');
    title('correct T1')
    grid on
    ylabel('performance')
    xticks([])
    set(gca,'FontSize',13)
    % labels
    for i = 1:p.ntarget
    ax(i) = axes('Position',[0.14+0.045*(i-1) 0.02 0.08 0.08]);
    imshow(im{i});
    end

end

% calculate for each lag separately

% find correct trials and find their triggers
correct_T1 = zeros(p.nrun,p.block_size,p.nlag);
correct_T2 = zeros(p.nrun,p.block_size,p.nlag);

for i=1:p.nrun
    for j=1:p.block_size
        for k=1:p.nlag

            if result.right_Q1{i}(j) && trial{i}(j).lag == p.lags(k)
                correct_T1(i,j,k) = trial{i}(j).trigger1;
    
                if result.right_Q2{i}(j)
                    correct_T2(i,j,k) = trial{i}(j).trigger2;
                end
            end

        end
    end
end

% count the number of correct images in each run
Ncorrect_T1 = zeros(p.nrun,p.ntarget,p.nlag);
Ncorrect_T2 = zeros(p.nrun,p.ntarget,p.nlag);

for i=1:p.nrun
    for j=1:p.nlag
        Ncorrect_T1(i,:,j) = histc(correct_T1(i,:,j), 1:p.ntarget);
        Ncorrect_T2(i,:,j) = histc(correct_T2(i,:,j), 1:p.ntarget);
    end
end

% corrects in all runs

CT1_lags = zeros(p.ntarget,p.nlag);
CT2_lags = zeros(p.ntarget,p.nlag);

% CT1
for i=1:p.nlag
    CT1_lags(:,i) = mean(Ncorrect_T1(:,:,i),1)';
end

%CT2
for j=1:p.ntarget

    % variables for number of lags 
    d = zeros(p.nlag,1);

    for i=1:p.nrun
        a = [trial{i}.trigger2];
        b = [trial{i}.trigger1];
        c = [trial{i}.lag];
    
        % im = j, lags
        for k=1:p.nlag
            d(k) = d(k)+Ncorrect_T1(i,b(find(a==j & c==p.lags(k))),k);
        end
    end

    for k=1:p.nlag
        if d(k)
            CT2_lags(j,k) = sum(Ncorrect_T2(:,j,k)) ./ d(k);
        else
            CT2_lags(j,k) = 0;
        end
    end

end

% plot

if display 

    if p.nlag == 2
        plot_labels = {'lag 3','lag 7'};
    else
        plot_labels = {'lag 1','lag 3','lag 7'};
    end

    figure
    b1 = bar(1:p.ntarget,CT2_lags,'EdgeColor','none');
    b1(1).FaceColor = [.3 .5 .2];
    b1(2).FaceColor = [.4 .6 .2];
    if p.nlag == 3
    b1(3).FaceColor = [.4 .7 .2];
    end
    legend(plot_labels)

    title('correct T2|T1')
    ylabel('performance')
    xticks([])
    grid on
    % labels
    for i = 1:p.ntarget
        ax(i) = axes('Position',[0.11+0.049*(i-1) 0.02 0.08 0.08]); % desired position og images
        imshow(im{i});
    end
    
    
    figure
    b2 = bar(1:p.ntarget,CT1_lags,'EdgeColor','none');
    b2(1).FaceColor = [.6 .4 .1];
    b2(2).FaceColor = [.7 .5 .1];
    if p.nlag == 3
    b2(3).FaceColor = [.9 .6 .1];
    end
    legend(plot_labels)

    title('correct T1')
    grid on
    ylabel('performance')
    xticks([])
    % labels
    for i = 1:p.ntarget
        ax(i) = axes('Position',[0.11+0.049*(i-1) 0.02 0.08 0.08]);
        imshow(im{i});
    end

end

end

