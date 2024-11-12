

function [] = fixation_point (p,flip)

% parameters
dontclear = 0;
fixcolor = [0 0 0];
fixlinelength = 10;
fixwidth = 3;

% create cross
fixcross = [p.xCenter-fixlinelength p.xCenter+fixlinelength p.xCenter p.xCenter; p.yCenter p.yCenter p.yCenter-fixlinelength p.yCenter+fixlinelength];

% draw black fixation cross
Screen('DrawLines',p.whandle,fixcross,fixwidth,fixcolor);


% if flip ==1 flip the screen and wait :D
if flip==1
    Screen('Flip', p.whandle,0,dontclear);
    WaitSecs(uniform(0.6, 0.8));
end


