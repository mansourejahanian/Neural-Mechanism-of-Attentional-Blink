

function display_stimuli(image,p)

% instruction

str = 'First, you are going to take a look at all face images to become familiar with them.';
drawCenteredText(p, str, 100);

str = 'Press any button to begin.';
drawCenteredText(p, str, -100);

Screen('Flip', p.whandle);

%wait for any key
KbWait;

% show images
imwidth = 220;
imheight = 220;

for i=1:p.ntarget
    imtex = Screen('MakeTexture', p.whandle, image{i+p.ndistractor});
    Screen('DrawTexture', p.whandle, imtex, [], [p.xCenter-imwidth,p.yCenter-imheight,p.xCenter+imwidth,p.yCenter+imheight]);
    WaitSecs(1);
    Screen('Flip', p.whandle);
end

WaitSecs(1);

str = 'Now press any button to begin the experiment.';
drawCenteredText(p, str, 0);

Screen('Flip', p.whandle);

%wait for any key
KbWait;


end