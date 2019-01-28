function t = plotTempoLines_nolabels(tempoVector, linewidth, linetype)
% t = plotTempoLines_nolabels(tempoVector, [linewidth], [linetype])
% ----------------------------------------------------------
% This function takes in a vector of tempos and optional linewidth and 
% linetype args, and adds them to an EXISTING plot. You should hold on 
% prior to calling this function. Color palette is loaded and called 
% within this function.
%
% (c) Blair Kaneshiro, 2017.

load colors.mat
yl = get(gca, 'ylim');
if ~exist('linewidth'), linewidth = 1; end
if ~exist('linetype'), linetype = '--'; end

for i = 1:length(tempoVector)
    currCol = rgb10(i,:);
    t(i) = plot([tempoVector(i) tempoVector(i)], yl, linetype,...
        'linewidth', linewidth,...
        'color', currCol);
end