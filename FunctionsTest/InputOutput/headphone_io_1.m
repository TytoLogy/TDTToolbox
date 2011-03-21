function [resp, index] = headphone_io(iodev, stim_lr, inpts)
% function [resp, index] = headphone_io(iodev, stim_lr, inpts)
%
% for use with RPVD circuit RX8_2_BinauralStimResponseFiltered
%
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
RPtrig(iodev.C, 3);

% Set the output buffer length
RPsettag(iodev.C, 'StimDur', outpts);

% Load output buffer
out_msg = invoke(iodev.C, 'WriteTagV', 'data_outL', 0, stim_lr(1, :));
out_msg = invoke(iodev.C, 'WriteTagV', 'data_outR', 0, stim_lr(2, :));

% send the Soft trigger 1 to start
% (see circuit for details)
RPtrig(iodev.C, 1);

% Main Looping Section
sweep_end = RPgettag(iodev.C, 'SwpEnd');
while(sweep_end==0)
	sweep_end = RPgettag(iodev.C, 'SwpEnd');
end
sweepCount = RPgettag(iodev.C, 'SwpN');

%%%%%%%%%%%%%%%%%%
% Stop Playing
%%%%%%%%%%%%%%%%%%
RPtrig(iodev.C, 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the data from the buffers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get the current location in the buffer
index(1) = RPgettag(iodev.C, 'index_inL');
index(2) = RPgettag(iodev.C, 'index_inR');

%reads from the buffer
resp{1} = double(invoke(iodev.C, 'ReadTagV', 'data_inL', 0, inpts));
resp{2} = double(invoke(iodev.C, 'ReadTagV', 'data_inR', 0, inpts));

