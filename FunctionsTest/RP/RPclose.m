function RPstatus = RPclose(RPstruct)
% function RPstatus = RPclose(RPstruct)
% 
% Halts the circuit on active device RPstruct.C, closes figure and
% deletes the device
% 
% Input Arguments:
%	RPstruct				RP structure (from R?init function; e.g. RX8init)
% 	RPstruct.C			activeX control handle
%	RPstruct.handle	figure handle
%
% Output Arguments:
% 	RPstatus.status	0 if unsuccessful, 1 if successful
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%	Created: 4 August, 2008
%
% Revisions:
% 		4 September, 2008:	(SJS)
% 			- created test functions
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	if nargin ~= 1
% 		error('RPclose: bad input arguments')
% 	elseif ~isstruct(RPstruct)
% 		error('RPclose: bad input structure')
% 	end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Close the interface
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	RPstatus = invoke(RPstruct.C, 'Halt');	% delete the control
% 	delete(RPstruct.C);
% 
% 	%close the figure
% 	set(RPstruct.handle, 'Visible', 'on');
% 	close(RPstruct.handle);

rpname = inputname(1);

if exist([rpname '.mat'], 'file')
	delete(rpname);
end

RPstatus = 0;
