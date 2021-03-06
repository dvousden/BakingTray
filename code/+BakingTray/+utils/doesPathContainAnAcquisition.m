function [acqPresent,details] = doesPathContainAnAcquisition(thisPath)
    % Returns whether a path contains an existing acquisition
    %
    % function [acqPresent,details] = BakingTray.utils.doesPathContainAnAcquisition(thisPath)
    %
    % Purpose
    % Returns whether a path contains an existing acquisition and if so optionally returns
    % a second output key details about this acquisition. This function can be used to 
    % aid in re-starting an existing acquisition and to test if it's safe to write data
    % into thisPath
    %
    %
    % Inputs
    % fname - Path to directory to test.
    %
    % Outputs
    % acqPresent - bool, true if an acquisition exists in thisPath
    % details - a structure contain details about the acquisition. 
    %
    % 
    % Rob Campbell - Basel, 2017


    acqPresent=false;
    details=struct;
    if isempty(thisPath)
        return
    end
    if ~exist(thisPath,'dir')
        fprintf('BakingTray.utils.doesPathContainAnAcquisition finds directory %s does not exist. \n', thisPath)
        return
    end


    % Look for a recipe file, an acquisition log file, and a rawData directory
    acqLogFile = dir(fullfile(thisPath,'acqLog_*.txt'));
    recipeFile = dir(fullfile(thisPath,'recipe_*.yml'));
    rawDataDirPresent = exist(fullfile(thisPath,'rawData'),'dir');

    if ~isempty(acqLogFile) && ~isempty(acqLogFile) && rawDataDirPresent
        acqPresent=true;
    else
        return
    end


    if length(acqLogFile)>1
        % Multiple acquisitions in one directory will likely cause problems and isn't supported.
        fprintf('BakingTray.utils.doesPathContainAnAcquisition finds multiple acquisition log files in %s\n',thisPath)
    end

    thisAcqLogFile = fullfile(thisPath,acqLogFile(1).name);
    details = BakingTray.utils.readAcqLogFile(thisAcqLogFile);
