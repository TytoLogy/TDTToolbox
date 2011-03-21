function status = RPhalt(RP)
% function status = RPhalt(RP)
% 
% Halts the circuit on active device RP
% 
% Input Arguments:
% 	RP			activeX control handle
%
% Output Arguments:
% 	status	0 if unsuccessful, 1 if successful
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------
% Sharad Shanbhag
% sshanbha@aecom.yu.edu
% 
% Created: 27 April, 2006
% Revisions:
% 		4 September, 2008:	(SJS)
% 			- created test functions
% 
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 1
	error('RPhalt: bad input arguments')
end

% status = invoke(RP, 'Halt');