%%%%%%%%%%%%%%%%%%%%%  MANOVA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANOVA grouping with sync/async %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[d,p,stats] = manova1([mimic_all;grasp_all],labels_for_all(:,2));
c1 = stats.canon(:,1);
c2 = stats.canon(:,2);
c3 = stats.canon(:,3);
syn_labels = labels_for_all(:,2);
h1 = gscatter(c2,c1,syn_labels,[],'oxs');
gu = unique(syn_labels);
for k = 1:numel(gu)
      set(h1(k), 'ZData', c3( strcmp(syn_labels, gu(k)) ));
end
view(3)
grid on
%% MANOVA grouping with objects %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[d,p,stats] = manova1([mimic_all;grasp_all],labels_for_all(:,1));
c1 = stats.canon(:,1);
c2 = stats.canon(:,2);
c3 = stats.canon(:,3);
obj_labels = labels_for_all(:,1);
h2 = gscatter(c2,c1,obj_labels,[],'oxs');
gu = unique(obj_labels);
for k = 1:numel(gu)
      set(h2(k), 'ZData', c3( strcmp(obj_labels, gu(k)) ));
end
view(3)
grid on
%%%%%%%%%%%%%%%%%%%%% Trying MANOVA in R %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% see if the results are similar %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% converting the data into a .txt file 
% so the later data conversion become easier, other wise the loaded cell
% array in R shows as a weired list structure, which have several layers of
% capsulation
filename = 'data.txt';
A = [num2cell([mimic_all;grasp_all]),labels_for_all];
% xlswrite(filename,A);
T = cell2table(A);
writetable(T,filename);
% it turns out only .txt file can be read into R as a data frame, using
% function read.table. .csv files or xls gave me a hard time to rearrange
% into a usable data frame. 
% The R code for MANOVA is under "..\Rcode\MANOVA.R"
% The two MANOVA tests all gave me very significant p value in both MATLAB
% and R.