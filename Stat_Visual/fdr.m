function [h, p_new] = fdr(pvalue, FDR)

% BH
N = length(pvalue);
p_sorted = sort(pvalue,'descend');


comp = (N:-1:1)/N * FDR;
comp = comp((end-N+1):end);

i = find(p_sorted <= comp,1,'first');

if isempty(i)
    p_new = 0;
else
    p_new = p_sorted(i);
end
h = pvalue <= p_new;

end

%     % method 1 % I wrote myself
%     if m==1
%         N = length(pvalue);
%         alpha = FDR/N:FDR/N:FDR;
%         
%         est_fdr = [];
%         for i = 1:length(alpha)
%             est_fdr = [est_fdr, alpha(i)*N/sum(pvalue<alpha(i))];
%         end
%         
%         [~, ind] = min(abs(est_fdr-FDR));
%         h = pvalue<alpha(ind);
%         p_new = alpha(ind);
% 
%     elseif m==2 % method 2 % BH
% 
%         N = length(pvalue);
%         p_sorted = sort(pvalue,'descend');
%         
%     
%         comp = (N:-1:1)/N * FDR;
%         comp = comp((end-N+1):end);
%     
%         i = find(p_sorted <= comp,1,'first');
%     
%         if isempty(i)
%             p_new = 0;
%         else
%             p_new = p_sorted(i);
%         end
%         h = pvalue <= p_new;
% 
%     elseif m==3 % BH with cumsum
% 
%         N = length(pvalue);
%         p_sorted = sort(pvalue);
%         
%         i = find(cumsum(p_sorted)>FDR,1);
% 
%         if isempty(i) || i==1
%             p_new = 0;
%         else
%             p_new = p_sorted(i-1);
%         end
% 
%         h = pvalue <= p_new;
%     end
