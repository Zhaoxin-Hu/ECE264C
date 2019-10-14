clf
close all
clearvars

N = 500; % Number of segments
M = 1001; % Length of segment
fs = 1000; % Sampling frequency
fsig = 300; % Signal frequency
y = sin(2*pi*fsig/fs*[1:N*M]+0.2)+randn(1,N*M); % Data sequence
PSD_plot(y,M,N,fsig,fs)