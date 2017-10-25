%% Gilad & Ronen - 25/10/17
% showing differece between before and after processing of signals.

clear; clc;

%% Get files:
[preName,prePathName] = uigetfile('*.mat','Enter the original data mat file');
[procName,procPathName] = uigetfile('*.mat','Enter the processed data mat file:');
[badName,badPathName] = uigetfile('*.mat','Enter the bad electrodes mat file:');

%% Splitting files
pre_file = load([prePathName,preName]);
proc_file = load([procPathName,procName]);
bad_file = load([badPathName,badName]);

str_split = strsplit(procPathName,'\');
subj = str_split{end-3};

%% Show figure
figure()
subplot(3,1,1);
plot(pre_file.F');
title(['Original EEG data of ',pre_file.Comment,' subject ', subj]);
subplot(3,1,2);
plot(proc_file.good_data');
title(['Processed EEG data of ',pre_file.Comment,' subject ', subj]);
ylabel('Amplitude (mV)');
subplot(3,1,3);
plot(pre_file.F(bad_file.bad_electrodes,:)');
title(['EEG bad electrodes data of ',pre_file.Comment,' subject ', subj]);
xlabel('time (ms)');
