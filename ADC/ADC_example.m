% An ADC
clc
clf
close all
clearvars

%% Signal and noise definition
delta = 1;
fsig = 44.5;
fs = 1000;
T = 10;
t = 0:1/fs:T;
N = length(t);
amp = 4;
phi = pi/3;
sigma = 1.5*delta;
x = amp*sin(2*pi*fsig*t+phi)+sigma*randn(1,N);

%% ADC definition
delta = 1;
numlvl = 9;
ADC1 = ADC(delta,numlvl);
e = ADC1.quant_err(x);
ADC1.plot(x)

 
%% Plot the histograms for the quantization error.
nbins = 50;
figure()
ehist = histogram(e,'NumBins',nbins,'Normalization','pdf');
xlabel('e_q')
ylabel('Probability density function')
title('PDF of e_q')