function [resp, Fs] = RX8B_ClickResponse(clicklevel, clickdelay, acqduration, out_chan, in_chan)
%function [resp, Fs] = RX8B_ClickResponse(acqduration, out_chan, in_chan)
% This program plays a click and reads the response on RX8(2)
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
Circuit_Name = 'RX8_2_ClickResponse';

% sampling rate and max output pts.
Fs = RX8B_Fs50;
max_outpts=150000;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check the input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin ~= 5
	warning('RX8B_ClickResponse error!')
	disp('bad input arguments')
	resp = [];
	Fs = [];
	return
end

if ~between(clicklevel, 0, 5)
	warning('RX8B_ClickResponse error!')
	disp('click level must be between 0 and 5')
	disp('using default of 1')
	clicklevel = 1;
end

if acqduration <= 0
	warning('RX8B_ClickResponse error!')
	disp('Acquisition Time <= 0')
	disp('setting time to 500 ms default')
	acqduration = 500;
end
inpts = ms2bin(acqduration, Fs); 

if ~between(clickdelay, 0, acqduration)
	warning('RX8B_ClickResponse error!')
	disp('clickdelay is not between 0 and acqduration')
	disp('setting delay to 0 ms default')
	clickdelay = 0;
end

if ~between(out_chan, 1, 4)
	warning('RX8B_ClickResponse error!')
	disp('out_chan must be between 1 and 4')
	resp = [];	Fs = [];
	return
end

if ~between(in_chan, 1, 8)
	warning('RX8B_ClickResponse error!')
	disp('in_chan must be between 1 and 8')
	resp = [];	Fs = [];
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
RPsettag(RP, 'SwPeriod', inpts);
% Set the sweep count (may not be necessary)
RPsettag(RP, 'SwCount', 1);
% Set the length of time to acquire data
RPsettag(RP, 'AcqDur', inpts);
% Set the Stimulus Delay to 0 (assume that delay is handled in the
% stimulus array itself)
RPsettag(RP, 'StimDelay', ms2bin(clickdelay, Fs));
% Set the Stimulus Duration
%RPsettag(RP, 'StimDur', inpts);
% set the output channel
RPsettag(RP, 'oChannel', out_chan);
%set the input channel
RPsettag(RP, 'iChannel', in_chan);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now play/record stim/response
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% send reset command (software trigger 3)
RPtrig(RP, 3);

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exit Gracefully
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
status = RPhalt(RP);
close(rpfig);



