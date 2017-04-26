function status = PA5setatten(PA5, atten_val)
%------------------------------------------------------------------------
% function status = PA5setatten(PA5, atten_val)
%------------------------------------------------------------------------
% 
% sets PA5 attenuator
% 
%------------------------------------------------------------------------
% Input Arguments:
% 	PA5 	PA5 interface structure (can be array of structures)
%		PA5.status		0 if unsuccessful, ActiveX control handle to device if successful
%		PA5.C				PA5 control
%		PA5.handle		actXcontrol figure handle
% 
%	atten_val		dB attenuation (0 - 120)
%
% Output Arguments:
% 	status			-1 if unsuccessful, dB val if successful
%
%------------------------------------------------------------------------
% See also: PA5init, PA5getatten
%------------------------------------------------------------------------

%------------------------------------------------------------------------
% Sharad Shanbhag
% sshanbhag@neomed.edu
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
%	27 Apr 2016 (SJS): minor documentation updates
%	29 Apr 2016 (SJS): reworked to allow array inputs
%-------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 2
	warning('PA5setatten: bad arguments')
	status = -1;
	return;
end
if ~(PA5.status)
	warning('PA5 not active')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make sure input args are in bounds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ATT_MAX = 120;
ATT_MIN = 0;
if any(~between(atten_val, ATT_MIN, ATT_MAX))
	warning('PA5setatten: atten_val out of range 0-120 dB');
	status = -1;
	return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Set atten value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
status = -1*ones(size(PA5));
for n = 1:length(PA5)
	invoke(PA5(n).C, 'SetAtten', atten_val(n));
	errorl=PA5(n).C.GetError;
	if length(errorl) ~= 0 %#ok<ISMT>
		PA5(n).C.Display(errorl, 0);
		status = -1;
		return;
	else
		status(n) = PA5getatten(PA5(n));
	end
end





