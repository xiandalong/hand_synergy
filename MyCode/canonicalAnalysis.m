function canonicalAnalysis(canon,labels)
c1 = canon(:,1);
c2 = canon(:,2);
c3 = canon(:,3);
figure
h2 = gscatter(c2,c1,labels,[],'oxs');
gu = unique(labels);
for k = 1:numel(gu)
      set(h2(k), 'ZData', c3( strcmp(labels, gu(k)) ));
end
view(3)
grid on
% figure
% manovacluster(stats);
end