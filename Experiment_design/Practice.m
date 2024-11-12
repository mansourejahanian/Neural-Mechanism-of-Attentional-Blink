
% practice block

% Generate RSVP with two targets

clear all
close all
clc

%screen
%Screen('Preference', 'SkipSyncTests', 1);

%set current path
path = pwd;
addpath('Functions');

% stim tracker
p.device = detect_StimTracker();

% parameters
experiment_parameters; 

% initialization
initialization_script;

%send instructions to subject
instruction_text;

% load images
rgb = 0; % grayscale images
filetype = 'jpg';
directory = fullfile(path, 'stimuli');
im = load_images(filetype, directory, rgb);

% generate trials for one block
k =1;

    trial{k}(:,:) = generate_trials_2lag(p);
    
    % right answers counter
    right_T1 = 0;
    right_T2 = 0;
    
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
        WaitRespondTime = 1.5;
        [resp1,respTime1] = button_response_rsvp(WaitRespondTime,p);
        
        result.resp_Q1{k}(i,:) = resp1;
        result.respTime_Q1{k}(i,:) = respTime1;
        result.speed{k}(i,:) = trial{k}(i).speed;
    
        % cherck answer
        if resp1 == trial{k}(i).Q1_answer
            result.right_Q1{k}(i,:) = 1; 
            right_T1 = right_T1 + 1;
        else
            result.right_Q1{k}(i,:) = 0; 
        end
        
        fixation_point(p,1);
        %WaitSecs(uniform(0.4, 0.7));
        %plot_fixation_cross(p,1,[0 0 0],0,0.5);
        
        
        % question 2
        display_question(p,trial{k}(i).Q2_options,im,2);
    
        % get the response from participants
        WaitRespondTime = 1.5;
        [resp2,respTime2] = button_response_rsvp(WaitRespondTime,p);
        
        result.resp_Q2{k}(i,:) = resp2;
        result.respTime_Q2{k}(i,:) = respTime2;
        result.speed{k}(i,:) = trial{k}(i).speed;
    
        % cherck answer
        if resp2 == trial{k}(i).Q2_answer
            result.right_Q2{k}(i,:) = 1; 
            right_T2 = right_T2 + 1;
        else
            result.right_Q2{k}(i,:) = 0; 
        end
        
        fixation_point(p,1);
        %WaitSecs(uniform(0.4, 0.7));
    
    end

% cleanup at end of experiment
Screen('CloseAll');
fclose('all');
Priority(0);