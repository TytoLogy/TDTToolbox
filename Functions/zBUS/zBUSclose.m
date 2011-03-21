function zStatus = zBUSclose(zBUS)
%------------------------------------------------------------------------
% zStatus = zBUSclose(zBUS)
%------------------------------------------------------------------------
% 
% closes zBus
% 
%------------------------------------------------------------------------
% Input Arguments:
% 	zBUS	zBUS interface structure
%		zBUS.status		0 if unsuccessful, ActiveX control handle to device if successful
%		zBUS.C			zBUS control
%		zBUS.handle		actXcontrol figure handle
% 
% Output Arguments:
%	zStatus		0 if unsuccessful, ActiveX control handle to device if
%					successful
%------------------------------------------------------------------------
% See also: zBUSinit, zBUStrig
%------------------------------------------------------------------------

%------------------------------------------------------------------------
% Sharad Shanbhag
% sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 24 July, 2008
%				(modified from RX8init)
%
% Revisions:
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 1
	error('zBUSclose: no interface structure given')
end

if ~(zBUS.status)
	error('zBUSclose: zBUS status not indicated active')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close the interface
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% delete the control
delete(zBUS.C);

%close the figure
set(zBUS.handle, 'Visible', 'on');
close(zBUS.handle);

%set status to off
zStatus = 0;
