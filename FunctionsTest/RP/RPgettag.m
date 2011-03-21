function value = RPgettag(RPstruct, tagname)
% value = RPgettag(RPstruct, tagname)
% 
% Gets value of tagname on device RP
% 
% Input Arguments:
% 	RPstruct	activeX control handle
% 	tagname	tag name from RP circuit
% 
% Output Arguments:
% 	value of tag	
%
% See also: RPsettag, RPhalt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
% 		4 September, 2008:	(SJS)
% 			- created test functions
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input argument 2 ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 2
	error('RPgettag: bad arguments')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the tag value 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rpname = inputname(1)

if exist([rpname '.mat'], 'file')
	tmpstruct = load(rpname);
	value = getfield(RPstruct, tagname);
else
	warning(['no valid value for ' tagname ' in ' rpname]);
	value = NaN;
end

