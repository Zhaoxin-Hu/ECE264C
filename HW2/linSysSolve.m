% This is a subroutine which produces the A matrix and the b vector for the
% linear system.
clc
clf
close all
clearvars

harmIdxNn = [1,2]; % Non-negative harmonic indices
fnorm = 0.2; % Normalized frequency
winType = 'hanning'; % Window type
M = 10000; % Window length
n = 0:M-1;
W = exp(1j*2*pi*fnorm);
win = eval(sprintf("%s(%d)",winType,M));
win = win.';

datSeg = cos(2*pi*fnorm*n+0.2)+cos(2*pi*2*fnorm*n+0.5)+0.5*rand(1,M);

harmIdxAll = [-2,-1,1,2]; % All harmonic indices.
for l = 1:length(harmIdxAll)
    b(l) = mean(datSeg.*W.^(harmIdxAll(l)*n));
    for k = 1:length(harmIdxAll)
        a(l,k) = mean(W.^((harmIdxAll(l)+harmIdxAll(k))*n));
    end
end

b = b.';
Yhat = linsolve(a,b);
A = 2*abs(Yhat([3,4]));
phi = angle(Yhat([3,4]));