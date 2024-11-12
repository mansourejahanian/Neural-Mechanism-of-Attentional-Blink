function ShowBlock(p, now_block, total_block )

p.text_size = 40;
Screen('TextSize', p.whandle, p.text_size);
force_time = 15;
str_num = 2;
str_hight = 200;
str = cell(1,str_num);
n = cell(size(str));

if now_block ~= 0
    for force_time_c = force_time+1:-1:1
        % define strings
        str{1} = ['Now, you have done ' num2str(now_block) '/' num2str(total_block) '.'];
        if force_time_c ~= 1
            str{2} = ['Please rest for at least more ' num2str(force_time_c-1) ' seconds'];
        else
            if now_block == total_block
                str{2} = ['Press any button to end experiment'];
            else
                str{2} = ['Press any button to continue experiment'];
            end
        end

        % show strings on screen
        for str_count = 1:str_num
            n{str_count} = length(str{str_count});
            Screen('DrawText', p.whandle, str{str_count}, 200, p.yCenter-floor(str_hight/2)+(str_count-1)*floor(str_hight/(str_num-1)), [0 0 0]);
            %drawCenteredText(p, str{str_count},  p.yCenter-floor(str_hight/2)+(str_count-1)*floor(str_hight/(str_num-1)))
        end
        Screen('Flip', p.whandle);
        tic
        while toc<1
            [keyIsDown,secs, keyCode, deltaSecs] = KbCheck;
            %             disp(keyCode);
            if keyCode(69) % 69 is the code of 'e'
                if p.eye_tracking==1
                    % setup eyetracker
                    % do we need "stop" first before recalibration
                    Eyelink('StopRecording');
                    setup_eye_tracking_and_configuration(p);
                    disp('Start of eye tracking recording');
                    Eyelink('StartRecording');
                    WaitSecs(0.05);
                    % begin eye recording
                    Eyelink('Message', 'SYNCTIME');
                    WaitSecs(0.1) % Wait for 100ms
                end
                break;
            end
        end
    end
    KbWait;%wait for any key to continue
else    
    str{1} = ['Now, you have done ' num2str(now_block) '/' num2str(total_block) '.'];
    str{2} = ['Press any button to start the experiment'];
    for str_count = 1:str_num
        n{str_count} = length(str{str_count}); 
        Screen('DrawText', p.whandle, str{str_count}, 200, p.yCenter-floor(str_hight/2)+(str_count-1)*floor(str_hight/(str_num-1)), [0 0 0]);
        %drawCenteredText(p, str{str_count}, p.yCenter-floor(str_hight/2)+(str_count-1)*floor(str_hight/(str_num-1)))
    end
    Screen('Flip', p.whandle);
    KbWait;%wait for any key to continue
end
         
end

