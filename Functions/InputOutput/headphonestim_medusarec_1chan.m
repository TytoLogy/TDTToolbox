function [resp, index] = headphonestim_medusarec_1chan(stim_lr, inpts, indev, outdev, zdev)
%------------------------------------------------------------------------
% [resp, index] = headphonestim_medusarec_1chan(stim_lr, inpts, indev, outdev, zdev)
%------------------------------------------------------------------------
%
% plays stim_lr out headphones, records input spike data on 
% RX5 (medusa), single channel
%
%	NOTE:  performs MINIMAL to NO checks on input variables!!!!
%			Use with caution and attention!
%
%------------------------------------------------------------------------
% Input Arguments:
% 	stim_lr		[2 X N] stereo output signal (row 1 == left, row2 == right)
% 	inpts			number of points to acquire
% 	indev			TDT device interface structure for input
% 	outdev		TDT device interface structure for output
% 	zdev			TDT device interface structure for zBUS
% 
% Output Arguments:
% 	resp			[1 X inpts] input data vector (or 1Xindex if something
% 					weird happens
% 	index			number of data points read
% 
%------------------------------------------------------------------------
% See Also: headphonecal_io, headphone_spikeio
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 2 March, 2010 (SJS) from headphonestim_medusarec.m January, 2009
%
% Revisions:
%	23 March, 2010 (SJS)
% 		-	updated comments
%------------------------------------------------------------------------

% send reset command (software trigger 3)
RPtrig(outdev, 3);
RPtrig(indev, 3);

% Load output buffer
out_msg = RPwriteV(outdev, 'data_outL', stim_lr(1, :));
out_msg = RPwriteV(outdev, 'data_outR', stim_lr(2, :));

% send the zBustrigA to start acquisition (see circuit for details)
status = zBUStrigA(zdev, 0, 0, 6);

% Main Looping Section
sweep_end = RPfastgettag(outdev, 'SwpEnd');
while(sweep_end == 0)
	sweep_end = RPfastgettag(outdev, 'SwpEnd');
end
sweepCount = RPfastgettag(outdev, 'SwpN');

% Stop Playing and Recording
zBUStrigB(zdev, 0, 0, 6);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the data from the buffers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get the data from the buffer
% get the current location in the buffer
index = RPfastgettag(indev, 'mcIndex');

if index < inpts
	inpts = index;
end

%reads from the buffer
resp = RPreadV(indev, 'mcData', inpts);
