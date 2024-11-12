

% experiment Parameters

% blocks (number of repetition)
%p.repetition = 12; % with lag 1
p.repetition = 22; % without lag 1

% number of targets in one trial
p.ntarget = 16;
%number of distractors
p.ndistractor = 220;

% number of lag condition
%p.nlag = 3; % with lag 1
p.nlag = 2; % without lag 1

% number of trials in one block
p.block_size =  p.ntarget*p.nlag;
%number of images in one trial
p.nitem = 15; 
% speed of presentation (number of frames per image)
p.speed = [5]; % 70 ms
% pulse duration for trigger
p.pulse_duration = 5;
