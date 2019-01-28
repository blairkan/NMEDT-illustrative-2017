% NMEDT_SDR_1_EEG.m
% -----------------------------------
% Illustrative analyses of Losorelli et al. (2017), Section 3.1.
% This script creates the plots of Figure 2 of the paper (EEG magnitude
% spectra and PC1 topoplot). Verified to work with Matlab R2013a and 
% R2016b; minor modifications may be needed for other versions.
%
% Dependencies: Custom helper files are included in the 'Misc' folder. The
% user needs to have EEGLAB in the path to produce the PC1 topoplot.
%
% (c) Steven Losorelli, Duc T. Nguyen, Jacek P. Dmochowski, and Blair
% Kaneshiro, 2017.

clear all; close all; clc;

uiwait(msgbox('In the next window, select the folder containing your EEG data.'))
inDir = uigetdir(pwd);
uiwait(msgbox('In the next window, select the ''Misc'' folder in the Code archive.'))
miscDir = uigetdir(pwd);

%%
addpath(genpath(inDir))
addpath(genpath(miscDir))
fs=125;
secStart = 15;
epochLenSec = 4 * 60;
epochLenSamp = fs * epochLenSec;

% Load all the data frames and take per-song mean across participants.
for i = 1:10
    currFn = ['song' num2str(i+20) '_Imputed.mat'];
    disp(['Loading ' currFn '...'])
    load(currFn);
    tempX_0 = eval(['data' num2str(i+20) ';']);
    tempX_dc = medianDCCorrectAllTrialsInStruct(tempX_0);
    tempX_epoch = tempX_dc(:, secStart*fs+(1:epochLenSamp), :); % chan x T x participant
    
    % Take mean of data across trials <--- this is our 'input' data frame
    trialMeanData(:,:,i) = medianDCCorrectAllTrialsInStruct(...
        squeeze(mean(tempX_epoch,3))); % chan x T x song
    clear tempX*
end
%%
% Load the tempos
load tempoHz.mat % tempoHz is a row vector
tempoMatrix = repmat(tempoHz, 6, 1) .* repmat(2.^(-2:3)', 1, 10);

[nChan, T, nSongs] = size(trialMeanData);
xax = (1:T) / (T/fs); % x-axis for plotting
xl = [0 15]; % xlim for plotting

% Analysis 1: Uniform spatial filter (mean of all channels)
channelMeansPerSong = squeeze(mean(trialMeanData, 1)); % T x song

% Analysis 2: PCA
% Do PCA once over contatenated data (a single spatial filter)
% Forward model projection (we don't need it here):
% A = R * W * inv(W' * R * W);
concatTrialMeans = [];
for i = 1:nSongs
    concatTrialMeans = [concatTrialMeans squeeze(trialMeanData(:, :, i))];
end
[U, S, V] = svds(concatTrialMeans, 1); % U is the spatial filter
concatPC1 = U' * concatTrialMeans; % it's a vector
PC1 = reshape(concatPC1, [], 10);

% Compute FFT for each
CH = abs(fft(channelMeansPerSong));
PC1 = abs(fft(PC1));

%%
close all;
fSize = 16;
nPl = 6;

% Songs 1-6
figure()
for i = 1:nPl
    subplot(2, nPl, i)
    p = plot(xax, CH(:,i), 'k', 'linewidth', 2);
    hold on;
    plotTempoLines_nolabels(tempoMatrix(:,i), 2);
    uistack(p, 'top')
    xlim(xl)
    set(gca, 'ytick', [], 'xtick', [0 5 10])
    if i <= nPl, set(gca, 'xtick', []); end
    if i==1
        ylabel('ME');
        text(-3, 0, 'Magnitude', 'rotation', 90, 'fontsize', 12,...
            'horizontalalignment', 'center')
    end
    box off
    title(['Song ' num2str(i)], 'fontsize', fSize)
    subplot(2, nPl, i+nPl)
    p = plot(xax, PC1(:,i), 'k', 'linewidth', 2);
    hold on;
    t = plotTempoLines_nolabels(tempoMatrix(:,i), 2);
    uistack(p, 'top')
    xlim(xl)
    set(gca, 'ytick', [], 'xtick', [0 5 10])
    if i == 1, ylabel('PC1'); end
    box off
    if i == 4
        text(-2, -15000, 'Frequency (Hz)', 'fontsize', 12,...
            'horizontalalignment', 'center')
    end
end

% Songs 7-10
figure()
for i = 1:4
    subplot(2, nPl, i)
    p = plot(xax, CH(:,i+nPl), 'k', 'linewidth', 2);
    hold on;
    plotTempoLines_nolabels(tempoMatrix(:,i+nPl), 2);
    uistack(p, 'top')
    xlim(xl)
    set(gca, 'ytick', [], 'xtick', [0 5 10])
    if i <= nPl, set(gca, 'xtick', []); end
    if i==1,
        ylabel('ME');
        text(-3, 0, 'Magnitude', 'rotation', 90, 'fontsize', 12,...
            'horizontalalignment', 'center')
    end
    box off
    title(['Song ' num2str(i+nPl)], 'fontsize', fSize)
    subplot(2, nPl, i+nPl)
    p = plot(xax, PC1(:,i+nPl), 'k', 'linewidth', 2);
    hold on;
    t = plotTempoLines_nolabels(tempoMatrix(:,i+nPl), 2);
    uistack(p, 'top')
    xlim(xl)
    set(gca, 'ytick', [], 'xtick', [0 5 10])
    if i == 1, ylabel('PC1'); end
    box off
    if i == 3
        text(-2, -11000, 'Frequency (Hz)', 'fontsize', 12, ...
            'horizontalalignment', 'center')
    end
    if i == 4
        tt = legend((t), '1/4x tempo', '1/2x tempo', 'Tempo',...
            '2x tempo', '4x tempo', '8x tempo');
    end
end


try
    tl = legend(tt);
    set(tl, 'Position', [.68 .4 .15 .2])
catch
    set(tt, 'Position', [.68 .4 .15 .2])
end
legend boxoff

subplot(2, nPl, [6 12])
ll = getLocs125;
topoplot(U, ll)
title('PC1', 'fontsize', fSize)
cb=colorbar('location', 'south');
cbpos = get(cb, 'position');
set(cb, 'position', [cbpos(1) cbpos(2)*.35 cbpos(3) cbpos(4)*.6]);