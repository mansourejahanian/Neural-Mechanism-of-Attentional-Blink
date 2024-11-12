

function [trials] = generate_trials_2lag(p)

% randomize
rng('shuffle')

%number of trials and speeds
ntrial = p.ntarget; %p.block_size/p.nlag;
nspeed = length(p.speed);
noption = 4;

% permute targets to create different block each time
% no two same index have same value
matrix_a = mod(bsxfun(@plus, 0:p.ntarget-1, transpose(0:p.ntarget-1)), p.ntarget) + 1;
matrix_b = matrix_a(randperm(p.ntarget), :);
matrix_b = matrix_b(:, randperm(p.ntarget));

map_t1 = matrix_b(1,:);
map_t2 = matrix_b(2,:);

%map_t1 = randperm (ntrial,ntrial);
%map_t2 = randperm (ntrial,ntrial);

% targets and distractors
% the first half of target1 are women and the second half are men
target1 = p.ndistractor+(1:p.ntarget); % 8 women and 8 men
target2 = target1;
others = (1:p.ndistractor);


for k = 1:nspeed

    trial_speed{k} = p.speed(k)*ones(p.block_size,1);

    % lag3, lag7
    trial_lag{k} = [3.*ones(ntrial ,1); 7.*ones(ntrial ,1)];

    % targets trigger
    t1_trigger{k} = map_t1(repmat([1:p.ntarget],1,p.nlag)');
    t2_trigger{k} = map_t2(repmat([1:p.ntarget],1,p.nlag)');

    % t1 position is either 4th, 6th item
    t1_position{k} = repmat([4.*ones(ntrial/2,1);6.*ones(ntrial/2,1)]',1,p.nlag)';
    trial_im{k} = zeros(p.block_size,p.nitem);

    % counter balancing the answers for all questions
    matrix_a = mod(bsxfun(@plus, 0:noption-1, transpose(0:noption-1)), noption) + 1;
    for i=1:16
    matrix_b = matrix_a(randperm(noption), :);
    Q_answer(:,:,i) = matrix_b(:, randperm(noption));
    end
    Q_answer = cat(3,Q_answer(:,:));

    for i = 1:p.block_size

        % distractors in one trial, there is no repetition of one distractor
        distractor = randperm(length(others),p.nitem - 2);

        % lag3, 7
        trial_im{k}(i,1:t1_position{k}(i)-1) = distractor(1:t1_position{k}(i)-1); 
        trial_im{k}(i,t1_position{k}(i)) = target1(t1_trigger{k}(i)); 
        trial_im{k}(i,t1_position{k}(i)+1:t1_position{k}(i)+trial_lag{k}(i)-1) = distractor(t1_position{k}(i):t1_position{k}(i)+trial_lag{k}(i)-2); %distractors between T1 and T2 
        trial_im{k}(i,t1_position{k}(i)+trial_lag{k}(i)) = target2(t2_trigger{k}(i)); 
        trial_im{k}(i,t1_position{k}(i)+trial_lag{k}(i)+1:p.nitem) = distractor(t1_position{k}(i)+trial_lag{k}(i)-1:end); 


        % question 1
        % question 1 answer
        Q1_options{k}(i,Q_answer(1,i)) = target1(t1_trigger{k}(i));
        Q1_answer{k}(i) = Q_answer(1,i);

        % question 2
        Q2_options{k}(i,Q_answer(1,end+1-i)) = target2(t2_trigger{k}(i));
        Q2_answer{k}(i) = Q_answer(1,end+1-i);


        if t1_trigger{k}(i) <= p.ntarget/2 && t2_trigger{k}(i) <= p.ntarget/2 % if both targets are women

            %exclude both targets
            if t1_trigger{k}(i) < t2_trigger{k}(i)
                other_option_women = [1:t1_trigger{k}(i)-1, t1_trigger{k}(i)+1:t2_trigger{k}(i)-1, t2_trigger{k}(i)+1:p.ntarget/2];
            else
                other_option_women = [1:t2_trigger{k}(i)-1, t2_trigger{k}(i)+1:t1_trigger{k}(i)-1, t1_trigger{k}(i)+1:p.ntarget/2];
            end

            other_option_men = p.ntarget/2+1:p.ntarget;

            Q1_options{k}(i,Q_answer(2,i)) = target1(other_option_women(randperm(length(other_option_women),1)));
            Q1_options{k}(i,Q_answer(3:4,i)) = target1(other_option_men(randperm(length(other_option_men),2)));

            Q2_options{k}(i,Q_answer(2,end+1-i)) = target2(other_option_women(randperm(length(other_option_women),1)));
            Q2_options{k}(i,Q_answer(3:4,end+1-i)) = target2(other_option_men(randperm(length(other_option_men),2)));
        end

        if t1_trigger{k}(i) <= p.ntarget/2 && t2_trigger{k}(i) > p.ntarget/2 % T1 women, T2 men

            %exclude both targets
            other_option_women = [1:t1_trigger{k}(i)-1, t1_trigger{k}(i)+1:p.ntarget/2];

            other_option_men = [p.ntarget/2+1:t2_trigger{k}(i)-1, t2_trigger{k}(i)+1:p.ntarget];

            Q1_options{k}(i,Q_answer(2,i)) = target1(other_option_women(randperm(length(other_option_women),1)));
            Q1_options{k}(i,Q_answer(3:4,i)) = target1(other_option_men(randperm(length(other_option_men),2)));

            Q2_options{k}(i,Q_answer(2,end+1-i)) = target2(other_option_men(randperm(length(other_option_men),1)));
            Q2_options{k}(i,Q_answer(3:4,end+1-i)) = target2(other_option_women(randperm(length(other_option_women),2)));
        end

        if t1_trigger{k}(i) > p.ntarget/2 && t2_trigger{k}(i) <= p.ntarget/2 % T1 men, T2 women

            %exclude both targets
            other_option_women = [1:t2_trigger{k}(i)-1, t2_trigger{k}(i)+1:p.ntarget/2];

            other_option_men = [p.ntarget/2+1:t1_trigger{k}(i)-1, t1_trigger{k}(i)+1:p.ntarget];

            Q1_options{k}(i,Q_answer(2,i)) = target1(other_option_men(randperm(length(other_option_men),1)));
            Q1_options{k}(i,Q_answer(3:4,i)) = target1(other_option_women(randperm(length(other_option_women),2)));

            Q2_options{k}(i,Q_answer(2,end+1-i)) = target2(other_option_women(randperm(length(other_option_women),1)));
            Q2_options{k}(i,Q_answer(3:4,end+1-i)) = target2(other_option_men(randperm(length(other_option_men),2)));
        end

        if t1_trigger{k}(i) > p.ntarget/2 && t2_trigger{k}(i) > p.ntarget/2 % both targets are men

            %exclude both targets
            if t1_trigger{k}(i) < t2_trigger{k}(i)
                other_option_men = [p.ntarget/2+1:t1_trigger{k}(i)-1, t1_trigger{k}(i)+1:t2_trigger{k}(i)-1, t2_trigger{k}(i)+1:p.ntarget];
            else
                other_option_men = [p.ntarget/2+1:t2_trigger{k}(i)-1, t2_trigger{k}(i)+1:t1_trigger{k}(i)-1, t1_trigger{k}(i)+1:p.ntarget];
            end

            other_option_women = 1:p.ntarget/2;

            Q1_options{k}(i,Q_answer(2,i)) = target1(other_option_men(randperm(length(other_option_men),1)));
            Q1_options{k}(i,Q_answer(3:4,i)) = target1(other_option_women(randperm(length(other_option_women),2)));

            Q2_options{k}(i,Q_answer(2,end+1-i)) = target2(other_option_men(randperm(length(other_option_men),1)));
            Q2_options{k}(i,Q_answer(3:4,end+1-i)) = target2(other_option_women(randperm(length(other_option_women),2)));
        end


    end

    % struct trials
    for i=1:p.block_size
        trial((k - 1)*p.block_size + i).im = trial_im{k}(i,:);
        trial((k - 1)*p.block_size + i).lag = trial_lag{k}(i);
        trial((k - 1)*p.block_size + i).speed = trial_speed{k}(i);
        trial((k - 1)*p.block_size + i).trigger1 = t1_trigger{k}(i);
        trial((k - 1)*p.block_size + i).trigger2 = t2_trigger{k}(i);
        trial((k - 1)*p.block_size + i).t1_position = t1_position{k}(i);
        trial((k - 1)*p.block_size + i).Q1_options = Q1_options{k}(i,:);
        trial((k - 1)*p.block_size + i).Q2_options = Q2_options{k}(i,:);
        trial((k - 1)*p.block_size + i).Q1_answer = Q1_answer{k}(i);
        trial((k - 1)*p.block_size + i).Q2_answer = Q2_answer{k}(i);
    end

end

% permute order

order = randperm(p.block_size);
trials = trial(1,order);

end