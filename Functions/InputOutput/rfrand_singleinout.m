function [resp, index] = rfrand_singleinout(indev, outdev, zdev, stim, inchan, outchan, inpts)
%function status = rfrand_singleinout(outdev, zdev, stim, outchan)
%
%
%

outpts = length(stim);

% send reset command (software trigger 3)
RPtrig(outdev.RP, 3);
RPtrig(indev.RP, 3);

% Set the output D/A channel on RX8_1
RPsettag(outdev.RP, 'OutputChannel', outchan);

% Load output buffer
out_msg = invoke(outdev.RP, 'WriteTagV', 'data', 0, stim);

% send the zBustrigA to start acquisition 
% (see circuit for details)
invoke(zdev,'zBusTrigA',0,0,3);

% Main Looping Section
sweep_end = RPgettag(outdev.RP, 'SwpEnd');
while(sweep_end==0)
	sweep_end = RPgettag(outdev.RP, 'SwpEnd');
end
sweepCount = RPgettag(outdev.RP, 'SwpN');

%%%%%%%%%%%%%%%%%%
% Stop Playing
%%%%%%%%%%%%%%%%%%
invoke(zdev,'zBusTrigB',0,0,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the data from the buffer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get the current location in the buffer
index = RPgettag(indev.RP, 'index_in');
%reads from the buffer
resp = double(invoke(indev.RP, 'ReadTagV', 'data_in', 0, inpts));

