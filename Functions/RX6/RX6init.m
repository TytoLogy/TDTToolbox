function [RPstruct] = RX6init(interface, device_num)
%------------------------------------------------------------------------
% [RPstruct] = RX6init(interface, device_num)
%------------------------------------------------------------------------
% 
% Initializes and connects to RX6
% 
%------------------------------------------------------------------------
% Input Arguments:
% 	interface	'GB' for gigabit, 'USB' for USB (default = 'GB')
% 	device_num	device ID number, use zBUSMon to verify (default = 1)
% 
% Output Arguments:
% 	RPstruct		0 if unsuccessful
%	RPstruct.C	ActiveX control handle
%	RPstruct.handle	figure handle for R
%
%------------------------------------------------------------------------
% See also: RPload, RPhalt, zBUSinit, RX8init, PA5init
%------------------------------------------------------------------------

%------------------------------------------------------------------------
% Sharad Shanbhag
% sshanbhag@neoucom.edu
%------------------------------------------------------------------------
% Created: 19 August, 2009
%			(modified from RX5init)
% Modified:
% 	26 July, 2010 (SJS): updated format from older type
% 		-	some documentation updates and cleanup
% 		- removed invoke() statements to start device
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 1
	disp([mfilename ': using defaults, GB'])
	interface = 'GB';
end
device_num = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make sure input args are in bounds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make text upper case
interface = upper(interface);

if ~(strcmp(interface, 'GB') | strcmp(interface, 'USB'))
	warning([mfilename ': invalid interface, using GB']);
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
% invoke(RPstruct.C, 'ClearCOF');
RPstruct.C.ClearCOF;

%connects RX6 via USB or Xbus given the proper device number
RPstruct.C.ConnectRX6(interface, device_num);

% Since the device is not started, set status to 0
RPstruct.status = 0;
	
