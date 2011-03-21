%------------------------------------------------------------------------
% RX8_ArrayPulseStim.m
%------------------------------------------------------------------------
%
% Demonstrates the reverse correlation output technique 
% using 24 channels
%
%
%------------------------------------------------------------------------


%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 20 Feb 2010 (SJS):
%
% Revisions:
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear old vars, close plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set some defaults and constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MAX_OUTPTS = 500000;
MAX_INPTS  = 150000;
ylimits = [-0.5 0.5];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% experiment settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
%%%%%%%%%%%%%%%%%%%%%%%%%
% STIMULUS					%
%%%%%%%%%%%%%%%%%%%%%%%%%

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% overall stimulus parameters
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% # of output speakers
	nSpeakers = 24;
	% output duration (milliseconds)
	Dur_ms = 20*1000;
	% Min, max inter stimulus interval (milliseconds)
	MinISI_ms = 500;
	MaxISI_ms = 2000;
	% Min, max stimulus level (dB SPL)
	MinLevel_dB = 40;
	MaxLevel_dB = 55;
	
	% # of isi and scale values to generate (just needs to be long enough
	% such that max(cumsum(ISI)) > Dur_ms)
	nISIVal = 1000;
	nScaleVal = 1000;
	
	% Random number seed.  set to [] (empty) if new pattern desired with
	% each run of the program
	Seed = 10;

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% PULSE parameters
	%-----------------------------------
	% these are the parameters for the individual stimulus pulses played out
	% of each channel.  The properties are set across all channels.  the
	% stimulus is loaded once into its respective channel buffer 
	% and will be used for all stimulus outputs from that channel
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% duration of stimulus (msec)
	pulse.duration = 20;
	% stimulus low freq. limit (Hz)
	pulse.low = 500;
	% stimulus high freq. limit (Hz)
	pulse.high = 10000;
	% stimulus ramp on/off time
	pulse.rampms = 5;
	% calibration data for channels
	pulse.caldata = cell(nSpeakers, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%
% TDT							%
%%%%%%%%%%%%%%%%%%%%%%%%%
	outdev.Circuit_Path = 'H:\Code\TytoLogy\working\RevRF\ISItest';
	outdev.Circuit_Name = 'RX8_ArrayPulseStim';
	outdev.Dnum = 1;
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load speaker array  information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load speaker location information structure
load speakermap;
% # of output D/A channels (usu. 24)
DAchannels = 24;

% matrix to hold the GS3 channels to use for desired speakers
GS3matrix = zeros(1, DAchannels);
AZmatrix = GS3matrix;
ELmatrix = GS3matrix;
DACHANmatrix = GS3matrix;
indices = GS3matrix;

% speakers to use for sound... should be 24 of 'em
IDmatrix = [44:48 55:59 71:75 87:91 98 99 100 102];
SpkrMatrixCount = length(IDmatrix);

% loop through the 24 D-A channels
for id = 1:SpkrMatrixCount
	% find the index for the current speaker
	indices(id) = find(speakermap.id == IDmatrix(id));
end

AZmatrix(1:SpkrMatrixCount) = speakermap.az(indices);
ELmatrix(1:SpkrMatrixCount) = speakermap.el(indices);
DACHANmatrix(1:SpkrMatrixCount) = speakermap.dachan(indices);
GS3matrix(1:SpkrMatrixCount) = speakermap.gs3chan(indices);
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setup the multiplexer (GS3 unit)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% open the multiplexer
serobj = gs3_open('COM6');
pause(1);
gs3packet_timeref = clock;
% write the GS3 info (switch all speakers in bank)
status = gs3_multipacket(serobj, GS3matrix);
gs3packet_time = etime(clock, gs3packet_timeref);
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize the TDT hardware
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('...starting TDT hardware...');

% Initialize zBus control
zBUS.C = [];
zBUS.status = 0;
tmpdev = zBUSinit('GB');
zBUS.C = tmpdev.C;
zBUS.handle = tmpdev.handle;
zBUS.status = tmpdev.status;
%Set zBUS trigger A to LO 
zBUStrigA(zBUS, 0, 0, 6);

% Initialize RX8 device 1
outdev.C = [];
outdev.status = 0;
tmpdev = RX8init('GB', outdev.Dnum);
outdev.C = tmpdev.C;
outdev.handle = tmpdev.handle;
outdev.status = tmpdev.status;
% Loads circuit
outdev.rploadstatus = RPload(outdev);
% Starts Circuit
outdev.status = RPrun(outdev);
% Get sample rate from the circuit and set up the time vector and stimulus
outdev.Fs = RPsamplefreq(outdev);
% get the tags and values for the circuit
[tags, tagvals] = RPtagnames(outdev);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load the speaker calibration data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
caldatapath = 'C:\Users\TytoLogy\main\Calibration\CalibrationData';
caldatafile = 'netcal-09-Jun-2009.mat';
load([caldatapath filesep caldatafile]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get the calibration data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for c = 1:SpkrMatrixCount
	pulse.caldata{c} = netcal{IDmatrix(c)};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% synthesize stimulus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Synthesizing stimulus matrix...')
S = cell(1, nSpeakers);
for c = 1:nSpeakers
	S{c} = synmononoise_fft(pulse.duration, outdev.Fs, pulse.low, pulse.high, 1, pulse.caldata{c});
	S{c} = sin2array(S{c}, pulse.rampms, outdev.Fs);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get ISI values and load to circuit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Building ISI matrix...')
ISI = syn_mcUniformISI(nSpeakers, nISIVal, ms2bin(MinISI_ms, outdev.Fs) ,...
								ms2bin(MaxISI_ms, outdev.Fs), Seed);
% Get the absolute stimulus times by taking the cumulative sum
% across the columns of the ISI matrix
PulseTimes = cumsum(ISI, 2);
disp('Loading Pulse Times...')
for c = 1:nSpeakers
	tagName = sprintf('PTime%d', c);
	RPwriteV(outdev, tagName, PulseTimes(c, :), 0);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get Scale values and load to circuit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Building Scale matrix...')
% convert min, max levels from dB SPL to Pascal
MinLevel_Pa = dbspl2pa(MinLevel_dB);
MaxLevel_Pa = dbspl2pa(MaxLevel_dB);
PAvals = syn_mcUniformPa(nSpeakers, nScaleVal, MinLevel_Pa, MaxLevel_Pa, Seed);
Scale = zeros(size(PAvals));
disp('...Loading Pulse Scale factors...')
for c = 1:nSpeakers
	caldata = netcal{IDmatrix(c)};
	for n = 1:length(Scale)
		Scale(c, n) = get_scale(PAvals(c, n), caldata.v_rms, caldata.pa_rms);
	end
	tagName = sprintf('PScale%d', c);
	RPwriteV(outdev, tagName, Scale(c, :), 0);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load stimuli and check memory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Loading Stimuli...')
% set the output buffer sizes to be the length of the stimulus pulse
RPsettag(outdev, 'PulsePoints', length(S{1}));
% load buffers
for c = 1:nSpeakers
	tagName = sprintf('Pulse%d', c);
	RPwriteV(outdev, tagName, S{c}, 0);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run the sounds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Dur_pts = ms2samples(Dur_ms, outdev.Fs);

disp('Ready to present stimuli.')
disp('Press key to start...')
pause

zBUStrigA(zBUS, 0, 1, 6);

disp(sprintf('running for %d ms (%d samples)', Dur_ms, Dur_pts))
while RPgettag(outdev, 'stimClock') < Dur_pts
end
 
disp('sending STOP trigger')
zBUStrigA(zBUS, 0, 0, 6);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exit gracefully... usually...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clean up the RP circuits
cleanup
