function [resp, index] = RZ6calibration_io(iodev, stim_lr, inpts)
%------------------------------------------------------------------------
% [resp, index] = RZ6calibration_io(iodev, stim_lr, inpts)
%------------------------------------------------------------------------
% TDT Toolbox
%------------------------------------------------------------------------
% for use with RPVD circuit RZ6_RefStimResponseFiltered
%
%------------------------------------------------------------------------
% Input Arguments:
%	iodev		TDT device structure
% 	stim_lr	[2XN] array of left, right channel output data
% 	inpts		# of points to record
% 
% Output Arguments:
%	resp		{1X2} cell array, L = 1, R = 2
% 	index		buffer index
%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
% See Also: headphonestim_medusarec
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad J. Shanbhag
%	sshanbhag@neomed.edu
%------------------------------------------------------------------------
% Created: 22 March, 2011 (SJS) from RX6D1calibration_io.m
%
% Revisions:
%	27 Apr 2016 (SJS): Optogen mods
%------------------------------------------------------------------------
% To Do:
%------------------------------------------------------------------------

max_outpts = 200000;
max_inpts = 200000;

% check to make sure the length of the output signal is inside limit
outpts = length(stim_lr);
if ~between(outpts, 1, max_outpts)
	warning('%s: length of stim out of range!', mfilename)
	resp = 0;
	index = 0;
	return
end
if ~between(inpts, 0, max_inpts) 
	warning('%s: inpts out of range', mfilename)
	inpts = outpts;
end

% send reset command (software trigger 3)
RPtrig(iodev, 3);

% set the sweep period to the desired # of input points
RPsettag(iodev, 'SwPeriod', inpts);
% set the sweep count to 1
RPsettag(iodev, 'SwCount', 1);
% set the input buffer points
RPsettag(iodev, 'SwPeriod', inpts);
% Set the output buffer length
RPsettag(iodev, 'StimDur', outpts);
% set delay to zero
RPsettag(iodev, 'StimDelay', 0);

% Load output buffer
RPwriteV(iodev, 'data_outL', stim_lr(1, :));
RPwriteV(iodev, 'data_outR', stim_lr(2, :));

% send the Soft trigger 1 to start
% (see circuit for details)
RPtrig(iodev, 1);

% Main Looping Section
sweep_end = RPgettag(iodev, 'SwpEnd');
while(sweep_end==0)
	sweep_end = RPgettag(iodev, 'SwpEnd');
end
% Not needed:
% sweepCount = RPgettag(iodev, 'SwpN');

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
resp{1} = RPreadV(iodev, 'data_inL', inpts);
resp{2} = RPreadV(iodev, 'data_inR', inpts);

