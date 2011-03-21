function [resp, index] = arraysingleIO(outdev, indev, zdev, stim, outchan, read_points)
%[resp, index] = arraysingleIO(outdev, indev, zdev, stim, outchan, read_points)
%------------------------------------------------------------------------
% TDT Toolbox
%------------------------------------------------------------------------
% plays stim out of FF array speaker, records input data on RX8_2
%
%   Compatible with following circuits:
% 	outdev.Circuit_Name = 'RX8_Array_SingleChannelOutput';
% 	indev.Circuit_Name = 'RX8_2_SingleChannelInput_HPFilt';	
% 	indev.Circuit_Name = 'RX8_2_SingleChannelInput';
%------------------------------------------------------------------------
% Input Arguments:
% 	outdev			TDT I/O structure for output
% 	indev				TDT I/O structure for input
% 	zdev				TDT I/O structure for zBUS
% 	stim				stimulus vector
% 	outchan			output D/A channel
% 	read_points		# of datapoints to read from buffer
% 	
% Output Arguments:
%	resp
% 	index
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: ????
%
% Revisions:
% 	16 April, 2009
% 		- added documentation
%		- updated for use with iodev structure functions
% 	4 June, 2009
% 		- updated documentation
% 	18 March, 2010 (SJS):
% 		- updated documentation
%		- removed "invoke", uses RPreadV now
%------------------------------------------------------------------------
% To Do:
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some checks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	max_outpts=150000;

	outpts = length(stim);
	if outpts <= 0
		warning('length of stim <= 0!')
		resp = [];
		index = [];
		return
	end
	if outpts > max_outpts
		warning('stim length > 150000 pts')
		warning('truncating output stimulus')
		outpts = max_outpts;
		stim = stim(1:outpts);
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% send reset command (software trigger 3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	RPtrig(outdev, 3);
	RPtrig(indev, 3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set the output D/A channel on RX8_1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	RPsettag(outdev, 'OutputChannel', outchan);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set the output buffer length
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	RPsettag(outdev, 'StimDur', outpts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
index_in = RPgettag(indev, 'index_in');
sweepCount = RPgettag(outdev, 'SwpN');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load output buffer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	out_msg = invoke(outdev.C, 'WriteTagV', 'data', 0, stim);
	index_in=double(invoke(indev.C, 'GetTagVal', 'index_in'));
	sweepCount=double(invoke(outdev.C, 'GetTagVal', 'SwpN'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% send the zBustrigA to start acquisition 
% (see circuit for details)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%Set zBUS trigger A to LO 
	zBUStrigA_PULSE(zdev, 0, 6);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Looping Section
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	sweep_end = RPgettag(outdev, 'SwpEnd');
	while(sweep_end==0)
		sweep_end = RPfastgettag(outdev, 'SwpEnd');
	end
	sweepCount = RPgettag(outdev, 'SwpN');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stop Playing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	zBUStrigB_PULSE(zdev, 0, 6);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the data from the buffer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% get the current location in the buffer
	index = RPgettag(indev, 'index_in');
	%reads from the buffer
	resp = RPreadV(indev, 'data_in', read_points);
