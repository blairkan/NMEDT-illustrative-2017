function structDC = medianDCCorrectAllTrialsInStruct(structIn)
% structDC = medianDCCorrectAllTrialsInStruct(structIn)
% ------------------------------------------------------
% This function takes in a chan-by-time-by-trial song struct, median DC
% corrects on a single-trial basis, and outputs the data in a data matrix
% of the same size as the input. Uses nanmedian.
%
% (c) Blair Kaneshiro, 2017. 

[nChan, nTime, nTrials] = size(structIn);
structDC = nan(size(structIn));

for t = 1:nTrials
   currData = squeeze(structIn(:, :, t));
   structDC(:,:,t) = medianDCCorrect(currData);
end