

function [] = display_question(p,options,image,nquestion)


% question text
str1 = 'Which one was the first target?';
str2 = 'Which one was the second target?';

% question 1 or 2
if nquestion == 1
    str = str1;
else
     str = str2;
end

% display question
drawCenteredText(p, str, 300);

% create four options

% size of the images
imwidth = 100;
imheight = 100;

% image 1
imtex = Screen('MakeTexture', p.whandle, image{options(1)});
Screen('DrawTexture', p.whandle, imtex, [], [p.xCenter-2.15*imwidth,p.yCenter-2.15*imheight,p.xCenter-0.15*imwidth,p.yCenter-0.15*imheight]);

% image 2
imtex = Screen('MakeTexture', p.whandle, image{options(2)});
Screen('DrawTexture', p.whandle, imtex, [], [p.xCenter+0.15*imwidth,p.yCenter-2.15*imheight,p.xCenter+2.15*imwidth,p.yCenter-0.15*imheight]);

% image 3
imtex = Screen('MakeTexture', p.whandle, image{options(3)});
Screen('DrawTexture', p.whandle, imtex, [], [p.xCenter-2.15*imwidth,p.yCenter+0.15*imheight,p.xCenter-0.15*imwidth,p.yCenter+2.15*imheight]);

% image 4
imtex = Screen('MakeTexture', p.whandle, image{options(4)});
Screen('DrawTexture', p.whandle, imtex, [], [p.xCenter+0.15*imwidth,p.yCenter+0.15*imheight,p.xCenter+2.15*imwidth,p.yCenter+2.15*imheight]);

%fixation
fixation_point(p,0);

Screen('Flip', p.whandle);

%wait for any key
%WaitSecs(1);
%KbWait;

