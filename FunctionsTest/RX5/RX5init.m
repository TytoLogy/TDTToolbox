function [RPstruct] = RX5init(interface)
% [RPstruct] = RX5init(interface)
% 
% Initializes and connects to RX5
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
% See also: RPload, RPhalt, zBUSinit, RX8init, PA5init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%	Created: 18 December, 2007
%				(modified from RX8init)
%	Modified:
% 		4 August, 2008:	(SJS)	
% 			- changed to RPstruct return type that has handle for the figure
% 			  and C element for the control element; now consistent with
% 			  other tdt init functions and compatible with RPclose() function
%	Revisions:
% 		4 September, 2008:	(SJS)
% 			- created test functions
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if nargin ~= 1
		disp('RX5init: using defaults, GB')
		interface = 'GB';
	end
	device_num = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make sure input args are in bounds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Make text upper case
	interface = upper(interface);

	if ~(strcmp(interface, 'GB') | strcmp(interface, 'USB'))
		warning('RX%init: invalid interface, using GB');
		interface = 'GB';
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
	invoke(RPstruct.C, 'ClearCOF');

	%connects RP2 via USB or Xbus given the proper device number
	invoke(RPstruct.C,'ConnectRX5', interface, device_num);

