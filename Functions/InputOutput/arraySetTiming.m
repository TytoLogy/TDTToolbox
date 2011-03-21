function status = arraySetTiming(outdev, indev, SweepPeriod, StimDelay, StimDuration, AcqDuration)
%------------------------------------------------------------------------
%status = arraySetTiming(outdev, indev, SweepPeriod, StimDelay, StimDuration, AcqDuration)
%------------------------------------------------------------------------
% Tytology TDT Toolbox
%------------------------------------------------------------------------
% sets timing for array output and input circuits
%
% Compatible with following circuits:
%	outdev.Circuit_Name = 'RX8_Array_SingleChannelOutput';
%	indev.Circuit_Name = 'RX8_2_SingleChannelInput_HPFilt';	
%	indev.Circuit_Name = 'RX8_2_SingleChannelInput';
%------------------------------------------------------------------------
% Input Arguments:
% 	outdev			output TDT device structure
% 	indev				input TDT device structure
% 	SweepPeriod		total length of sweep (milliseconds)
% 	StimDelay		stimulus delay time (milliseconds)
% 	StimDuration	duration of stimulus (milliseconds)
% 	AcqDuration		total data acquisition time (milliseconds)
% 	
% Output Arguments:
%	status
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 4 June, 2009
%
% Revisions:
%	18 March, 2010 (SJS): updated comments and documentation
%------------------------------------------------------------------------
% To Do:
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some checks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if nargin ~= 6
		error([mfilename ': incorrect inputs'])
	end
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set the timing variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Set the total sweep period time
	RPsettag(outdev, 'SwPeriod', ms2samples(SweepPeriod, outdev.Fs));
	RPsettag(indev, 'SwPeriod', ms2samples(SweepPeriod, indev.Fs));
	
	% Set the Stimulus Delay
	RPsettag(outdev, 'StimDelay', ms2samples(StimDelay, outdev.Fs));
	
	% Set the Stimulus Duration
	RPsettag(outdev, 'StimDur', ms2samples(StimDuration, outdev.Fs));
	
	% Set the length of time to acquire data
	RPsettag(indev, 'AcqDur', ms2samples(AcqDuration, indev.Fs));

	status(1) = RPcheckstatus(outdev);
	status(2) = RPcheckstatus(indev);
	