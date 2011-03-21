function status = rfrand_singleout(outdev, zdev, stim, outchan)
%function status = rfrand_singleout(outdev, zdev, stim, outchan)
%
%
%

% send reset command (software trigger 3)
RPtrig(outdev.RP, 3);

% Set the output D/A channel on RX8_1
RPsettag(outdev.RP, 'OutputChannel', outchan);


%sweepCount = RPgettag(outdev.RP, 'SwpN');

% Load output buffer
out_msg = invoke(outdev.RP, 'WriteTagV', 'data', 0, stim);
%sweepCount=double(invoke(outdev.RP, 'GetTagVal', 'SwpN'));

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

status = sweepCount;
