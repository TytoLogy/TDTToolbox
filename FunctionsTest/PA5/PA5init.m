function PA5 = PA5init(interface, device_num)
% PA5 = PA5init(interface, device_num)
% 
% Initializes and connects to PA5 attenuator
% 
% Input Arguments:
% 	interface	'GB' for gigabit, 'USB' for USB (default = 'GB')
% 	device_num	device ID number, use zBUSMon to verify (default = 1)
%
%	For Free Field rig, valid numbers are 1 and 2 (L, R)
% 
% Output Arguments:
% 	PA5		0 if unsuccessful
%	PA5.C	ActiveX control handle
%	PA5.handle	figure handle for R
%
% See also: RPload, RPhalt, zBUSinit, RX5init, PA5close
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------
% Sharad Shanbhag
% sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
% Created: 6 Feb 2008
%
% Revisions:
% 		4 August, 2008:	(SJS)	
% 			- changed to RPstruct return type that has handle for the figure
% 			  and C element for the control element; now consistent with
% 			  other tdt init functions and compatible with RPclose() function
%		4 September, 2008 (SJS)
%			- created as "test" function suite
%-------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if nargin ~= 2
		disp('PA5init: using defaults, GB and device 1')
		interface = 'GB';
		device_num = 1;
	end

	% Make text upper case
	interface = upper(interface);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make sure input args are in bounds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if ~(strcmp(interface, 'GB') | strcmp(interface, 'USB'))
		warning('PA5init: invalid interface, using GB');
		interface = 'GB';
	end

	if ~between(device_num, 1, 2)
		warning('PA5init: invalid device_num, using 1');
		device_num = 1;
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create invisible figure for control
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	PA5.handle = figure;
	set(PA5.handle, 'Visible', 'off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize Device
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% create atten value
	PA5.C = device_num;

	PA5.status = 120;
	
	pafile = sprintf('PA_%d', device_num);
	save(pafile, 'PA5');
	
