function [respondersStruct,nonRespondersStruct]=HistDriver_v2
close all hidden
%load structures with all patient data

load('../../../nonRespondersStruct.mat')
load('../../../respondersStruct.mat')

% Create Histograms for Individual Patients
HistPerPatient(respondersStruct);
HistPerPatient(nonRespondersStruct);
end

