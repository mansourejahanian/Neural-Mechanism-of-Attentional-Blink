function [resp,respTime] = button_response_rsvp(time,p)

%start timer
tic

respTime = nan;
resp = 0;

while toc < time
    
    %check the key
    [keyIsDown, secs, key, deltaSecs] = KbCheck();
    
    if keyIsDown ~=0 %if key pressed
        send_Pulse(p.device, 100, p.pulse_duration);
        
        if key(KbName('4')) == 1 % first option
            resp = 1;
            respTime = toc;
            break;
        elseif key(KbName('5')) == 1  % second option
            resp = 2;
            respTime = toc;
            break;
        elseif key(KbName('1')) == 1  % third option
            resp = 3;
            respTime = toc;
            break;
        elseif key(KbName('2')) == 1 % forth option
            resp = 4;
            respTime = toc;
            break;
        elseif key(KbName('q')) %Q key % escape
            sca
            return
        end
        
    end
end

WaitSecs(0.2);



