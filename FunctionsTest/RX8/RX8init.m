function [RPstruct] = RX8init(interface, device_num)
% [RPstruct] = RX8init(interface, device_num)
% 
% Initializes and connects to RX8
% 
% Input Arguments:
% 	interface	'GB' for gigabit, 'USB' for USB (default = 'GB')
% 	device_num	device ID number, use zBUSMon to verify (default = 1)
% 
% Output Arguments:
% 	RPstruct		0 if unsuccessful
%	RPstruct.C	ActiveX control handle
%	RPstruct.handle	figure handle for R
%
% See also: RPload, RPhalt, zBUSinit, RX5init, PA5init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
%	Created: 27 April, 2006
%
% Revisions:
% 		4 August, 2008:	(SJS)	
% 			- changed to RPstruct return type that has handle for the figure
% 			  and C element for the control element; now consistent with
% 			  other tdt init functions and compatible with RPclose() function
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if nargin ~= 2
		disp('RX8init: using defaults, GB and device 1')
		interface = 'GB';
		device_num = 1;
	end

	% Make text upper case
	interface = upper(interface);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make sure input args are in bounds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if ~(strcmp(interface, 'GB') | strcmp(interface, 'USB'))
		warning('RX8init: invalid interface, using GB');
		interface = 'GB';
	end

	if device_num < 1
		warning('RX8init: invalid device_num, using 1');
		device_num = 1;
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create invisible figure for control
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	RPstruct.handle = figure;
	set(RPstruct.handle, 'Visible', 'off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize Device
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	RPstruct.C = actxcontrol('RPco.x',[5 5 26 26], RPstruct.handle);

	%Clears all the Buffers and circuits on that RP2
	invoke(RPstruct.C,'ClearCOF');

	%connects RP2 via USB or Xbus given the proper device number
	invoke(RPstruct.C, 'ConnectRX8', interface, device_num);

