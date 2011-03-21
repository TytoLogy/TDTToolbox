function cycles = RPcycles(RP)
% function cycles = RPcycles(RP)
% 
% Checks cycles used by device RP
% 
% Input Arguments:
% 	RP			TDT toolbox RP control structure
% 
% Output Arguments:
% 	cycles	0 if unsuccessful, # cycles used
%
% See also: RPload, RPhalt
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
% Check if input argument i ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 1
	error('RPcycles: bad argument')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Check Fs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cycles = invoke(RP.C, 'GetCycUse');
cycles = RP.C.GetCycUse;
