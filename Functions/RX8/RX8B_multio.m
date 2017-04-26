function [resp, mcIndex] = RX8B_multio(iodev, zdev, stim, inpts)
% [resp, mcIndex] = RX8B_multio(iodev, zdev, stim, inpts)
%	NOTE:  performs MINIMAL to NO checks on input variables!!!!
%			Use with caution and attention!
%
% D/A channel on RX8_2 is set in circuit (hard-wired)

% Set the output buffer length
RPsettag(iodev, 'StimDur', length(stim));

% send reset command (software trigger 3)
RPtrig(iodev, 3);

% Load output buffer
out_msg = invoke(iodev.C, 'WriteTagV', 'data_out', 0, stim);

% send the zBustrigA to start acquisition (see circuit for details)
status = zBUStrigA(zdev, 0, 0, 4);

% Main Looping Section
sweep_end = RPgettag(iodev, 'SwpEnd');
while(sweep_end == 0)
	sweep_end = RPgettag(iodev, 'SwpEnd');
end
sweepCount = RPgettag(iodev, 'SwpN');

% Stop Playing
zBUStrigB(zdev, 0, 0, 4);

% Get the data from the buffer
% get the current location in the buffer
mcIndex = RPgettag(iodev, 'mcIndex');

if mcIndex < inpts
	inpts = mcIndex;
end

%reads from the buffer
resp = double(invoke(iodev.C, 'ReadTagV', 'mcData', 0, inpts));
