% Testbench for dsptool
clc
clf
close all
clearvars

M = 1000;
N = 1000;
type = 'PSD';
nfft = 2^(nextpow2(M)+1);
n = 0:M*N-1;
x = 0.5*randn(1,M*N); % sin(2*pi*0.3*n);% +
dsp = dsptool(x,'segLen',M,'numSeg',N,'nfft',4096);
dsp.plotPSD();