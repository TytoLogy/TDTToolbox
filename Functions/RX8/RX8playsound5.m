function status = RX8playsound5(S, StimDelay, StimInterval, NSweeps, Fs)
% function status = RX8playsound5(S, StimDelay, StimInterval, NSweeps)
%	SOUND(Y,FS) sends the signal in vector Y (with sample frequency
%	FS) out to the speaker on platforms that support sound. Values in
%	Y are assumed to be in the range -1.0 <= y <= 1.0. Values outside
%	that range are clipped.  Stereo sounds are played, on platforms
%	that support it, when Y is an N-by-2 matrix.% 
% 
% Input Arguments:
% 
% Output Arguments:
%
% See also: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%	Created: 5 July, 2006
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First, set some constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MAXBUF = 500000;
MAXVOLTAGE = 5;
START = 1;
STOP = 2;
RESET = 3;
% set this to wherever the examples are stored
Circuit_Path = 'C:\TDT\Toolbox\Circuits\RX8\';
Circuit_Name = 'RX8_1_5ChannelOutput';
Dnum=1; % Dnum = device number - this is for RX8 (1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 5
    help RX8Playsound5
	error('RX8playsound5: Incorrect input arguments')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make sure input args are in bounds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[n, m] = size(S);
if n == 5
    disp('Looks like input array has 5 channels');
    disp('Normal input for RX8playsound5 is N-by-5 array');
else
	S = S';
end

[NChannels, StimPoints] = size(S);
if StimPoints < 1
    error('RX8playsound5:stim_array_error', 'StimPoints < 1');
elseif StimPoints > MAXBUF
    error('RX8playsound5:stim_array_error', 'StimPoints > %d max buffer size', MAXBUF); 
end

if NChannels ~= 5
    error('RX8playsound5:stim_array_error', 'NChannels must be 5');
end

if max(max(S)) > MAXVOLTAGE
    error('RX8playsound5:stim_array_error', 'Maximum level exceeds %d', MAXVOLTAGE);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize RX8 device 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RP = RX8init('GB', Dnum);

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
Fs_test = RPsamplefreq(RP);

if Fs ~= Fs_test
    warning(sprintf('specified Fs (%f) ~= Fs_test (%f)', Fs, Fs_test));
    Fs = Fs_test;
end

% Set the total sweep period time
RPsettag(RP, 'SwPeriod', StimPoints + ms2samples(StimInterval, Fs));
% Set the sweep count (may not be necessary)
RPsettag(RP, 'SwCount', 1);
% Set the Stimulus Delay
RPsettag(RP, 'StimDelay', ms2samples(StimDelay, Fs));
% Set the Stimulus Duration
RPsettag(RP, 'StimDur', StimPoints);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now initiate sweeps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

loop=1;
while loop<=NSweeps
	% send reset command (software trigger 3)
	RPtrig(RP, RESET);

	index_in = RPgettag(RP, 'index_in');
	sweepCount = RPgettag(RP, 'SwpN');

	% generate stimulus 
	% Load output buffer
    for chan = 1:NChannels
        chanIDstr = sprintf('data%d', chan);
    	out_msg = invoke(RP, 'WriteTagV', chanIDstr, 0, S(chan, :));
	end

	sweepCount=double(invoke(RP, 'GetTagVal', 'SwpN'));

	% send the software trigger 1 to start stim presentation 
	% (see circuit for details)
	RPtrig(RP, START);

	% Main Looping Section
	sweep_end = RPgettag(RP, 'SwpEnd');
 	while(sweep_end==0)
 		sweep_end = RPgettag(RP, 'SwpEnd');
	end
	sweepCount = RPgettag(RP, 'SwpN');

	% Stop Playing
	RPtrig(RP, STOP);
	loop = loop+1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close circuit and delete structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
status = RPhalt(RP);
delete(RP);

