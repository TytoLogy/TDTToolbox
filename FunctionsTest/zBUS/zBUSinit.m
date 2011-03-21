function zBUS = zBUSinit(interface)
% zBUS = zBUSinit(interface)
% 
% Initializes and connects to zBus
% 
% Input Arguments:
% 	interface	'GB' for gigabit, 'USB' for USB (default = 'GB')
% 
% Output Arguments:
%	zBUS.status		0 if unsuccessful, ActiveX control handle to device if successful
%	zBUS.C		zBUS control
%	zBUS.handle		actXcontrol figure handle
%
% See also: RX#init, zBUStrig
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%	Created: 24 July, 2008
%				(modified from RX8init)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if nargin ~= 1
		disp('zBUSinit: using defaults, GB')
		interface = 'GB';
	elseif ~(strcmp(interface, 'GB') | strcmp(interface, 'USB'))
		% Make sure input args are in bounds
		warning('RX%init: invalid interface, using GB');
		interface = 'GB';
	else
		% Make text upper case
		interface = upper(interface);
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create invisible figure for control
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	zBUS.handle = figure;
	set(zBUS.handle, 'Visible', 'off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize Device
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	zBUS.C = actxcontrol('ZBUS.x', [5 5 26 26], zBUS.handle);
	
	if invoke(zBUS.C, 'connectZBUS', interface)
		zBUS.status = 1;
	else
		warning('zBUSinit: Unable to connect to zBUS')
		zBUS.status = 0;
	end

