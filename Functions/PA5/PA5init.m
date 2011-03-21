function PA5 = PA5init(interface, device_num, attenval)
% PA5 = PA5init(interface, device_num, attenval)
% 
% Initializes and connects to PA5 attenuator
% 
% Input Arguments:
% 	interface	'GB' for gigabit, 'USB' for USB (default = 'GB')
% 	device_num	device ID number, use zBUSMon to verify (default = 1)
%	attenval		initial attenuation value.  if omitted, default value
%					(120 dB) will be used.  To skip db setting, enter -1.
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
%		22 June, 2009:		(SJS)
% 			-	added attenval input and code to handle -1 or no arg settings
% 		3 September, 2009 (SJS):
% 			-	changed call to eliminate use of invoke function
%-------------------------------------------------------------------------

MAXATTEN = 120;
MINATTEN = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if ~between(nargin, 2, 3)
		interface = 'GB';
		device_num = 1;
		attenval = MAXATTEN
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
	PA5.C = actxcontrol('PA5.x', [5 5 26 26], PA5.handle);

	% connects PA5 via USB or Xbus given the proper device number
	% 	if invoke(PA5.C, 'ConnectPA5', interface, device_num) ~= 1
	% 		error('PA5init: Unable to connect');	
	% 	end
	if PA5.C.ConnectPA5(interface, device_num) ~= 1
		error('PA5init: Unable to connect');	
	end

	% Reset device
	PA5reset(PA5);
	
	PA5.status = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set initial atten value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% check if attenval was given
	if nargin == 3
		% if it was, see if it is non-negative
		if attenval >= MINATTEN
			% check to make sure it is within bounds
			if between(attenval, MINATTEN, MAXATTEN)
				PA5setatten(PA5, attenval);
			else
				warning([mfilename ': initial attenuation too large, using 120']);
				PA5setatten(PA5, MAXATTEN);
			end
		end
		% if negative, don't set value!
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check error status
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	errorl = invoke(PA5.C, 'GetError');
	errorl = PA5.C.GetError;
	if length(errorl) ~= 0
		invoke(PA5.C, 'Display', errorl, 0);
		PA5.status = -1;
	end


	
