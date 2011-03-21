function adcdelay = RX8ADCdelay(varargin)
%------------------------------------------------------------------------
% adcdelay = RX8ADCdelay(Fs)
%------------------------------------------------------------------------
% 
% Returns analog-to-digital converter delay for RX8 in units of:
% 	# of samples, if Fs is unspecified
% 	milliseconds, if Fs is provided
% 
%------------------------------------------------------------------------
% Input Arguments:
% 	Fs				sampling rate (samples/second) to use for conversion of 
%					ADC delay to milliseconds
% 
% Output Arguments:
%	adcdelay		analog-to-digital conversion delay for the RX8 in units of
% 					samples (on the RX8) if Fs is not given, or milliseconds
% 					if Fs is provided
%------------------------------------------------------------------------
% See also: RX8init, RX8DACdelay
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
RX8_ADCDELAY = 47;

adcdelay = [];

if nargin
	if ~isnumeric(varargin{1})
		error('%s: Fs must be a number', mfilename)
	elseif varargin{1} <= 0
		error('%s: Fs must be a greater than 0', mfilename)
	else
		adcdelay = bin2ms(RX8_ADCDELAY, varargin{1});
	end
else
	adcdelay = RX8_ADCDELAY;
end
