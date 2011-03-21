function out = extractRPDevInfo(RPstruct)
% out = extractRPDevInfo(RPstruct)
% 
%
% Input Arguments:
% 
% Output Arguments:
%
% See Also: 
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Sharad J. Shanbhag
% sshanbha@aecom.yu.edu
%--------------------------------------------------------------------------
% Revision History
% 	6 March 2009 (SJS): Created
%--------------------------------------------------------------------------
% TO DO:
%--------------------------------------------------------------------------


% RPstruct fields:
%  	RPstruct.handle			figure handle for R
% 	RPstruct.C				activeX control handle
% 	RPstruct.Circuit_Path	path to circuits directory (.rco files) (default = 'C:\TDT')
% 	RPstruct.Circuit_Name	circuit name (no default)
% 	RPstruct.status			status
% 	RPstruct.Fs				sampling rate (samples/s)


out.Circuit_Path = RPstruct.Circuit_Path;
out.Circuit_Name = RPstruct.Circuit_Name;
out.Fs = RPstruct.Fs;
out.Dnum = RPstruct.Dnum;
