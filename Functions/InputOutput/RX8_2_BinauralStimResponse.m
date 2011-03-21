function [resp, Fs] = RX8B_StimResponse(stim, acqduration, out_chan, in_chan)
%function [resp, Fs] = RX8B_StimResponse(stim, acqduration, out_chan, in_chan)
% This program plays a sound and reads the response on RX8(2)
%

%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Global settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dnum = device number - this is for RX8 (2)
Dnum=2;

% Paths and RCO file
Circuit_Path='C:\Users\Matlab\Toolbox\TDT\Circuits\RX8_2\50KHz\';
Circuit_Name = 'RX8_2_StimResponse';

% sampling rate and max output pts.
Fs = RX8B_Fs50;
max_outpts=150000;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check the input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin ~= 4
	warning('RX8B_StimResponse error!')
	disp('bad input arguments')
	resp = [];
	Fs = [];
	return
end

outpts = length(stim);
if outpts <= 0
	warning('RX8B_StimResponse error!')
	disp('length of stim <= 0!')
	resp = [];
	Fs = [];
	return
end
if outpts > max_outpts
	warning('RX8B_StimResponse error!')
	disp('stim length > 150000 pts')
	disp('truncating output stimulus')
	outpts = max_outpts;
	stim = stim(1:outpts);
end

if acqduration <= 0
	warning('RX8B_StimResponse error!')
	disp('Acquisition Time <= 0')
	disp('setting time to length of stimulus')
	inpts = outpts;
else
	inpts = ms2bin(acqduration, Fs);
end

if stim(outpts) ~= 0
	stim(outpts) = 0;
end

if ~between(out_chan, 1, 4)
	warning('RX8B_StimResponse error!')
	disp('out_chan must be between 1 and 4')
	resp = [];
	Fs = [];
	return
end

if ~between(in_chan, 1, 8)
	warning('RX8B_StimResponse error!')
	disp('in_chan must be between 1 and 8')
	resp = [];
	Fs = [];
	return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize RX8 device 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[RP, rpfig] = RX8init('GB', Dnum)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loads circuit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rploadstatus = RPload(RP, Circuit_Path, Circuit_Name);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Starts Circuit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
invoke(RP,'Run');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check Status
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Status = RPcheckstatus(RP);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check cycle use
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CycleUse = RPcycles(RP);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Query the sample rate from the circuit and set up the time vector and 
% stimulus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fs = RPsamplefreq(RP);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set the input-output parameters for the circuit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get the current time
mclock=RPgettag(RP, 'mClock');

% Set the total sweep period time
RPsettag(RP, 'SwPeriod', max([outpts inpts]));
% Set the sweep count (may not be necessary)
RPsettag(RP, 'SwCount', 1);
% Set the length of time to acquire data
RPsettag(RP, 'AcqDur', inpts);
% Set the Stimulus Delay to 0 (assume that delay is handled in the
% stimulus array itself)
RPsettag(RP, 'StimDelay', 0);
% Set the Stimulus Duration
RPsettag(RP, 'StimDur', outpts);
% set the output channel
RPsettag(RP, 'oChannel', out_chan);
%set the input channel
RPsettag(RP, 'iChannel', in_chan);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now play/record stim/response
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% send reset command (software trigger 3)
RPtrig(RP, 3);

% Load output buffer
out_msg = invoke(RP, 'WriteTagV', 'data_out', 0, stim);

index_in = RPgettag(RP, 'index_in');
sweepCount = RPgettag(RP, 'SwpN');

% send the software trigger 1 to start acquisition 
% (see circuit for details)
RPtrig(RP, 1);

% Main Looping Section
sweep_end = RPgettag(RP, 'SwpEnd');
while(sweep_end==0)
	sweep_end = RPgettag(RP, 'SwpEnd');
end	
sweepCount = RPgettag(RP, 'SwpN');

% Stop Playing
RPtrig(RP, 2);

% get the current location in the buffer
index_in = RPgettag(RP, 'index_in');

%reads from the buffer
resp = double(invoke(RP, 'ReadTagV', 'data_in', 0, ms2samples(acqduration, Fs)));


% get the current location in the buffer
i = RPgettag(RP, 'ichan')
o = RPgettag(RP, 'ochan')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exit Gracefully
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
status = RPhalt(RP);
close(rpfig);



