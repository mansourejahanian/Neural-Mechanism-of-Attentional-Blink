function [] = image_display_fast(p,current_trial,image)

% parameters
nImages = length(current_trial.im);
imwidth = 220;
imheight = 220;

% create texture for images
k = 0;
for i = 1:nImages
    for j=1:current_trial.speed
        k = k+1;
        imtex{k} = Screen('MakeTexture', p.whandle, image{current_trial.im(i)});
    end
end

%Screen('Flip', p.whandle);

% fixation
%fixlinelength = 10;
%fixcross = [p.xCenter-fixlinelength p.xCenter+fixlinelength p.xCenter p.xCenter; p.yCenter p.yCenter p.yCenter-fixlinelength p.yCenter+fixlinelength];

% number of frames for all images in one trail
nframes = length(imtex);

% send trigger at the start of trial
send_Pulse(p.device, 20, p.pulse_duration);

for i = 1:nframes
    
    % display images
    Screen('DrawTexture', p.whandle, imtex{i}, [], [p.xCenter-imwidth,p.yCenter-imheight,p.xCenter+imwidth,p.yCenter+imheight]);
    % display fixation
    fixation_point(p,0);

    if p.session % if the session is EEG session
    
        % send trigger if target 1 was displayed
        if (i == (current_trial.t1_position-1)*current_trial.speed+1)
            % send trigger
            send_Pulse(p.device, 1, p.pulse_duration);
            % light sensor rect
            Screen('FillRect', p.whandle, [255 255 255], [10,10,40,40]);
      
        % send trigger if target 2 was displayed
        elseif (i == (current_trial.t1_position + current_trial.lag-1)*current_trial.speed+1)
            % send trigger
            send_Pulse(p.device, 2, p.pulse_duration);
            % light sensor rect
            Screen('FillRect', p.whandle, [255 255 255], [10,10,40,40]); 

        % light sensor rect black
        else
        Screen('FillRect', p.whandle, [0 0 0], [10,10,40,40]);

        end

    end

    Screen('Flip', p.whandle);

end

%Screen('Flip',p.whandle);

% send trigger at the end of trial
send_Pulse(p.device, 21, p.pulse_duration);

for i = 1:nframes
    Screen('Close', imtex{i});
end

