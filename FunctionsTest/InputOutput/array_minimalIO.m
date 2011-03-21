function [resp, index] = array_minimalIO(indev, outdev, zdev, stim, outchan, inpts)
% status = array_minimalIO(outdev, zdev, stim, outchan)
%	NOTE:  performs MINIMAL to NO checks on input variables!!!!
%			Use with caution and attention!
% 
% plays stimulus stim through output channel outchan on device outdev
% 
% Input Arguments:
% 
% Output Arguments:
%
% See also: RPload, RPhalt, zBUSinit, RX5init, PA5init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
% Created: 27 April, 2006
%
% Revisions:
% 		13 August, 2008:	(SJS)	
% 			- now consistent with other tdt init functions that use RPstruct
%			  convention
%------------------------------------------------------------------------



% Set the output D/A channel on RX8_1
RPsettag(outdev, 'OutputChannel', outchan);

% Set the output buffer length
RPsettag(outdev, 'StimDur', length(stim));

% input D/A channel on RX8_2 is set outside program

% send reset command (software trigger 3)
RPtrig(outdev, 3);
RPtrig(indev, 3);

% Load output buffer
out_msg = invoke(outdev.C, 'WriteTagV', 'data', 0, stim);

% send the zBustrigA to start acquisition (see circuit for details)
invoke(zdev.C,'zBusTrigA',0,0,3);

% Main Looping Section
sweep_end = RPgettag(outdev, 'SwpEnd');
while(sweep_end==0)
	sweep_end = RPgettag(outdev, 'SwpEnd');
end
sweepCount = RPgettag(outdev, 'SwpN');

% Stop Playing
invoke(zdev.C,'zBusTrigB',0,0,3);

% Get the data from the buffer
% get the current location in the buffer
index = RPgettag(indev, 'index_in');
%reads from the buffer
resp = double(invoke(indev.C, 'ReadTagV', 'data_in', 0, inpts));

