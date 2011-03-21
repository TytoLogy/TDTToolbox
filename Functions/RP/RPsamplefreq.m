function Fs = RPsamplefreq(RPstruct)
% function Fs = RPsamplefreq(RPstruct)
% 
% Checks sample rate of device RPstruct
% 
% Input Arguments:
%	RPstruct				RP structure (from R?init function; e.g. RX8init)
%		RPstruct.C			activeX control handle
%		RPstruct.handle	figure handle
% 
% Output Arguments:
% 	Fs	0 if unsuccessful, sample rate
%
% See also: RPload, RPhalt RX8init, RX5init, RPcheckstatus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------
% Sharad Shanbhag
% sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
% Created: 27 April, 2006
%
% Revisions:
% 		19 January, 2009:	(SJS)	
%			-	changed to RPstruct input type that has handle for the 
% 				figure and C element for the control element. Consistent with
% 				other tdt init functions and compatible with RPclose() function
% 		3 September, 2009 (SJS):
% 			-	changed calls to eliminate use of invoke function
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input argument i ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 1
	error([mfilename ': bad argument'])
elseif ~isstruct(RPstruct)
	error([mfilename ': RPstruct is not a struct'])	
elseif ~isfield(RPstruct, 'C')
	error([mfilename ': RPstruct is not a valid struct'])	
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Check Fs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fs = RPstruct.C.GetSFreq;
