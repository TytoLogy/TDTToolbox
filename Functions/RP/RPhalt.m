function status = RPhalt(RP)
% function status = RPhalt(RP)
% 
% Halts the circuit on active device RP
% 
% Input Arguments:
% 	RP			TDT toolbox RP control structure
%
% Output Arguments:
% 	status	0 if unsuccessful, 1 if successful
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
% Created: 27 April, 2006
%
% Revisions:
% 		3 September, 2009 (SJS):
% 			-	changed to use RPstruct type for input argument RP that has 
% 				handle for the figure and C element for the control element.
% 				Function is now consistent with other tdt toolbox functions.
% 			-	changed call to eliminate use of invoke function
%------------------------------------------------------------------------



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 1
	error('RPhalt: bad input arguments')
end

% status = invoke(RP.C, 'Halt');
status = RP.C.Halt;