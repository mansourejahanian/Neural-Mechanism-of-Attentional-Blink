
function [pValue, stat] = ttest_function(x,y,p,height)

% x and y are inputs
% p is struct for experimnet
% height is the height of stars

[h,pValue,ci,stat] = ttest(x,y);
%pValue = round(pValue,3);

if pValue > 0.05 
    stars = 'ns';
elseif pValue <= 0.05  && pValue > 0.01
    stars = '*';
elseif pValue <= 0.01 && pValue > 0.001
    stars = '**';
elseif pValue <= 0.001
    stars = '***';
end

% plot the line for significancy
%plot([p.lags(end-1) p.lags(end)], [0.4 0.4], 'black', 'LineWidth',2)
%plot([p.lags(end-1) p.lags(end-1)], [0.3 0.32], 'black', 'LineWidth',1.5)
%plot([p.lags(end) p.lags(end)], [0.3 0.32], 'black', 'LineWidth',1.5)

% plot the stars and value, ** means p<0.010 
text(5, height, stars,'FontSize',16,HorizontalAlignment='center')

end