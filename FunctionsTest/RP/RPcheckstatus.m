function status = RPcheckstatus(RP)
% function RP = RPcheckstatus(RP)
% 
% Checks status of device RP
% 
% Input Arguments:
% 	RP			activeX control handle
% 
% Output Arguments:
% 	status	0 if unsuccessful, 1 if successful
%
% See also: RPload, RPhalt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%	Created: 27 April, 2006
%
% Revisions:
% 		4 September, 2008:	(SJS)
% 			- created test functions
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input argument i ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 1
	error('RPcheckstatus: bad argument')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Check Status
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% status=invoke(RP,'GetStatus');
% 
% %checks for errors in starting circuit
% if bitget(status,1)==0;
%    error('Error connecting to device')
% %checks for connection
% elseif bitget(status,2)==0;
%    error('Error loading circuit')
% elseif bitget(status,3)==0
%    error('error running circuit')
% else  
%    disp('Circuit loaded and running')
% end
rpname = inputname(1);
if exist([rpname '.mat'], 'file')
	status = 1;
else
	status = 0;
end
