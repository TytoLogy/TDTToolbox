function value = RPfastgettag(RPstruct, tagname)
%------------------------------------------------------------------------
% value = RPfastgettag(RPstruct, tagname)
%------------------------------------------------------------------------
% TDT toolbox
%--------------------------------------------------------------------------
% Gets value of tagname on device RP
%
% Unlike RPgettag, RPfastgettag doesn't do any checking to see if the 
% desired tag actually exists on the circuit.  Caveat user!
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
% See also: RPfastsettag, RPgettag, RPsettag, RPhalt
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 22 February, 2010 from RPgettag.m (SJS)
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
% Get the tag value 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
value = RPstruct.C.GetTagVal(tagname);

