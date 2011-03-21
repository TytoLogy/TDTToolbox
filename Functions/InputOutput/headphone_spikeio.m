function [resp, index] = headphone_spikeio(stim_lr, inpts, iodev, varargin)
% [resp, index] = headphone_spikeio(stim_lr, inpts, iodev, varargin)
%
% for use with RPVD circuit RX8_2_BinauralStim_SglResponseFiltered.rpx
% 
% Plays stim_lr array out channels 1 and 2 (or others if set), and records
% inpts from input channel 3 (spikes, etc.) at 50KHz
%
%	NOTE:  performs MINIMAL to NO checks on input variables!!!!
%			Use with caution and attention!
%
% Input Arguments:
% 	stim_lr		[2 X N] stereo output signal (row 1 == left, row2 == right)
% 	inpts			number of points to acquire
% 	iodev			TDT device interface structure for input and output
% 	varargin		for ignored input variables
% 
% Output Arguments:
% 	resp			[1 X inpts] input data vector (or 1Xindex if something
% 					weird happens
% 	index			number of data points read
% 
% See Also: headphonestim_medusarec_1chan
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
% Created: 8 March, 2008 
%
% Revisions:
% 	9 March, 2009 (SJS)
% 		- added documentation
%		- changed input argument order to be consistent with other HPSearch
%			functions
%		- added varargin for compatibility reasons
%		- updated RPtrig calls to conform with new RPstruct format
%		- changed resp return type to vector vs. old cell
%	23 March, 2010 (SJS)
% 		-	updated calls, removed invoke statements
%------------------------------------------------------------------------
% To Do:
%------------------------------------------------------------------------

% send reset command (software trigger 3)
RPtrig(iodev, 3);

outpts = length(stim_lr);

% Set the output buffer length
RPsettag(iodev, 'StimDur', outpts);

% Load output buffer
out_msg = RPwriteV(iodev, 'data_outL', stim_lr(1, :));
out_msg = RPwriteV(iodev, 'data_outR', stim_lr(2, :));

% send the Soft trigger 1 to start
% (see circuit for details)
RPtrig(iodev, 1);

% Main Looping Section
sweep_end = RPfastgettag(iodev, 'SwpEnd');
while(sweep_end==0)
	sweep_end = RPfastgettag(iodev, 'SwpEnd');
end
sweepCount = RPfastgettag(iodev, 'SwpN');

%%%%%%%%%%%%%%%%%%
% Stop Playing
%%%%%%%%%%%%%%%%%%
RPtrig(iodev, 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the data from the buffers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get the current location in the buffer
index = RPgettag(iodev, 'index_in1');

if index < inpts
	inpts = index;
end

%reads from the buffer
resp = RPreadV(iodev, 'data_in1', inpts);

