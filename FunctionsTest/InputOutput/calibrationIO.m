function [resp, index] = calibrationIO(outdev, indev, zdev, stim, read_points)
%function [resp, index] = calibrationIO(outdev, indev, zdev, stim, read_points)
%
%
%

% send reset command (software trigger 3)
RPtrig(outdev.RP, 3);
RPtrig(indev.RP, 3);

index_in = RPgettag(indev.RP, 'index_in');
sweepCount = RPgettag(outdev.RP, 'SwpN');

% generate stimulus 
% Load output buffer
out_msg = invoke(outdev.RP, 'WriteTagV', 'data', 0, stim);
index_in=double(invoke(indev.RP, 'GetTagVal', 'index_in'));
sweepCount=double(invoke(outdev.RP, 'GetTagVal', 'SwpN'));

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
resp = double(invoke(indev.RP, 'ReadTagV', 'data_in', 0, read_points));
	
