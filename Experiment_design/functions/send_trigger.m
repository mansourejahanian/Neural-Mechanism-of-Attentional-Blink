function send_trigger(trigger,dt)
% function send_trigger(trigger,dt)

if(~exist('dt'))
    dt = 0.004; %4ms (2ms causes audio artifacts)
end

lptwrite(47304,trigger);
WaitSecs(dt);
lptwrite(47304,0);


