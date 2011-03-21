function status = RPfastsettag(RPstruct, tagname, tagval)
%------------------------------------------------------------------------
% status = RPfastsettag(RPstruct, tagname, tagval)
%------------------------------------------------------------------------
% TDT toolbox
%--------------------------------------------------------------------------
% Sets value of tagname to tagval on device RPstruct
% 
% Unlike RPsettag, no checking of tags is done to ensure that the tag
%	tagname actually exists on the circuit defined in RPstruct!
%
%------------------------------------------------------------------------
% Input Arguments:
%	RPstruct				RP structure (from R?init function; e.g. RX8init)
%		RPstruct.C			activeX control handle
%		RPstruct.handle	figure handle
% 	tagname	tag name from RP circuit
% 	tagval	tag value from RP circuit
% 
% Output Arguments:
% 	status	
%
%------------------------------------------------------------------------
% See also: RPfastgettag, RPsettag, RPgettag, RPhalt
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 22 February, 2010 from RPsettag.m (SJS)
%
% Revisions:
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
status = RPstruct.C.SetTagVal(tagname, single(tagval));


