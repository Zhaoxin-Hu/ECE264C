% Generate a sampled sine wave with sampling jitter.
clc
clf
close all
clearvars

sigma = 1e-12; % Variance
N = 50; % Number of segments
M = 1000; % Segment length
fsig = 10e6; % Signal frequency
fs = 1e12; % Sampling frequency;

dJit = sigma*randn(N*M,1).';
% dJit = 0;
tNoJit = 0:1/fs:N*M/fs;
tNoJit = tNoJit(1:N*M);
tJit = tNoJit+dJit;

v = sin(2*pi*fsig*tJit); % +randn(1,N*M);
PSD_plot(v,M,N,fsig,fs)