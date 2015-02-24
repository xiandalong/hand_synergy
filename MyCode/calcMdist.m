% calculate Mahalanobis Distance between sync and async
selection = [1:5 181:185]; % this is for the first subject and both hands for cone async
dataset_1 = mimic_all(selection,:);
dataset_2 = grasp_all(selection,:);

mean_1 = mean(dataset_1,1);
mean_2 = mean(dataset_2,1);

pooledCov = (cov(dataset_1)+cov(dataset_2))/2;

M_dist = sqrt((mean_1-mean_2)*inv(pooledCov)*(mean_1-mean_2)');

M = mahal(dataset_1,dataset_2);

% use [s,h] = silhouette(X,clust) plots the silhouettes for evaluating the
% clustering quality