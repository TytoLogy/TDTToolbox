function Fs = RPsamplefreq(RP)
% function Fs = RPsamplefreq(RP)
% 
% Checks sample rate of device RP
% 
% Input Arguments:
% 	RP			activeX control handle
% 
% Output Arguments:
% 	Fs	0 if unsuccessful, sample rate
%
% See also: RPload, RPhalt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%	Created: 27 April, 2006
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input argument i ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 1
	error('RPsamplefreq: bad argument')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Check Fs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fs = 50000;
