function [resp, index] = headphonecal2_io(iodev, stim, inpts)
% [resp, index] = headphonecal2_io(iodev, stim, inpts)
%
max_outpts=150000;
max_inpts = 150000;

% check to make sure the length of the output signal is inside limit
outpts = length(stim);
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
RPtrig(iodev, 3);

% Set the output buffer length
RPsettag(iodev, 'StimDur', outpts);

% Load output buffer
out_msg = invoke(iodev.C, 'WriteTagV', 'data_outL', 0, stim(1, :));
out_msg = invoke(iodev.C, 'WriteTagV', 'data_outR', 0, stim(2, :));

% send the Soft trigger 1 to start
% (see circuit for details)
RPtrig(iodev, 1);

% Main Looping Section
sweep_end = RPgettag(iodev, 'SwpEnd');
while(sweep_end==0)
	sweep_end = RPgettag(iodev, 'SwpEnd');
end
sweepCount = RPgettag(iodev, 'SwpN');

%%%%%%%%%%%%%%%%%%
% Stop Playing
%%%%%%%%%%%%%%%%%%
RPtrig(iodev, 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the data from the buffer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get the current location in the buffer
index = RPgettag(iodev, 'index_in1');

%reads from the buffer
resp{1} = double(invoke(iodev.C, 'ReadTagV', 'data_in1', 0, inpts));
resp{2} = double(invoke(iodev.C, 'ReadTagV', 'data_in2', 0, inpts));
resp{3} = double(invoke(iodev.C, 'ReadTagV', 'data_in3', 0, inpts));


