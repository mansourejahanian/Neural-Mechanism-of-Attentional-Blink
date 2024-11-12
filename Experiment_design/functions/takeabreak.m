function takeabreak(p,t,currentblock,totalblock)
% function takeabreak(p,t)
%
% prompt user for a break that lasts at least t seconds


Screen('FillRect',p.whandle,p.background_color);
Screen('TextSize', p.whandle, p.text_size);
str = ['You will soon begin: Block ' num2str(currentblock) ' out of ' num2str(totalblock)];
n = length(str);
Screen('DrawText',p.whandle,str,p.xCenter-n/2*p.text_size/1.7, p.yCenter-80,[255 255 255]);
str = 'Time for a short break!';
n = length(str);
Screen('DrawText',p.whandle,str,p.xCenter-n/2*p.text_size/1.7, p.yCenter,[255 255 255]);
Screen('Flip',p.whandle,0,1);

WaitSecs(t);

str = 'Push any key when ready to continue...';
n = length(str);
Screen('DrawText',p.whandle,str,p.xCenter-n/2*p.text_size/1.7, p.yCenter+100,[255 255 255]);
Screen('Flip',p.whandle,0);
KbWait([],2);


