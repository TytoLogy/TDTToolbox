function [resp, mcIndex] = RX8_2_multio(iodev, zdev, stim, inpts)
% [resp, index] = arrayOut_medusaIn(outdev, zdev, stim, outchan)
%	NOTE:  performs MINIMAL to NO checks on input variables!!!!
%			Use with caution and attention!
%
% Input Arguments:
% 
% Output Arguments:
%
% See also: RPload, RPhalt, zBUSinit, RX8init, PA5init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
%	Created: 18 December, 2007
%				(modified from RX8init)
%	Modified:
%------------------------------------------------------------------------


% Set the output D/A channel on RX8_1
RPsettag(outdev, 'OutputChannel', outchan);

% Set the output buffer length
RPsettag(outdev, 'StimDur', length(stim));

% D/A channel on RX8_2 is set outside program

% send reset command (software trigger 3)
RPtrig(outdev, 3);
RPtrig(indev, 3);

% Load output buffer
out_msg = invoke(outdev.C, 'WriteTagV', 'data', 0, stim);

% send the zBustrigA to start acquisition (see circuit for details)
status = zBUStrigA(zdev, 0, 0, 6);

% Main Looping Section
sweep_end = RPgettag(outdev, 'SwpEnd');
while(sweep_end == 0)
	sweep_end = RPgettag(outdev, 'SwpEnd');
end
sweepCount = RPgettag(outdev, 'SwpN');

% Stop Playing
zBUStrigB(zdev, 0, 0, 6);

% Get the data from the buffer
% get the current location in the buffer
mcIndex = RPgettag(indev, 'mcIndex');

if mcIndex < inpts
	inpts = mcIndex;
end

%reads from the buffer
resp = double(invoke(indev.C, 'ReadTagV', 'mcData', 0, inpts));
