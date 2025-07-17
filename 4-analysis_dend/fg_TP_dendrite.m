function fg_TP_dendrite(TPr, FPr, FNr, ttl, fgOpts)

fg_sz = [300 300];
sd = 0.2;
ndp = height(TPr);

x = zeros(ndp,3);
for i = 1:3
    x(:,i) = i+rand(ndp,1)*sd - sd/2;
end

labelSet = {'True Positives', 'False Positives', 'False Negatives'};

f = figure();

plot(x(:,1),TPr*100,'ok','MarkerFaceColor','k');
hold on;
plot(x(:,2),FPr*100,'ok','MarkerFaceColor','k');
plot(x(:,3),FNr*100,'ok','MarkerFaceColor','k');

boxplot([TPr*100 FPr*100 FNr*100],...
    'labels',labelSet);

% edit
box off;
ylim([0 100]);
ax = gca();
ax.FontSize= fgOpts.FsizeAx;
ytickformat('percentage');
title(ttl,'FontSize',fgOpts.FsizeTtl);

f.Position(3:4) = fg_sz;

end