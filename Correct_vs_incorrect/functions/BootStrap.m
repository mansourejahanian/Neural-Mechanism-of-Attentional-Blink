
function mean_decoding = BootStrap(path,method)

    
    % N is # participants
    % method is pairwise or temporalgen

    
    files = dir([path, '\*.mat']);
    % load time and bad channels and bad trials
    time = load([files(end).folder '\' files(end).name]).Time;
    badtrials = load([files(1).folder '\' files(1).name]).BadTrials;
    channels = load([files(end).folder '\' files(end).name]).ChannelFlag;
    % the first 64 channels are EEG channels
    channels(65:end)=[];

    % counters for counting correct and incorrect trials
    k = 1;
    j = 1;
    
    for i= 3:length(files)
        if ~any(strcmp(files(i).name,badtrials)) % if the name is in badtrial it will skip it
            cond = split(files(i).name,'_');
            % if it is correct trial
            if strcmp(cond{2},'correct')
                correct_trial{k} = load([files(i).folder '\' files(i).name]).F;
                con_corr{k} = cond{2};
                k=k+1;
            else
            % if it is incorrect trial
                incorrect_trial{j} = load([files(i).folder '\' files(i).name]).F;
                con_incorr{j} = cond{2};
                j=j+1;
            end
        end
    end
    
    
    % remove bad channels
 
    for i=1:length(correct_trial)
        if ~isempty(correct_trial{i})
        Correct{i}= correct_trial{i}(channels==1,:);
        end
    end
    for i=1:length(incorrect_trial)
        if ~isempty(incorrect_trial{i})
        InCorrect{i}= incorrect_trial{i}(channels==1,:);
        end
    end
    
    %% bootstrap
    
    repeat = 100;
    
    %tic
    
    for i = 1:repeat
    
        n_min = min(length(Correct),length(InCorrect));
        n_max = max(length(Correct),length(InCorrect));
        
        % choose r random trials from max pool (length r equals to length min pool)
        r = randperm(n_max, n_min);
        
        if n_min == length(InCorrect)
            trial = [Correct{r},InCorrect];
            label = [con_corr{r},con_incorr];
        else
            trial = [Correct,InCorrect{r}];
            label = [con_corr,con_incorr{r}];
        end
        
        data = single(cat(3,trial{:}));
        
        % decoding
        
        %compress data using pca
        %[data_pca,k,explained] = fl_pca(data,99.99);
        %data_pca = data;
        
        if method==1
        % SVM decoding
        decoding = fl_decodesvm(data,label,'numpermutation',100,'verbose',10,'kfold',5);
        decoding_acc(i,:) = decoding.d;
        elseif method==2
        % temporal generalization
        TG = fl_decodesvm(data,label,'numpermutation',100,'verbose',10,'kfold',5,'method','temporalgen');
        TG_acc(i,:,:) = TG.d;
        end
        
        
    
    end
    
    disp('done')
    
    %toc
    
    % plot for single participant 
    
    if method ==1 %SVM
        mean_decoding = mean(decoding_acc,1);
        
        figure
        red = [178 24 43 256]./256;
        hold on
        plot(time,mean_decoding, LineWidth=3, Color=red)
        
        % onset
        plot([0 0],[30 80], 'LineStyle','--', Color=red)
        
        % chance level
        plot([-0.2 1],[50 50],'black','LineStyle','--')
        
        xlim([-0.2 1])
        ylim([30 80])
        title('correct vs incorrect')
        xlabel('time')
        ylabel('decoding accyracy')
        
        hold off
    elseif method == 2 %TG
        mean_decoding = mean(TG_acc,1);
    end


end