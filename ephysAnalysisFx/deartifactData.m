function deartifactData(pathToFile, overwrite)

%% fix arguments
if nargin < 2
    % assume that we don't want to overwrite; option provides for forcing
    % re-runs of data in the event that a re-processing from source is
    % desired
    overwrite = false;
end

if nargin > 2
    warning('deartifactData is ignoring extra arguments!');
end

%% let's do it recursively.

% check that we haven't requested something silly like 
if ( ~isempty( strfind( pathToFile, 'deartifacted' ) ) )
    warning('Sorry dude, I refuse to deartifact a deartifact folder!')
    return;
end

% do this on every data directory, in case we are reprocessing several days
% or something due to bugs (which I clearly never write into code)
fileList = dir( pathToFile );
% Get a logical vector that tells which is a directory.
dirFlags = [fileList.isdir];
if (~isempty(dirFlags))
    % Extract only those that are directories.
    subFolders = fileList(dirFlags);
    % call the function on all the subfolders
    for k = 1 : length(subFolders)
        %fprintf('Sub folder #%d = %s\n', k, subFolders(k).name);
        % don't process existing subfolders of deartifacted data!
        % also don't process this folder, and the folder above...
        if ( isempty( strfind( subFolders(k).name, 'deartifacted' ) ) ) && ~strcmp( subFolders(k).name, '.' ) && ~strcmp( subFolders(k).name, '..' )
            deartifactData(fullfile( pathToFile, subFolders(k).name ));
        end
    end
end

%% Work through the list of files
%
% list all the files in the path
fileList = dir( fullfile( pathToFile, '*.ncs' ) );
if isempty(fileList) 
    warning(['There are no files in the path supplied : ' pathToFile]);
    return;
end

% not to be fooled by funny directory names, ignore directories, only
% choose actual files here.
% TODO figure out how to fix this, in case it's a problem
% matlab complains about this line for some reason
%fileList = { fileList.name( ~[fileList.isdir]) }';
fileList = { fileList.name }';

if isempty(fileList) 
    warning(['There are no files I want to process in the path supplied! : ' pathToFile]);
    return;
end

% check to see if we have a landing folder
% TODO this is probably going to be screwed up on Windows.
if ~( exist( fullfile( pathToFile, '/deartifacted/' ), 'file' ) )
   mkdir( fullfile( pathToFile, '/deartifacted' ) )
end

% now we're going to actually process the files in the directory
for fileIdx = 1:numel(fileList)
    filename = char(fileList(fileIdx));
    disp(['STARTING : ' filename ]);
    % check that the deartifacted file doesn't exist
    % if the file doesn't exist, process it.
    % OR
    % if the file exists AND we want to overwrite, process the file
    if ~( exist( fullfile( pathToFile, '/deartifacted/', filename ), 'file' ) ) || ( ( exist( fullfile( pathToFile, '/deartifacted/', filename ), 'file' ) ) && overwrite )
            % set up some variables
            temp = strsplit( filename, '.' );
            deartName = char(strcat(temp(1), '_deart.ncs' ));
            fullPathDearted = fullfile( pathToFile, '/deartifacted/' );
            % load the file
            [ cscLFP, nlxCscTimestamps, cscHeader, channel, sampFreq, nValSamp ] = csc2mat( fullfile( pathToFile, '/',filename ) );
            % deartifact the file
            [ correctedCsc, idxs, mxValues, meanCscWindow ] = cscCorrection( cscLFP, nlxCscTimestamps );
            %[ correctedCsc, idxs, mxValues, meanCscWindow ] = cscCorrection( pathToFile, fileName, saveFile)
            % save the file
            mat2csc( deartName, fullPathDearted, cscHeader, correctedCsc, nlxCscTimestamps, channel, nValSamp, sampFreq );
            disp(['FINISHED : ' filename ]);
    else
        disp(['SKIPPING : ' filename ]);
    end
    disp([num2str(round(100*fileIdx/numel(fileList))) '% ( ' num2str(fileIdx) ' of ' num2str(numel(fileList)) ' )' ]);
end


end