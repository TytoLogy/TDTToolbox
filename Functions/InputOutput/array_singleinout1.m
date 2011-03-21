function [resp, index] = array_singleinout1(indev, outdev, zdev, stim, inchan, outchan, inpts)
%function status = array_singleinout(outdev, zdev, stim, outchan)
%
%
%
max_outpts=150000;
max_inpts = 150000;

% check to make sure the length of the output signal is inside limit
outpts = length(stim);
% if outpts <= 0
% 	warning('length of stim <= 0!')
% 	resp = [];
% 	index = [];
% 	return
% elseif outpts > max_outpts
% 	warning('stim length > 150000 pts')
% 	warning('truncating output stimulus')
% 	outpts = max_outpts;
% 	stim = stim(1:outpts);
% end
% if inpts < outpts
% 	warning('inpts < outpts')
% 	inpts = outpts;
% end
% if inpts <= 0 
% 	warning('inpts <= 0')
% 	inpts = outpts;
% end
% if inpts > max_inpts
% 	warning('inpts > 150000')
% 	inpts = max_inpts;
% end

% send reset command (software trigger 3)
RPtrig(outdev.RP, 3);
RPtrig(indev.RP, 3);

% Set the output D/A channel on RX8_1
RPsettag(outdev.RP, 'OutputChannel', outchan);

% Set the output buffer length
RPsettag(outdev.RP, 'StimDur', outpts);

% % Set the input D/A channel on RX8_2
% RPsettag(indev.RP, 'InputChannel', inchan);
% % Set the length of time to acquire data
% RPsettag(indev.RP, 'AcqDur', inpts);

% index_in = RPgettag(indev.RP, 'index_in');
% sweepCount = RPgettag(outdev.RP, 'SwpN');

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

