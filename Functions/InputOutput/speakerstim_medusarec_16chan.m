function [resp, mcIndex] = speakerstim_medusarec_16chan(stim_lr, inpts, indev, outdev, zdev)
%------------------------------------------------------------------------
% [resp, index] = speakerstim_medusarec_16chan(stim, inpts, zdev, indev, outdev)
%------------------------------------------------------------------------
%
% plays stim out speaker, records input spike data on 
% RX5 (medusa)
%
%	NOTE:  performs MINIMAL to NO checks on input variables!!!!
%			Use with caution and attention!
%
%------------------------------------------------------------------------
% Input Arguments:
% 	stim			2 X N stimulus vector
% 	inpts			# of points to read in
% 	indev			input device TDT struct
% 	outdev		output device TDT struct
% 	zdev			zbus TDT device struct
% 	
% Output Arguments:
%	resp			[16 X inpts] array of data
%	mcIndex		# of points read in
%------------------------------------------------------------------------
% See Also: headphonecal_io
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sshanbhag@neomed.edu
%------------------------------------------------------------------------
% Created: 01 March, 2012 from headphonestim_medusarec
%
% Revisions:
%------------------------------------------------------------------------
% To Do:
%------------------------------------------------------------------------

% send reset command (software trigger 3)
RPtrig(outdev, 3);
RPtrig(indev, 3);

% Set the output buffer length
outpts = length(stim);
RPsettag(indev, 'StimDur', outpts);

% Load output buffer
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
