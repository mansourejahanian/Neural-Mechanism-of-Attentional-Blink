
function [score_T1lag3, score_T1lag7, score_T2lag3, score_T2lag7] = decoding_score(decoding_T1lag3, decoding_T1lag7, decoding_T2lag3, decoding_T2lag7, time, ntest, nsubject, method) 


    %method = 1 step

    if method ==1

        stp = 102;
        tp = round(size(decoding_T1lag3,1)./stp);
        
        score_T1lag3 = zeros(tp,ntest);
        score_T1lag7 = zeros(tp,ntest);
        score_T2lag3 = zeros(tp,ntest);
        score_T2lag7 = zeros(tp,ntest);
        
        
        for i = 1: ntest
        
            for j=1:tp
        
            r = randi([1 nsubject],1,nsubject);
        
            meanp = mean(decoding_T1lag3(:,r),2);
            score_T1lag3(j,i) = mean(meanp(stp*(j-1)+1:stp*j,1),1);
        
            meanp = mean(decoding_T1lag7(:,r),2);
            score_T1lag7(j,i) = mean(meanp(stp*(j-1)+1:stp*j,1),1);
        
            meanp = mean(decoding_T2lag3(:,r),2);
            score_T2lag3(j,i) = mean(meanp(stp*(j-1)+1:stp*j,1),1);
        
            meanp = mean(decoding_T2lag7(:,r),2);
            score_T2lag7(j,i) = mean(meanp(stp*(j-1)+1:stp*j,1),1);
        
            end
           
        end



    end


    %method = 2 window

    if method ==2
    WT = [-200,0,200,400,600,800,1000];
    %WT = [-200,-100,0,100,200,300,400,500,600,700,800,900,1000];
    NW = length(WT)-1;

    score_T1lag3 = zeros(NW,ntest);
    score_T1lag7 = zeros(NW,ntest);

    score_T2lag3 = zeros(NW,ntest);
    score_T2lag7 = zeros(NW,ntest);

    for i = 1:ntest
    
        for j=1:NW
            r = randi([1 nsubject],1,nsubject);
    
            % window time
            window = find(time > WT(j) & time < WT(j+1));
    
            % T1 lag3
            mean_T1lag3 = mean(decoding_T1lag3(:,r),2);
            score_T1lag3(j,i) = mean(mean_T1lag3(window));
        
            % T1 lag7
            mean_T1lag7 = mean(decoding_T1lag7(:,r),2);
            score_T1lag7(j,i) = mean(mean_T1lag7(window));

            % T2 lag3
            mean_T2lag3 = mean(decoding_T2lag3(:,r),2);
            score_T2lag3(j,i) = mean(mean_T2lag3(window));
        
            % T2 lag7
            mean_T2lag7 = mean(decoding_T2lag7(:,r),2);
            score_T2lag7(j,i) = mean(mean_T2lag7(window));
        end

    end
    end


end