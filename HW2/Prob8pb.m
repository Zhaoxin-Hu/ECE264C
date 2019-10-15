% Script to test functions from Problem 6 of HW1 of ECE 264C
sigma = 1e-12; % Variance

dJit = sigma*randn(N*M,1).';
tNoJit = 0:1/fs:N*M/fs;
tNoJit = tNoJit(1:N*M);
tJit = tNoJit+dJit;

data = sin(2*pi*fsig*tJit);

N = 1000000; % Length of data sequence
f_signal = 10e6;
f_s = 1e9;
n = 0:(N - 1);
initial_phase = 0;
% Generate data consisting of a sinusoidal term and zero-mean white noise
% with variance 1
% data = sin(2 * pi * f_signal / f_s * n + initial_phase)';
% PSD estimation parameters
periodogram_length = 10000;
num_segments = 100;
% Plot PSD of data and sinusoid and noise components and compute their
% total power
[sinusoid_power, data_minus_sinusoid_power] = plot_periodogram(data,periodogram_length, num_segments, f_signal, f_s);