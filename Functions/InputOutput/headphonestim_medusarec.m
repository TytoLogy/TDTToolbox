function [resp, mcIndex] = headphonestim_medusarec(stim_lr, inpts, indev, outdev, zdev)
%------------------------------------------------------------------------
% [resp, index] = headphonestim_medusarec(stim_lr, inpts, zdev, indev, outdev)
%------------------------------------------------------------------------
%
% plays stim_lr out headphones, records input spike data on 
% RX5 (medusa)
%
%	NOTE:  performs MINIMAL to NO checks on input variables!!!!
%			Use with caution and attention!
%
%------------------------------------------------------------------------
% Input Arguments:
% 	
% Output Arguments:
% 
%------------------------------------------------------------------------
% See Also: headphonecal_io
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
% Created: 28 January, 2009
%
% Revisions:
%	5 February, 2009
% 		- added some tic/toc pairs to measure execution times at 
% 			key points in function
% 	8 March, 2009
% 		- removed tics and tocs
% 	9 March, 2009
% 		- added documentation
%		- changed input argument order to be consistent with other HPSearch
%			functions
%	3 September, 2009
%		-	removed invoke calls
% 		-	used newly implemented RPwriteV and RPreadV functions to write
% 			and read vector data to/from buffers
%------------------------------------------------------------------------
% To Do:
%------------------------------------------------------------------------

% send reset command (software trigger 3)
RPtrig(outdev, 3);
RPtrig(indev, 3);

% Set the output buffer length
outpts = length(stim_lr);
RPsettag(indev, 'StimDur', outpts);

% Load output buffer
% out_msg = invoke(outdev.C, 'WriteTagV', 'data_outL', 0, stim_lr(1, :));
% out_msg = invoke(outdev.C, 'WriteTagV', 'data_outR', 0, stim_lr(2, :));
out_msg = RPwriteV(outdev, 'data_outL', stim_lr(1, :));
out_msg = RPwriteV(outdev, 'data_outR', stim_lr(2, :));

% send the zBustrigA to start acquisition (see circuit for details)
status = zBUStrigA(zdev, 0, 0, 6);

% Main Looping Section
sweep_end = RPgettag(outdev, 'SwpEnd');
while(sweep_end == 0)
	sweep_end = RPgettag(outdev, 'SwpEnd');
end
sweepCount = RPgettag(outdev, 'SwpN');

% Stop Playing and Recording
zBUStrigB(zdev, 0, 0, 6);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the data from the buffers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get the data from the buffer
% get the current location in the buffer
mcIndex = RPgettag(indev, 'mcIndex');

if mcIndex < inpts
	inpts = mcIndex;
end

%reads from the buffer
resp = RPreadV(indev, 'mcData', inpts);
