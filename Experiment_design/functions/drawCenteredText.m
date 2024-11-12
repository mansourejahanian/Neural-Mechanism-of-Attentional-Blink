function drawCenteredText(p, str, y)
    word_size = Screen('TextBounds', p.whandle, str);
    Screen('DrawText', p.whandle, str, p.xCenter-word_size(3)/2, p.yCenter-y, [0 0 0]);