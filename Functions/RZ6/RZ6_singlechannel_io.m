function [resp, index] = RZ6_singlechannel_io(iodev, stim, outchan, inchan, inpts)
%------------------------------------------------------------------------
% [resp, index] = RZ6_singlechannel_io(iodev, stim, outchan, inchan, inpts)
%------------------------------------------------------------------------
% TDT Toolbox
%------------------------------------------------------------------------
% for use with RPVD circuit RZ6_1Out1FilteredIn.rcx
%
%------------------------------------------------------------------------
% Input Arguments:
%	iodev		TDT device structure
% 	stim		[1 X N] array of output data
%	outchan	output channel (1 = left, 2 = right)
%	inchan	input chanel (1, 2)
% 	inpts		# of points to record
% 
% Output Arguments:
%	resp		response vector [1 X inpts]
% 	index		buffer index
%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
% See Also: RZ6calibration_io
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad J. Shanbhag
%	sshanbhag@neomed.edu
%------------------------------------------------------------------------
% Created: 01 March, 2012 (SJS) from RZ6calibration_io.m
%
% Revisions:
%------------------------------------------------------------------------
% To Do:
%------------------------------------------------------------------------

max_outpts = 200000;
max_inpts = 200000;

% check to make sure the length of the output signal is inside limit
outpts = length(stim);
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

% Set the output buffer length
RPsettag(iodev, 'StimDur', outpts);


%%%%% set channel for input and output
% Set the output buffer length
%RPsettag(iodev, 'StimDur', outpts);
%%%%%%%%%%%%%

% Load output buffer
out_msg = RPwriteV(iodev, 'data_out', stim);

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
index = RPgettag(iodev, 'index_in');

%reads from the buffer
resp = RPreadV(iodev, 'data_in', inpts);

