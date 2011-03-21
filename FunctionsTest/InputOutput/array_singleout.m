function status = array_singleout(outdev, zdev, stim, outchan)
% status = array_singleout(outdev, zdev, stim, outchan)
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

MAX_OUTPTS=150000;

% check to make sure the length of the output signal is inside limit
outpts = length(stim);
if outpts <= 0
	warning('length of stim <= 0!')
	resp = [];
	index = [];
	return
end
if outpts > MAX_OUTPTS
	warning('stim length > 150000 pts')
	warning('truncating output stimulus')
	outpts = MAX_OUTPTS;
	stim = stim(1:outpts);
end

% send reset command (software trigger 3)
RPtrig(outdev, 3);

% Set the output D/A channel on RX8_1
RPsettag(outdev, 'OutputChannel', outchan);

% Set the output buffer length
RPsettag(outdev, 'StimDur', outpts);

sweepCount = RPgettag(outdev, 'SwpN');

% Load output buffer
out_msg = invoke(outdev.C, 'WriteTagV', 'data', 0, stim);
sweepCount=double(invoke(outdev.C, 'GetTagVal', 'SwpN'));

% send the zBustrigA to start output
status = zBUStrigA(zdev, 0, 0, 6);

% Main Looping Section
sweep_end = RPgettag(outdev, 'SwpEnd');
while(sweep_end==0)
	sweep_end = RPgettag(outdev, 'SwpEnd');
end
sweepCount = RPgettag(outdev, 'SwpN');

% send the zBustrigB to stop
status = zBUStrigB(zdev, 0, 0, 6);

status = sweepCount;
