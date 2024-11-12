

%initial text

% the first page that the participants will see

str = 'Rapid Serial Visual Presentation (RSVP) with two targets.';
drawCenteredText(p, str, 350)

str = 'You are going to see a series of different objects images with two faces among them.';
drawCenteredText(p, str, 200)

str = 'Please look for the first and the second face images in each trial of the RSVP.';
drawCenteredText(p, str, 100)

str = 'You are going to report both faces at the end of each trial';
drawCenteredText(p, str, 0)

str = 'Press any button to continue.';
drawCenteredText(p, str, -200)

Screen('Flip', p.whandle);

%wait for any key
KbWait;


    
    
    
