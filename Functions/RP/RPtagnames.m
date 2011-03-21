function [tagnames, tagvals] = RPtagnames(RPstruct)
%------------------------------------------------------------------------
% [tagnames, tagvals] = RPtagnames(RPstruct)
%------------------------------------------------------------------------
% TDT toolbox
%--------------------------------------------------------------------------
% gets the Parameter tag numbers (tagnums) and StringIDs of the tags 
% 
%------------------------------------------------------------------------
% Input Arguments:
%	RPstruct				RP structure (from R?init function; e.g. RX8init)
%		RPstruct.C						activeX control handle
%		RPstruct.Circuit_Path		path to circuits directory (.rco files) (default = 'C:\TDT')
%		RPstruct.Circuit_Name		circuit name (no default)
%		RPstruct.Dnum					device ID number
%		RPstruct.TagName
% 
% Output Arguments:
% 		tagnames		cell vector of tag names
%		tagvals		cell vector of tag values (optional)
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
% Check if input argument 1 ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 1
	error('%s: bad arguments', mfilename);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get the # of tag id numbers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tagnums = RPstruct.C.GetNumOf('ParTag');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get the vector of tag id numbers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if tagnums > 0
	tagnames = cell(tagnums, 1);
	if nargout == 2
		tagvals = tagnames;
		for n = 1:tagnums
			tagnames{n} = RPstruct.C.GetNameOf('ParTag', n);
			tagvals{n} = RPgettag(RPstruct, tagnames{n});
		end
	else
		for n = 1:tagnums
			tagnames{n} = RPstruct.C.GetNameOf('ParTag', n);
		end		
	end

else
	tagnames = cell(0);
	if nargout == 2
		tagvals = cell(0);
	end
end



