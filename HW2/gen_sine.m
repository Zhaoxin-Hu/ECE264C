% Generate a sine wave with dsp.SineWave.
% clc
% clf
% close all
% clearvars

amp = 1;
freq = 100;
phase = 0;
fs = 1000;

x_sin = dsp.SineWave('Amplitude',amp,'Frequency',freq,'PhaseOffset',phase,...
    'ComplexOutput',false,'SampleRate',fs);