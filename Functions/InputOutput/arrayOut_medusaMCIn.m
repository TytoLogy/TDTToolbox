function [resp, mcIndex] = arrayOut_medusaMCIn(indev, outdev, zdev, stim, outchan, inpts, inchan, varargin)
%------------------------------------------------------------------------
% [resp, mcIndex] = arrayOut_medusaMCIn(indev, outdev, zdev, 
%													stim, outchan, inpts, inchan)
%------------------------------------------------------------------------
% TDT Toolbox
%------------------------------------------------------------------------
%	NOTE:  performs MINIMAL to NO checks on input variables!!!!
%			Use with caution and attention!
% 
%------------------------------------------------------------------------
% Input Arguments:
% 	indev		tdt device structure for input
% 	outdev	tdt device structure for output
% 	zdev		zBUS device structure
% 	stim		stimulus vector
% 	outchan	output D/A channel
% 	inpts		# of points to read
%	inchan	# of channels to read
% 
% Output Arguments:
% 	resp		response matrix
% 	mcIndex	index (# of samples
% 
%------------------------------------------------------------------------
% See also: arrayOut_medusaIn
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 23 February from arrayOut_medusaIn
%
% Revisions:
% 	9 October, 2009 (SJS)
% 		- updated documentation
% 		- updated invoke() calls
%	23 February, 2010 (SJS) updated information
%------------------------------------------------------------------------

% Set the output D/A channel on RX8_1
RPsettag(outdev, 'OutputChannel', outchan);

% Set the output buffer length
RPsettag(outdev, 'StimDur', length(stim));

% send reset command (software trigger 3)
RPtrig(outdev, 3);
RPtrig(indev, 3);

% Load output buffer
out_msg = RPwriteV(outdev, 'data', stim, 0);

% send the zBustrigA to start acquisition (see circuit for details)
status = zBUStrigA(zdev, 0, 0, 6);

% Main Looping Section
sweep_end = RPgettag(outdev, 'SwpEnd');
while(sweep_end == 0)
	sweep_end = RPgettag(outdev, 'SwpEnd');
end
sweepCount = RPgettag(outdev, 'SwpN');

% Stop Playing
zBUStrigB(zdev, 0, 0, 6);

% Get the data from the buffer
% get the current location in the buffer
mcIndex = RPgettag(indev, 'mcIndex');



if mcIndex < inpts
	inpts = mcIndex;
end

%reads from the buffer
resp = RPreadVEX(indev, 'mcData', inpts, inchan, 0, 'F32');
resp = resp';
