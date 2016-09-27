function [] = eDebug(debugString,level,varargin)

%
%
%   In general, verbosity will be 1-3, for very low level stuff it will be
%   higher
%

global debugVerbosity;
global debugTerminal;
global debugFilepath;
global debugLimitToFiles;

if debugVerbosity > 0
    
    p = inputParser;
    p.addRequired('debugString');
    p.addOptional('level',5);
    p.parse(debugString,varargin{:});
    

    dbs = dbstack('-completenames');
    pathstr = dbs(1).file;
    if size(dbs,1) >= 2 
        pathstr = dbs(2).file;
        theline = dbs(2).line;
    end
    
    fprintf('file: %s:%i - %s\n',pathstr,theline,debugString);

    
end