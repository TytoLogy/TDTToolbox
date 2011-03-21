function status = RPrun(RPstruct)
%------------------------------------------------------------------------
% status = RPrun(RPstruct)
%------------------------------------------------------------------------
% 
% Runs circuit loaded on  RP device
% 
%------------------------------------------------------------------------
% Input Arguments:
% 	RPstruct			RP structure (from R?init function; e.g. RX8init)
%		RPstruct.C			activeX control handle
%		RPstruct.handle	figure handle
% 
% Output Arguments:
% 	status		0 if unsuccessful, 1 if succesful
%
%------------------------------------------------------------------------
% See also: RPtrig, RPload
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 21 September, 2009 (SJS)
%
% Revisions:
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 1 
	error([mfilename ': bad arguments'])
end
if ~isstruct(RPstruct)
	error([mfilename ': is not a structure'])
end
if ~isfield(RPstruct, 'C')
	error([mfilename ': is not a valid structure'])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Issue Run Command
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
status = RPstruct.C.Run;