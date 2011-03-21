function status = RPsettag(RPstruct, tagname, tagval)
% status = RPsettag(RPstruct, tagname, tagval)
% 
% Sets value of tagname to tagval on device RPstruct
% 
% Input Arguments:
% 	RPstruct			activeX control handle
% 	tagname	tag name from RP circuit
% 	tagval	tag value from RP circuit
% 
% Output Arguments:
% 	status	
%
% See also: RPgettag, RPhalt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
% Created: 27 April, 2006
%
% Revisions:
% 		5 August, 2008:	(SJS)	
% 			- changed to RPstruct input type that has handle for the figure
% 			  and C element for the control element; now consistent with
% 			  other tdt init functions and compatible with RPclose() function
%
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input argument 2 ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 3
	error('RPsettag: bad arguments')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the tag value 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rpname = inputname(1)

if exist([rpname '.mat'], 'file')
	tmpstruct = load(rpname);
	tmpstruct = setfield(tmpstruct, tagname, tagval);
	save(rpname, '-struct', 'tmpstruct');
	status = 1;
else
	status = 0;
end



