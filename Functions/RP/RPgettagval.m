function value = RPgettagval(RPstruct, tagname)
%------------------------------------------------------------------------
% value = RPgettagval(RPstruct, tagname)
%------------------------------------------------------------------------
% TDT toolbox
%--------------------------------------------------------------------------
% Same as RPgettag, simply a pass-through
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
% See also: RPgettag
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 15 Feb 2010 (SJS) from RPgettag.m
%------------------------------------------------------------------------

value = RPgettag(RPstruct, tagname);


