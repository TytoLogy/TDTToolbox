function value = PA5reset(PA5)
% function value = PA5reset(PA5)
% 
% resets PA5 attenuator 
% 
% Input Arguments:
% 	PA5 	PA5 interface structure
%		PA5.status		0 if unsuccessful, ActiveX control handle to device if successful
%		PA5.C				PA5 control
%		PA5.handle		actXcontrol figure handle
% 
% Output Arguments:
% 	value			-1 if unsuccessful
%
% See also: PA5init, PA5setatten
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------
% Sharad Shanbhag
% sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
% Created: 6 Feb 2008
%
% Revisions:
% 		24 October, 2008:	(SJS)	
% 			- changed to RPstruct return type that has handle for the figure
% 			  and C element for the control element; now consistent with
% 			  other tdt init functions and compatible with RPclose() function
% 		3 September, 2009 (SJS):
% 			-	changed call to eliminate use of invoke function
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if nargin ~= 1
		warning('PA5reset: bad arguments')
		value = -1;
		return;
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get atten value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	value = invoke(PA5.C, 'Reset');
	value = PA5.C.Reset;


