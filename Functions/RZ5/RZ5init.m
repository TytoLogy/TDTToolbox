function RPstruct = RZ5init(interface)
%------------------------------------------------------------------------
% RPstruct = RZ5init(interface)
%------------------------------------------------------------------------
% 
% Initializes and connects to RZ5
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
% Created: 26 July, 2010
%				(modified from RZ5init)
% Modified:
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 1
	disp([ mfilename ': using defaults, GB']);
	interface = 'GB';
end
device_num = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make sure input args are in bounds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make text upper case
interface = upper(interface);
if ~(strcmp(interface, 'GB') || strcmp(interface, 'USB'))
	warning('%s: invalid interface, using GB', mfilename);
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
% Create ActiveX control object
RPstruct.C = actxcontrol('RPco.x',[5 5 26 26], RPstruct.handle);

%Clears all the Buffers and circuits on that RP2
% invoke(RPstruct.C, 'ClearCOF');
RPstruct.C.ClearCOF;

%connects RP2 via USB or Xbus given the proper device number
% invoke(RPstruct.C,'ConnectRX5', interface, device_num);
RPstruct.C.ConnectRZ5(interface, device_num);

% Since the device is not started, set status to 0
RPstruct.status = 0;

