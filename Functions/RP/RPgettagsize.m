function tagsize = RPgettagsize(RPstruct, tagname)
%------------------------------------------------------------------------
% tagsize = RPgettagsize(RPstruct, tagname)
%------------------------------------------------------------------------
% TDT toolbox
%--------------------------------------------------------------------------
% gets the maximum # of data points accessible through parameter tagname
% 
%------------------------------------------------------------------------
% Input Arguments:
%	RPstruct				RP structure (from R?init function; e.g. RX8init)
%		RPstruct.C			activeX control handle
%		RPstruct.handle	figure handle
% 	tagname	tag name from RP circuit
% 
% Output Arguments:
%		tagsize		# of datapoints accessible
% 	
%------------------------------------------------------------------------
% See also: RPgettag, RPgettagtype
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 15 Feb 2010 (SJS) from RPgettag.m
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input argument 2 ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 2
	error('%s: bad arguments', mfilename);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read the data type for the given circuit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tagsize = RPstruct.C.GetTagSize(tagname);





