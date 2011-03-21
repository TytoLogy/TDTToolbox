function status = RPcheckstatus(RP)
% function RP = RPcheckstatus(RP)
% 
% Checks status of device RP
% 
% Input Arguments:
% 	RP			RP structure (from R?init function; e.g. RX8init)
%		RP.C			activeX control handle
%		RP.handle	figure handle
% 
% Output Arguments:
% 	status	0 if unsuccessful, 1 if successful
%
% See also: RPload, RPhalt, RX8init, RX5init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------
% Sharad Shanbhag
% sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
% Created: 27 April, 2006
%
% Revisions:
% 		19 January, 2009:	(SJS)	
%			-	changed to RPstruct RP input type that has handle for the 
% 				figure and C element for the control element. Consistent with
% 				other tdt init functions and compatible with RPclose() function
% 		3 September, 2009 (SJS):
% 			-	changed calls to eliminate use of invoke function
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input argument i ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if nargin ~= 1
		error([mfilename ': bad argument'])
	elseif ~isstruct(RP)
		error([mfilename ': RP is not a struct'])	
	elseif ~isfield(RP, 'C')
		error([mfilename ': RP is not a valid struct'])	
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Check Status
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	status = RP.C.GetStatus;

	%checks for errors in starting circuit
	if bitget(status,1)==0;
		error('Error connecting to device')
	%checks for connection
	elseif bitget(status,2)==0;
		error('Error loading circuit')
	elseif bitget(status,3)==0
		error('error running circuit')
	else  
		disp('Circuit loaded and running')
	end
