%RX8_DualInputOutputChannel.m 
%
% This program plays a sound simultaneouly from a channel on RX8 1
% and records on RX8-2.
%
%   Sharad Shanbhag
%   sshanbha@aecom.yu.edu

clear all
close all

% set this to wherever the examples are stored
outdev.Circuit_Path = 'H:\Code\TDT\Toolbox\Circuits\RX8\';
outdev.Circuit_Name = 'RX8_1_SingleChannelOutput';
indev.Circuit_Path = 'H:\Code\TDT\Toolbox\Circuits\RX8\';
indev.Circuit_Name = 'RX8_2_SingleChannelInput';

% Dnum = device number - this is for RX8 (1)
outdev.Dnum=1;
% Dnum = device number - this is for RX8 (2)
indev.Dnum=2;

% set the stimulus/acquisition settings
StimInterval = 500;
NSweeps = 15;
SweepDuration = 500;
StimDelay = 100;
StimDuration = 300;
AcqDuration = SweepDuration;
SweepPeriod = SweepDuration + StimInterval;
OutputLevel = 2.0;
outdev.channel = 3;
indev.channel = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize zBus control - this is so we can 
% synchronize everything by sending triggers to all 
% units via zBusTrigA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zBUS=actxcontrol('ZBUS.x',[1 1 1 1]) 
invoke(zBUS, 'connectZBUS','GB')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize RX8 device 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
outdev.RP = RX8init('GB', outdev.Dnum);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize RX8 device 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
indev.RP = RX8init('GB', indev.Dnum);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loads circuit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
outdev.rploadstatus = RPload(outdev.RP, outdev.Circuit_Path, outdev.Circuit_Name);
indev.rploadstatus = RPload(indev.RP, indev.Circuit_Path, indev.Circuit_Name);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Starts Circuit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
invoke(outdev.RP,'Run')
invoke(indev.RP,'Run')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check Status
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Status1 = RPcheckstatus(outdev.RP);
Status2 = RPcheckstatus(indev.RP);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check cycle use
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CycleUse = RPcycles(outdev.RP);
CycleUse = RPcycles(indev.RP);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Query the sample rate from the circuit and set up the time vector and 
% stimulus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
outdev.Fs = RPsamplefreq(outdev.RP);
indev.Fs = RPsamplefreq(indev.RP);
npts=150000;  % size of the Serial buffer
bufpts = ms2samples(StimDuration, outdev.Fs); %number of points to write to buffer

% Generate tone signal to play out in MATLAB
freq=1000;
t=(1:bufpts)/outdev.Fs;
%s = zeros(1, npts);
s=OutputLevel .* sin2array(sin(2*pi*t*freq), 1, outdev.Fs);

mclock=RPgettag(indev.RP, 'mClock')

% Set the total sweep period time
RPsettag(outdev.RP, 'SwPeriod', ms2samples(SweepPeriod, outdev.Fs));
RPsettag(indev.RP, 'SwPeriod', ms2samples(SweepPeriod, indev.Fs));
% Set the sweep count (may not be necessary)
RPsettag(outdev.RP, 'SwCount', 1);
RPsettag(indev.RP, 'SwCount', 1);
% Set the Stimulus Delay
RPsettag(outdev.RP, 'StimDelay', ms2samples(StimDelay, outdev.Fs));
% Set the Stimulus Duration
RPsettag(outdev.RP, 'StimDur', ms2samples(StimDuration, outdev.Fs));
% Set the length of time to acquire data
RPsettag(indev.RP, 'AcqDur', ms2samples(AcqDuration, indev.Fs));

% Set the input and output channels
RPsettag(outdev.RP, 'OutputChannel', outdev.channel);
RPsettag(indev.RP, 'InputChannel', indev.channel);

RPgettag(outdev.RP, 'oOutputChannel')
RPgettag(indev.RP, 'oInputChannel')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now initiate sweeps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% wait for user to start the acquisition
disp('Press key to start cycle');
pause;

index_in = zeros(NSweeps, 1);

loop=1;
while loop<=NSweeps
	% send reset command (software trigger 3)
	RPtrig(outdev.RP, 3);
	RPtrig(indev.RP, 3);

	index_in = RPgettag(indev.RP, 'index_in');
	sweepCount = RPgettag(outdev.RP, 'SwpN');

	% generate stimulus 
	% Load output buffer
    out_msg = invoke(outdev.RP, 'WriteTagV', 'data', 0, s);

    index_in(loop)=double(invoke(indev.RP, 'GetTagVal', 'index_in'));

	sweepCount=double(invoke(outdev.RP, 'GetTagVal', 'SwpN'));

	% send the zBustrigA to start acquisition 
	% (see circuit for details)
	invoke(zBUS,'zBusTrigA',0,0,3);

	% Main Looping Section
	sweep_end = RPgettag(outdev.RP, 'SwpEnd');
 	while(sweep_end==0)
 		sweep_end = RPgettag(outdev.RP, 'SwpEnd');
	end
	sweepCount = RPgettag(outdev.RP, 'SwpN');

	%%%%%%%%%%%%%%%%%%
	% Stop Playing
	%%%%%%%%%%%%%%%%%%
	invoke(zBUS,'zBusTrigB',0,0,3);
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Get the data from the buffer
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	% get the current location in the buffer
	index_in = RPgettag(indev.RP, 'index_in')
	%reads from the buffer
	resp{loop} = double(invoke(indev.RP, 'ReadTagV', 'data_in', 0, ms2samples(AcqDuration, indev.Fs)));
	plot(resp{loop})
	loop = loop+1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Clean up the RP circuits
%%%%%%%%%%%%%%%%%%%%%%%%%%%
status = RPhalt(indev.RP)
status = RPhalt(outdev.RP)

t = 1000 * [0:length(resp{1})-1] ./ indev.Fs;
for i = 1:NSweeps
	y(i, :) = resp{i};
end
figure
plot(t, y)