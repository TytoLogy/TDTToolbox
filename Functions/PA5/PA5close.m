function status = PA5close(PA5)
%------------------------------------------------------------------------
% status = PA5close(PA5)
%------------------------------------------------------------------------
% 
% closes PA5 attenuator device
% 
%------------------------------------------------------------------------
% Input Arguments:
% 	PA5 	PA5 interface structure
%		PA5.status		0 if unsuccessful, ActiveX control handle to 
%							device if successful
%		PA5.C				PA5 control
%		PA5.handle		actXcontrol figure handle
% 
% Output Arguments:
%	status		0 if unsuccessful, ActiveX control handle to device if successful
%
%------------------------------------------------------------------------
% See also: PA5init
%------------------------------------------------------------------------

%------------------------------------------------------------------------
% Sharad Shanbhag
% sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
% Created: 24 July, 2008
%				(modified from RX8init)
% Revisions:
% 		4 August, 2008:	(SJS)	
% 			- changed to PA5 struct type that has handle for the figure
% 			  and C element for the control element; now consistent with
% 			  other tdt init functions and compatible with PA5init() function

%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 1
	error('PA5close: no interface structure given')
end

if ~(PA5.status)
	error('PA5close: PA5 not active')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close the interface
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% delete the control
delete(PA5.C);

%close the figure
set(PA5.handle, 'Visible', 'on');
close(PA5.handle);

%set status to off
status = 0;
	
