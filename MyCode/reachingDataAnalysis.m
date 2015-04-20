% get grip apertures for each object

%% 1. reading data
clear;clc
readDataFromAllSubjects;

%% 2. calculate reaching phase data for each trial
reachingData = {};

for j = 1:size(Data_all,1)
    reachingData = [reachingData,{Data_all.Object{j},Data_all.synchronized_asynchronized{j},...
        Data_all.