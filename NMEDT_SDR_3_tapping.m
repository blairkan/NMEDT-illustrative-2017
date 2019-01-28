% NMEDT_SDR_3_tapping.m
% -----------------------------------
% Illustrative analyses of Losorelli et al. (2017), Section 3.1.
% This script creates the plots of Figure 3 of the paper (tapping
% responses). Verified to work with Matlab R2013a and R2016b; minor
% modifications may be needed to run on earlier versions.
%
% Dependencies: Custom helper files are included in the 'Misc' folder.
%
% (c) Steven Losorelli, Duc T. Nguyen, Jacek P. Dmochowski, and Blair
% Kaneshiro, 2017.


clear all; close all; clc;

uiwait(msgbox('In the next window, select the folder containing ''TapIt.mat''.'))
inDir = uigetdir(pwd);
uiwait(msgbox('In the next window, select the ''Misc'' folder in the Code archive.'))
miscDir = uigetdir(pwd);

%%
warning('off', 'MATLAB:warn_r14_stucture_assignment');
addpath(genpath(inDir))
addpath(genpath(miscDir))
load TapIt.mat
load tempoHz.mat
allTempos = repmat(tempoHz, 3, 1) .* repmat([.5; 1; 2], 1, 10);
load colors.mat

[nParticipants, nSongs] = size(allTappedResponse); % 20 x 10

tapStart = 15; tapStop = 32; % For plotting
interpStep = 0.5; % Temporal resolution of interpolated data

close all
interpX = 0:interpStep:35; % Requested x-axis for interpolated data
gr = [.3 .3 .3]; % A gray color
fSize = 12; % Font size

for s = 1:nSongs
    disp(['Song ' num2str(s)])
    for p = 1:nParticipants
        currIn = allTappedResponse{p, s}; % Vector - curr sub's taps in sec
        
        % Compute the midpoints between successive points (x-vals)
        currX = (currIn(2:end) + currIn(1:(end-1)))/2;
        
        % Compute the IOIs in Hz (y-vals)
        currIOI_sec = currIn(2:end) - currIn(1:(end-1));
        currIOI_Hz = 1 ./ currIOI_sec;
        allIOI_Hz{p} = currIOI_Hz;
        
        % Interpolate the IOIs so we are on a consistent time axis
        % Time x subs
        allSplInterpIOI_Hz(:,p) = interp1(currX, currIOI_Hz, interpX, 'spline');
        allLinInterpIOI_Hz(:,p) = interp1(currX, currIOI_Hz, interpX, 'linear');
    end
    
    figure(1)
    subplot(1,10, s)
    hold on;
    
    % Plot individual data
    plot(interpX, allLinInterpIOI_Hz, 'color', gr);
    
    % Plot tempo lines
    for c = 1:3
        lastwarn('');
        try
            temp = plot([0 35], [allTempos(c,s) allTempos(c,s)], 'linewidth', 3);
            temp.Color = [rgb10(c+1,:) .5];
            error(lastwarn)
        catch
            temp = plot([0 35], [allTempos(c,s) allTempos(c,s)],...
                'color', rgb10(c+1,:), 'linewidth', 3);
        end
    end
    if s~=1, set(gca, 'ytick', []); else set(gca, 'ytick', [0 3 6]); end
    %     set(gca, 'xtick', [20 25 30]);
    
    % Plot median data
    plot(interpX, nanmedian(allLinInterpIOI_Hz, 2), 'k', 'linewidth', 2);
    xlim([tapStart tapStop]);
    title(['Song ' num2str(s)], 'fontsize', fSize)
    if s == 1, text(11, 4.5, 'Instant. tempo (Hz)',...
            'horizontalalignment', 'center', 'rotation', 90, 'fontsize', fSize*.8); end
    if s==6, text(tapStart, -2.5, 'Time (sec)',...
            'horizontalalignment', 'center'); end
    
    % Compute median across time and store
    xaxUse = find(interpX >= tapStart & interpX <= tapStop);
    medianAcrossTime(s,:) = nanmedian(allLinInterpIOI_Hz(xaxUse,:),1);
    ylim([0 9])
    
    figure(2)
    subplot(1,10,s); hold on
    % Plot tempo lines
    for c = 1:3    
        lastwarn('')
        try
            temp = plot([allTempos(c,s) allTempos(c,s)], [0 20], 'linewidth', 3);
            temp.Color = [rgb10(c+1,:) .5];
            error(lastwarn)
        catch
            temp = plot([allTempos(c,s) allTempos(c,s)], [0 20],...
                'color', rgb10(c+1,:), 'linewidth', 3);
        end
    end
    [currN,currX]= hist(nanmedian(allLinInterpIOI_Hz(xaxUse,:),1), .5:.5:11.5);
    currH = bar(currX, currN, 'barwidth', .6);
    set(currH,'FaceColor','k','EdgeColor','none');
    box off
    xlim([0 7]); ylim([0 20]);
    if s ==6, text(0, -5.5, 'Median tempo (Hz)', 'horizontalalignment', 'center'); end
    if s ==1, ylabel('Count'); end
end
