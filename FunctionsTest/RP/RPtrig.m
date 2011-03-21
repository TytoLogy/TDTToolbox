function status = RPtrig(RPstruct, trigval)
% status = RPtrig(RPstruct, trigval)
% 
% Sends trigger number trigval to RPstruct.C control RPstr
% 
% Input Arguments:
% 	RP	activeX control handle
% 	trigval trigger value (1-10)
% 
% Output Arguments:
% 	status		0 if unsuccessful, 1 if succesful
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
% Created: 27 April, 2006
%
% Revisions:
% 		5 August, 2008:	(SJS)	
% 			- changed to RPstruct input type that has handle for the figure
% 			  and C element for the control element; now consistent with
% 			  other tdt init functions and compatible with RPclose() function
%
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 2
	error('rptrig: bad arguments')
end

if ~between(trigval, 1, 10)
	error('rptrig: trigval out of bounds [1-10]')
end

% status = invoke(RPstruct.C, 'SoftTrg', trigval);