function [resp, index] = headphone_stimrec(iodev, stim_lr, inpts)
% function [resp, index] = headphone_stimrec(iodev, stim_lr, inpts)
%
% plays stim_lr out headphones, records input spike data on 
% RX8(2), A/D channel 3

max_outpts = 150000;
max_inpts = 150000;

% check to make sure the length of the output signal is inside limit
outpts = length(stim_lr);
if ~between(outpts, 1, max_outpts)
	warning('length of stim out of range!')
	resp = 0;
	index = 0;
	return
end
if ~between(inpts, 0, max_inpts) 
	warning('inpts out of range')
	inpts = outpts;
end

% send reset command (software trigger 3)
RPtrig(iodev.RP, 3);

% Set the output buffer length
RPsettag(iodev.RP, 'StimDur', outpts);

% Load output buffer
out_msg = invoke(iodev.RP, 'WriteTagV', 'data_outL', 0, stim_lr(1, :));
out_msg = invoke(iodev.RP, 'WriteTagV', 'data_outR', 0, stim_lr(2, :));

% send the Soft trigger 1 to start
% (see circuit for details)
RPtrig(iodev.RP, 1);

% Main Looping Section
sweep_end = RPgettag(iodev.RP, 'SwpEnd');
while(sweep_end==0)
	sweep_end = RPgettag(iodev.RP, 'SwpEnd');
end
sweepCount = RPgettag(iodev.RP, 'SwpN');

%%%%%%%%%%%%%%%%%%
% Stop Playing
%%%%%%%%%%%%%%%%%%
RPtrig(iodev.RP, 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the data from the buffers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get the current location in the buffer
index = RPgettag(iodev.RP, 'index_in1');

%reads from the buffer
resp = double(invoke(iodev.RP, 'ReadTagV', 'data_in1', 0, inpts));

