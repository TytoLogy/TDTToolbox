% headphone_io_test

addpath C:\Users\Matlab\Toolbox\TDT\Functions\PA5


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set this to wherever the circuits are stored
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	iodev.Circuit_Path = 'C:\Users\Matlab\Toolbox\TDT\Circuits\RX8_2\50KHz\';
	iodev.Circuit_Name = 'RX8_2_BinauralStimResponseFiltered';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dnum = device number - this is for RX8 (2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	iodev.Dnum=2;
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize the TDT devices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Initialize RX8 device 2
	iodev.RP = RX8init('GB', iodev.Dnum);
	PA5L = PA5init('GB', 1);
	PA5R = PA5init('GB', 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loads circuits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	iodev.rploadstatus = RPload(iodev.RP, iodev.Circuit_Path, iodev.Circuit_Name);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Starts Circuit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	invoke(iodev.RP,'Run');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check Status
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Status1 = RPcheckstatus(iodev.RP);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Query the sample rate from the circuit and set up the time vector and 
% stimulus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	iodev.Fs = RPsamplefreq(iodev.RP);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up some of the buffer/stimulus parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Stimulus Interval (ms)
	StimInterval = 0;
	% Stimulus Duration (ms)
	StimDuration = 150;
	% Duration of epoch (ms)
	SweepDuration = 200;
	% Delay of stimulus (ms)
	StimDelay = 10;
	% Total time to acquire data (ms)
	AcqDuration = SweepDuration;
	% Total sweep time = sweep duration + inter stimulus interval (ms)
	SweepPeriod = SweepDuration + StimInterval;
	% Stimulus ramp on/off time
	StimRamp = 5;
	%Input Filter Fc
	InputFilter = 1;
	InputFc = 100;
	%TTL pulse duration (msec)
	TLPulseDur = 1;

	% size of the Serial buffer
	npts=150000;  
	dt = 1/iodev.Fs;
	mclock=RPgettag(iodev.RP, 'mClock');

	% Set the total sweep period time
	RPsettag(iodev.RP, 'SwPeriod', ms2samples(SweepPeriod, iodev.Fs));
	% Set the sweep count (may not be necessary)
	RPsettag(iodev.RP, 'SwCount', 1);
	% Set the Stimulus Delay
	RPsettag(iodev.RP, 'StimDelay', ms2samples(StimDelay, iodev.Fs));
	% Set the Stimulus Duration
	RPsettag(iodev.RP, 'StimDur', ms2samples(StimDuration, iodev.Fs));
	% Set the length of time to acquire data
	RPsettag(iodev.RP, 'AcqDur', ms2samples(AcqDuration, iodev.Fs));

	RPsettag(iodev.RP, 'HPenable', InputFilter);
	RPsettag(iodev.RP, 'HPFreq', InputFc);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Play the sound, record response
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% synthesize the R sine wave;
	[S, RMS, Phi] = syn_calibrationtone(StimDuration, iodev.Fs, 440, 0, 'B');

	% apply the sin^2 amplitude envelope to the stimulus
	S = sin2array(S, StimRamp, iodev.Fs);

	PA5setatten(PA5L, 10);
	PA5setatten(PA5R, 10);

	% play the sound;
	[resp, rate] = headphone_io(iodev, S, ms2samples(AcqDuration, iodev.Fs));
