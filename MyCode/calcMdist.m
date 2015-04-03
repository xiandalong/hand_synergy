% calculate Mahalanobis Distance between sync and async for each hand

function Mdist = calcMdist(dataset_1,dataset_2)


mean_1 = mean(dataset_1,1);
mean_2 = mean(dataset_2,1);

pooledCov = (cov(dataset_1)+cov(dataset_2))/2;

Mdist = sqrt((mean_1-mean_2)*inv(pooledCov)*(mean_1-mean_2)');


% use [s,h] = silhouette(X,clust) plots the silhouettes for evaluating the
% clustering quality