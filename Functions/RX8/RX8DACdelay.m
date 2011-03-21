function dacdelay = RX8DACdelay(varargin)
%------------------------------------------------------------------------
% dacdelay = RX8DACdelay(Fs)
%------------------------------------------------------------------------
% 
% Returns digital-to-analog converter delay for RX8 in units of:
% 	# of samples, if Fs is unspecified
% 	milliseconds, if Fs is provided
% 
%------------------------------------------------------------------------
% Input Arguments:
% 	Fs				sampling rate (samples/second) to use for conversion of 
%					DAC delay to milliseconds
% 
% Output Arguments:
%	dacdelay		digital-to-analog conversion delay for the RX8 in units of
% 					samples (on the RX8) if Fs is not given, or milliseconds
% 					if Fs is provided
%------------------------------------------------------------------------
% See also: RX8init, RX8ADCdelay
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 9 March, 2010 (SJS)
%
% Revisions:
%------------------------------------------------------------------------

% value of delay in samples
RX8_DACDELAY = 47;

dacdelay = [];

if nargin
	if ~isnumeric(varargin{1})
		error('%s: Fs must be a number', mfilename)
	elseif varargin{1} <= 0
		error('%s: Fs must be a greater than 0', mfilename)
	else
		dacdelay = bin2ms(RX8_DACDELAY, varargin{1});
	end
else
	dacdelay = RX8_DACDELAY;
end
