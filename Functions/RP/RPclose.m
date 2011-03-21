function [RPstatus, RPclosed] = RPclose(RPstruct)
%------------------------------------------------------------------------
% [RPstatus, RPclosed] = RPclose(RPstruct)
%------------------------------------------------------------------------
% TDT toolbox
%--------------------------------------------------------------------------
% 
% Halts the circuit on active device RPstruct.C, closes figure and
% deletes the device
%
% Superceded RPhalt function
% 
%------------------------------------------------------------------------
% Input Arguments:
%	RPstruct				RP structure (from R?init function; e.g. RX8init)
%		RPstruct.C			activeX control handle
%		RPstruct.handle	figure handle
%
% Output Arguments:
% 	RPstatus		0 if successful, 1 if unsuccessful or problem encountered
%	RPstruct		returns updated RPstruct 
%------------------------------------------------------------------------
% See also: RPload, RX8init, RX5init
%------------------------------------------------------------------------

%------------------------------------------------------------------------
% Sharad Shanbhag
% sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 4 August, 2008
%
% Revisions:
%	19 January, 2009:	(SJS)	
%		-	cleaned up comments, added some input argument checks
%	29 January, 2009 (SJS):
%		-	sets RPstatus to 0
%	3 Feb 2010 (SJS):
%		-	some documentation updates and cleanup
%		- removed invoke() statements to start device
%	2 Feb 2011 (SJS):
%		- changed handling of status field
% 		- return closed struct
% 		- fixed status return value
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 1
	error([mfilename ': bad input arguments'])
elseif ~isstruct(RPstruct)
	error([mfilename ': bad input structure'])
elseif ~isfield(RPstruct, 'C')
	error([mfilename ': RP is not a valid struct'])
end

if ~isfield(RPstruct, 'status')
	warning('%s: status field not found', mfilename);
elseif RPstruct.status == 0
	warning([mfilename ': RP status is 0!'])
	RPstruct
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close the interface
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% invoke Halt method for RPstruct.C control
RPstruct.C.Halt;

% delete the object
delete(RPstruct.C);

%close the figure
if ~isfield(RPstruct, 'handle')
	warning('%s: %s has missing figure handle', mfilename, inputname(1));
else
	% make figure visable and close the figure
	set(RPstruct.handle, 'Visible', 'on');
	close(RPstruct.handle);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% update output values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% return status as 0
RPstatus = 0;

% assign output struct
if nargout == 2
	RPclosed = RPstruct;
end

	