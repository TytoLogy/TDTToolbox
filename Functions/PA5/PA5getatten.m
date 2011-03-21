function value = PA5getatten(PA5)
% function value = PA5getatten(PA5)
% 
% gets PA5 attenuator setting
% 
% Input Arguments:
% 	PA5 	PA5 interface structure
%		PA5.status		0 if unsuccessful, ActiveX control handle to device if successful
%		PA5.C				PA5 control
%		PA5.handle		actXcontrol figure handle
% 
% Output Arguments:
% 	value			-1 if unsuccessful, dB val if successful
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
%-------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if nargin ~= 1
		warning('PA5getatten: bad arguments')
		value = -1
		return;
	end
	if ~(PA5.status)
		warning('PA5 not active')
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get atten value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	value = invoke(PA5.C, 'GetAtten');
% 
% 	errorl=invoke(PA5.C, 'GetError');
% 	if length(errorl) ~= 0
% 		invoke(PA5.C, 'Display', errorl, 0)
% 		value = -1;
% 		return;
% 	end
	
	value = PA5.C.GetAtten;

	errorl=PA5.C.GetError;
	if length(errorl) ~= 0
		PA5.C.Display(errorl, 0);
		value = -1;
		return;
	end




