%%%%%%%%%%%%%%%%%%%%%  MANOVA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANOVA grouping with sync/async %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % for mimicking
% data = mimic_all;
% syn_labels = labels_for_all(1:3600,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for grasping
data = grasp_all;
syn_labels = labels_for_all(3601:7200,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[d,p,stats] = manova1(data,syn_labels);
c1 = stats.canon(:,1);
c2 = stats.canon(:,2);
c3 = stats.canon(:,3);
figure
h1 = gscatter(c2,c1,syn_labels,[],'oxs');
gu = unique(syn_labels);
for k = 1:numel(gu)
      set(h1(k), 'ZData', c3( strcmp(syn_labels, gu(k)) ));
end
view(3)
grid on
%% MANOVA grouping with objects %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % for mimicking
% data = mimic_all;
% obj_labels = labels_for_all(1:3600,1);
% a. sync mimicking
data = mimic_sync;
obj_labels = labels_for_sync;
dendrogram_path = 'C:\Users\kelvi_000\OneDrive\Haptics research\hand_synergy\MyCode\mimic_all_figures\CA dendrogram mimic 6Objs 3D sync.eps';
cluster_plot_path = 'C:\Users\kelvi_000\OneDrive\Haptics research\hand_synergy\MyCode\mimic_all_figures\canonical analysis plot mimic 6Objs 3D sync.eps';

% % b. async mimicking
% data = mimic_async;
% obj_labels = labels_for_async;
% dendrogram_path = 'C:\Users\kelvi_000\OneDrive\Haptics research\hand_synergy\MyCode\mimic_all_figures\CA dendrogram mimic 6Objs 3D async.eps';
% cluster_plot_path = 'C:\Users\kelvi_000\OneDrive\Haptics research\hand_synergy\MyCode\mimic_all_figures\canonical analysis plot mimic 6Objs 3D async.eps';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % for grasping
% data = grasp_all;
% syn_labels = labels_for_all(3601:7200,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[d,p,stats] = manova1(data,obj_labels);
c1 = stats.canon(:,1);
c2 = stats.canon(:,2);
c3 = stats.canon(:,3);
figure
h2 = gscatter(c2,c1,obj_labels,[],'oxs');
gu = unique(obj_labels);
for k = 1:numel(gu)
      set(h2(k), 'ZData', c3( strcmp(obj_labels, gu(k)) ));
end
view(3)
grid on
saveas(gcf,cluster_plot_path,'psc');
figure
manovacluster(stats);
ylim([0 55])
saveas(gcf,dendrogram_path,'psc');

%%%%%%%%%%%%%%%%%%%%% use the eigenvectors from grasping hand and apply it
%%%%%%%%%%%%%%%%%%%%% to mimicking hand data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% canon = (mimic_all-repmat(mean(mimic_all,1),size(mimic_all,1),1))*stats.eigenvec;
% canonicalAnalysis(canon,obj_labels);

%%%%%%%%%%%%%%%%%%%%% Trying MANOVA in R %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% see if the results are similar %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% converting the data into a .txt file 
% so the later data conversion become easier, other wise the loaded cell
% array in R shows as a weired list structure, which have several layers of
% capsulation
filename = 'data.txt';
A = [num2cell(data),labels_for_all(1:3600,:)];
% xlswrite(filename,A);
T = cell2table(A);
writetable(T,filename);
% it turns out only .txt file can be read into R as a data frame, using
% function read.table. .csv files or xls gave me a hard time to rearrange
% into a usable data frame. 
% The R code for MANOVA is under "..\Rcode\MANOVA.R"
% The two MANOVA tests all gave me very significant p value in both MATLAB
% and R.


%%%%%%%%%%%%%%%%%%%%%% using "manova" in MATLAB %%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 3/22/2015 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. put all data into a table
t = table(syn_labels,grasp_all(:,1),grasp_all(:,2),grasp_all(:,3),grasp_all(:,4),...
    grasp_all(:,5),grasp_all(:,6),grasp_all(:,7),grasp_all(:,8),...
    grasp_all(:,9),grasp_all(:,10),grasp_all(:,11),grasp_all(:,12),...
    grasp_all(:,13),grasp_all(:,14),grasp_all(:,15),grasp_all(:,16),...
    grasp_all(:,17),grasp_all(:,18),grasp_all(:,19),grasp_all(:,20),...
'VariableNames',{'sync','JA1','JA2','JA3','JA4','JA5','JA6','JA7','JA8','JA9','JA10',...
'JA11','JA12','JA13','JA14','JA15','JA16','JA17','JA18','JA19','JA20'});
JA = table([1:20]','VariableNames',{'JA'});
% 2. fit the data into repeated measure model
rm = fitrm(t,'JA1-JA20~sync','WithinDesign',JA);

manovatbl = manova(rm);

%%%%%%%%%%%%%%%%%%%%%% doing MANOVA for each object %%%%%%%%%%%%%%%%%%%%%%%
%% a. cone sync-async
% 1. put all data into a table
