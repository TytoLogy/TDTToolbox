function value = RPgettag(RPstruct, tagname)
%------------------------------------------------------------------------
% value = RPgettag(RPstruct, tagname)
%------------------------------------------------------------------------
% TDT toolbox
%--------------------------------------------------------------------------
% Gets value of tagname on device RP
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
% 	value					value of tag
% 							empty matrix [ ] if tagname does not exist
%------------------------------------------------------------------------
% See also: RPsettag, RPfastgettag, RPfastsettag, RPhalt
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 27 April, 2006
%
% Revisions:
% 	5 August, 2008:	(SJS)	
% 		- changed to RPstruct input type that has handle for the figure
% 		  and C element for the control element; now consistent with
% 		  other tdt init functions and compatible with RPclose() function
% 	3 September, 2009 (SJS):
% 		-	changed calls to eliminate use of invoke function
%	15 Feb 2010 (SJS): Updated documentation
%	22 Feb 2010 (SJS): added tag check
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input argument 2 ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 2
	error('%s: bad arguments', mfilename)
end

% check to see if TagName field exists; if not, create it
if ~isfield(RPstruct, 'TagName')
	TagNames = RPtagnames(RPstruct);
else
	TagNames = RPstruct.TagName;
end

% check to see if tagname matches one of the tags in the
% circuit (as listed in RPstruct.TagName)
if isempty(strmatch(tagname, TagNames, 'exact'))
	value = [];
	warning('%s: no tag %s in circuit %s', mfilename, ...
				tagname, fullfile(RPstruct.Circuit_Path, RPstruct.Circuit_Name))
	return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the tag value 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
value = RPstruct.C.GetTagVal(tagname);

