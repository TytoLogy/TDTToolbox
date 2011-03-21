function [resp, index] = headphone_io(iodev, stim_lr, inpts)
% [resp, index] = headphone_io(iodev, stim_lr, inpts)
% 
% for use with RPVD circuit RX8_2_BinauralRefStimResponseFiltered
% 
% Input Arguments:
% 	iodev		TDT input/output device interface structure
%	stim_lr	[2XN] stimulus array, L channel in row 1, R channel in row 2
%	inpts		# of points to record from input channels
% 
% Output Arguments:
% 	resp		2 element response cell array (if no reference channel
% 				specified in iodev.REF)
% 				3 element response cell array if reference channel specified
%	index		buffer size
%
% See also: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
% Created: ?
%
% Revisions:
%	3 September, 2009 (SJS):
%		-	changed calls to eliminate use of invoke function
%		-	revised documentation
%------------------------------------------------------------------------

% maximum # of input and output points
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
RPtrig(iodev, 3);

% Set the output buffer length
RPsettag(iodev, 'StimDur', outpts);

% Load output buffer
% out_msg = invoke(iodev.C, 'WriteTagV', 'data_outL', 0, stim_lr(1, :));
% out_msg = invoke(iodev.C, 'WriteTagV', 'data_outR', 0, stim_lr(2, :));
out_msg = RPwriteV(iodev, 'data_outL', stim_lr(1, :));
out_msg = RPwriteV(iodev, 'data_outR', stim_lr(2, :));

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
% Get the data from the buffers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get the current location in the buffer
index(1) = RPgettag(iodev, 'index_inL');
index(2) = RPgettag(iodev, 'index_inR');

%reads from the buffer
% resp{1} = double(invoke(iodev.C, 'ReadTagV', 'data_inL', 0, inpts));
% resp{2} = double(invoke(iodev.C, 'ReadTagV', 'data_inR', 0, inpts));
resp{1} = RPreadV(iodev, 'data_inL', inpts);
resp{2} = RPreadV(iodev, 'data_inR', inpts);

if iodev.REF
	index(3) = RPgettag(iodev, 'index_inREF');
	resp{3} = RPreadV(iodev, 'data_inREF', inpts);
end


