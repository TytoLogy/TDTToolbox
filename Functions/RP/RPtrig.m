function status = RPtrig(RPstruct, trigval)
%------------------------------------------------------------------------
% status = RPtrig(RPstruct, trigval)
%------------------------------------------------------------------------
% TDT toolbox
%------------------------------------------------------------------------
% Sends trigger number trigval to RPstruct.C control RPstr
% 
%------------------------------------------------------------------------
% Input Arguments:
% 	RPstruct			RP structure (from R?init function; e.g. RX8init)
%		RPstruct.C			activeX control handle
%		RPstruct.handle	figure handle
% 	trigval trigger value (1-10)
% 
% Output Arguments:
% 	status		0 if unsuccessful, 1 if succesful
%------------------------------------------------------------------------
% See Also: RPsettag, RPgettag, ZBUStrig
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
% Created: 27 April, 2006
%
% Revisions:
%	5 August, 2008:	(SJS)	
% 		- changed to RPstruct input type that has handle for the figure
% 		  and C element for the control element; now consistent with
% 		  other tdt init functions and compatible with RPclose() function
% 	3 September, 2009 (SJS):
% 		-	changed calls to eliminate use of invoke function
%	27 January, 2010 (SJS) updated documentation/help
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

status = RPstruct.C.SoftTrg(trigval);