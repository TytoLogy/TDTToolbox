function [resp, index] = array_1chOut_2chIn(indev, outdev, zdev, stim, outchan, inpts)
%function status = array_minimalIO(outdev, zdev, stim, outchan)
%	NOTE:  performs MINIMAL to NO checks on input variables!!!!
%			Use with caution and attention!
%


% Set the output D/A channel on RX8_1
RPsettag(outdev.RP, 'OutputChannel', outchan);

% Set the output buffer length
RPsettag(outdev.RP, 'StimDur', length(stim));

% input D/A channel on RX8_2 is set outside program

% send reset command (software trigger 3)
RPtrig(outdev.RP, 3);
RPtrig(indev.RP, 3);

% Load output buffer
out_msg = invoke(outdev.RP, 'WriteTagV', 'data', 0, stim);

% send the zBustrigA to start acquisition (see circuit for details)
invoke(zdev,'zBusTrigA',0,0,3);

% Main Looping Section
sweep_end = RPgettag(outdev.RP, 'SwpEnd');
while(sweep_end==0)
	sweep_end = RPgettag(outdev.RP, 'SwpEnd');
end
sweepCount = RPgettag(outdev.RP, 'SwpN');

% Stop Playing
invoke(zdev,'zBusTrigB',0,0,3);

% Get the data from the buffer
% get the current location in the buffer
index = cell(2, 1);
resp = index;
index{1} = RPgettag(indev.RP, 'index_in1');
index{2} = RPgettag(indev.RP, 'index_in2');

%reads from the buffer
resp{1} = double(invoke(indev.RP, 'ReadTagV', 'data_in1', 0, inpts));
resp{2} = double(invoke(indev.RP, 'ReadTagV', 'data_in2', 0, inpts));

% send reset command (software trigger 3)
RPtrig(outdev.RP, 3);
RPtrig(indev.RP, 3);
