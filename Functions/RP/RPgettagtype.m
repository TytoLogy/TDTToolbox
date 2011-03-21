function [tagtype, typeval, typestr] = RPgettagtype(RPstruct, tagname)
%------------------------------------------------------------------------
% [tagtype, typeval] = RPgettagtype(RPstruct, tagname)
%------------------------------------------------------------------------
% TDT toolbox
%--------------------------------------------------------------------------
% gets the data type of a parameter tag
% 
%------------------------------------------------------------------------
% Input Arguments:
%	RPstruct				RP structure (from R?init function; e.g. RX8init)
%		RPstruct.C						activeX control handle
%		RPstruct.Circuit_Path		path to circuits directory (.rco files) (default = 'C:\TDT')
%		RPstruct.Circuit_Name		circuit name (no default)
%		RPstruct.Dnum					device ID number
%		RPstruct.TagNames
% 
% 	tagname	tag name from RP circuit
% 
% Output Arguments:
%		tagtype		character for type of value:
% 							'D'	DataBuffer
% 							'I'	Integer
% 							'L'	Logical
% 							'S'	Float (single precision!)
% 							'P'	CoefficientBuffer
% 							'A'	Undefined
% 	
% 		typeval		integer code, maps as follows:
% 							68			'DataBuffer'
% 							73			'Integer'
% 							76			'Logical'
% 							83			'Float'
% 							80			'CoefficientBuffer'
% 							65			'Undefined'
% 
% 		typestr		data type string:
% 							'D'	DataBuffer
% 							'I'	Integer
% 							'L'	Logical
% 							'S'	Float (single precision!)
% 							'P'	CoefficientBuffer
% 							'A'	Undefined
% 
%------------------------------------------------------------------------
% See also: RPgettag
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
typeval = RPstruct.C.GetTagType(tagname);
tagtype = char(typeval);

if nargout == 3
	switch typeval
		case 68, typestr = 'DataBuffer';
		case 73, typestr = 'Integer';
		case 76, typestr = 'Logical';
		case 83, typestr = 'Float';
		case 80, typestr = 'CoefficientBuffer';
		case 65, typestr = 'Undefined';
		otherwise
			warning('%s: unknown tag type %d (%s)', mfilename, typeval, tagname);
			typestr = 'Unknown';
	end
end


