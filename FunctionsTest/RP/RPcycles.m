function cycles = RPcycles(RP)
% function cycles = RPcycles(RP)
% 
% Checks cycles used by device RP
% 
% Input Arguments:
% 	RP			activeX control handle
% 
% Output Arguments:
% 	cycles	0 if unsuccessful, # cycles used
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
	error('RPcycles: bad argument')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Check Fs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cycles = invoke(RP, 'GetCycUse');
cycles = 1;
