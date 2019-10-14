% First mult then conv = first conv then mult?
clc
clf
close all
clearvars

x = [1,2,3,4];
w = [0.5,1,1,0.5];
v = x.*w;

% First mult then conv.
y1 = conv(v,fliplr(v));

% First conv then mult.
xx = conv(x,fliplr(x));
ww = conv(w,fliplr(w));
y2 = xx.*ww;