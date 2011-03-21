function status = RPzerotag(RPstruct, tagname)
%------------------------------------------------------------------------
% status = RPzerotag(RPstruct, tagname)
%------------------------------------------------------------------------
% TDT toolbox
%--------------------------------------------------------------------------
% Sets value of tagname on device RPstruct to zero.  If data buffer, 
% clears the buffer (sets all points to zero)
% 
%------------------------------------------------------------------------
% Input Arguments:
%	RPstruct				RP structure (from R?init function; e.g. RX8init)
%		RPstruct.C			activeX control handle
%		RPstruct.handle	figure handle
% 	tagname	tag name from RP circuit
% 
% Output Arguments:
% 	value of tag	
%------------------------------------------------------------------------
% See also: RPsettag, RPgettag
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 10 February, 2010 (SJS)
%
% Revisions:
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input argument 2 ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 2
	error('%s: bad arguments', mfilename)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% zero the tag value 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
status = RPstruct.C.ZeroTag(tagname);

