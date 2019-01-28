% NMEDT_SDR_2_ratings.m
% -----------------------------------
% Illustrative analyses of Losorelli et al. (2017), Section 3.1.
% This script creates the plots of Figure 3 of the paper (participant
% ratings of familiarity and enjoyment). Verified to work with Matlab 
% 2016b; minor modifications may be needed to run on earlier versions.
%
% Dependencies: No custom helper files required.
%
% (c) Steven Losorelli, Duc T. Nguyen, Jacek P. Dmochowski, and Blair
% Kaneshiro, 2017.

clear all; close all; clc;
uiwait(msgbox('In the next window, select the folder containing ''behavioralRatings.mat''.'))
inDir = uigetdir(pwd);

%%
addpath(genpath(inDir))

load behavioralRatings.mat % sub x song x q
fSize = 16;
yl = [0 9];

figure()
subplot(2, 1, 1)
boxplot(behavioralRatings(:,:,1))
text(10.5, 10.5, 'Q1: Familiarity', 'fontsize', fSize,...
    'horizontalalignment', 'right')
ylabel('Rating', 'fontsize', fSize); ylim(yl)
set(gca, 'ytick', [1 5 9])
box off
subplot(2, 1, 2)
boxplot(behavioralRatings(:,:,2))
text(10.5, 10.5, 'Q2: Enjoyment', 'fontsize', fSize,...
    'horizontalalignment', 'right')
xlabel('Song Number', 'fontsize', fSize); 
ylabel('Rating', 'fontsize', fSize); ylim(yl)
set(gca, 'ytick', [1 5 9])
box off