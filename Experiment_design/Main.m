
% Generate RSVP with two targets

clear all
close all
clc

%screen
%Screen('Preference', 'SkipSyncTests', 1);

%set current path
path = pwd;
addpath('functions');

% stim tracker
p.device = detect_StimTracker();

% parameters
experiment_parameters; 

% initialization
initialization_script;

%send instructions to subject
instruction_text;

%open file to store behavioral data
filename = fullfile(path , 'records' , [p.subjID '_behavioral_' nowstring] );

% load images
filetype = 'jpg';
directory = fullfile(path, 'stimuli');
%rgb = 1; %rgb images
rgb = 0; % grayscale images
im = load_images(filetype, directory,rgb);

% display stimuli
% if we need to show the targets at first
if p.display_targets
display_stimuli(im,p);
end

%% generate trials

for k=1:p.repetition % number of blocks (repetitions)

    % generate all trials for one block
    if p.nlag==2
    trial{k}(:,:) = generate_trials_2lag(p);
    else
    trial{k}(:,:) = generate_trials(p);
    end

    % right answers counter
    right_T1 = 0;
    right_T2 = 0;
    
    % send a trigger for the sturt of run, 10 is the # of trigger
    send_Pulse(p.device, 10, p.pulse_duration);
    fixation_point(p,1);

    % start trial
    for i=1:p.block_size
        
        % display the RSVP stream
        fixation_point(p,1);
        image_display_fast(p,trial{k}(i),im);
        fixation_point(p,1);
        %WaitSecs(uniform(0.5, 0.7));
        
        % question 1
        display_question(p,trial{k}(i).Q1_options,im,1);
        
        % get the response from participants
        WaitRespondTime = 1.1;
        [resp1,respTime1] = button_response_rsvp(WaitRespondTime,p);

        result.resp_Q1{k}(i,:) = resp1;
        result.respTime_Q1{k}(i,:) = respTime1;
        result.speed{k}(i,:) = trial{k}(i).speed;
    
        % cherck answer
        if resp1 == trial{k}(i).Q1_answer
            result.right_Q1{k}(i,:) = 1; 
            right_T1 = right_T1 + 1;
            %disp(['Block:', num2str(ceil(i/p.block_size)) ', Trials:', num2str(i) ', Trigger:' num2str(trial{k}(1, i).trigger1) ',Right Answer, Face_1 :' num2str(right_T1)]);%Online Performance Report
            %send_trigger(254); % correct response
        else
            result.right_Q1{k}(i,:) = 0; 
            %disp(['Block:', num2str(ceil(i/p.block_size)) ', Trials:', num2str(i) ', Trigger:' num2str(trial{k}(1, i).trigger1) ',Wrong Answer, Face_1 :' num2str(right_T1)]);%Online Performance Report
            %send_trigger(255); % incorrect response
        end
        
        fixation_point(p,1);
        %WaitSecs(uniform(0.4, 0.7));
        
        
        % question 2
        display_question(p,trial{k}(i).Q2_options,im,2);
    
        % get the response from participants
        [resp2,respTime2] = button_response_rsvp(WaitRespondTime,p);
        
        result.resp_Q2{k}(i,:) = resp2;
        result.respTime_Q2{k}(i,:) = respTime2;
        result.speed{k}(i,:) = trial{k}(i).speed;
    
        % cherck answer
        if resp2 == trial{k}(i).Q2_answer
            result.right_Q2{k}(i,:) = 1; 
            right_T2 = right_T2 + 1;
            %disp(['Block:', num2str(ceil(i/p.block_size)) ', Trials:', num2str(i) ', Trigger:' num2str(trial{k}(1, i).trigger2) ',Right Answer, Face_1 :' num2str(right_T2)]);%Online Performance Report
            %send_trigger(254); % correct response
        else
            result.right_Q2{k}(i,:) = 0; 
            %disp(['Block:', num2str(ceil(i/p.block_size)) ', Trials:', num2str(i) ', Trigger:' num2str(trial{k}(1, i).trigger2) ',Wrong Answer, Face_1 :' num2str(right_T2)]);%Online Performance Report
            %send_trigger(255); % incorrect response
        end
        
        fixation_point(p,1);
        %WaitSecs(uniform(0.4, 0.6));
        % save one trial
        save([filename '.mat'],'result','trial','i');
    
    end

    % send a trigger for the end of run, 30 is the # of trigger
    send_Pulse(p.device, 30, p.pulse_duration);

    ShowBlock(p, k, p.repetition);

end

%save
%save(fullfile(fullfile(path, records), 'trial'), 'trial');
%save([filename '_all.mat']);

% cleanup at end of experiment
Screen('CloseAll');
fclose('all');
Priority(0);
