function status = RPload(RPstruct)
% status = RPload(RPstruct, circuit_path, circuit_name)
% 
% Loads circuit circuit_name located at circuit_path onto device RPstruct
% 
% Input Arguments:
% 	RPstruct			device interface structure
%		RPstruct.C					->	activeX control handle
%		RPstruct.Circuit_Path	->	path to circuits directory (.rco files) (default = 'C:\TDT')
%		RPstruct.Circuit_Name	->	circuit name (no default)
%
% Output Arguments:
% 	status			0 if unsuccessful, 1 if successful
% 
% See also: RX8init, RPhalt, RPclose, RX5init, zBUSinit, PA5init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
%	Created: 27 April, 2006
%
% Revisions:
% 		4 August, 2008:	(SJS)	
% 			- changed to RPstruct input type that has handle for the figure
% 			  and C element for the control element; now consistent with
% 			  other tdt init functions and compatible with RPclose() function
%
% 		5 August, 2008:	(SJS)	
% 			- removed redundant circuit_path and circuit_name input args as
% 			  they are already present in RPstruct 
% 			- NOTE: may want to include option to override this using varargin
% 
% 		4 September, 2008:	(SJS)
% 			- created test functions
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if nargin ~= 1
		error('RPload: bad input arguments')
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make sure input args are in bounds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if ~exist(RPstruct.Circuit_Path, 'dir')
		error('RPload: path/directory not found')
	end

	if RPstruct.Circuit_Path(length(RPstruct.Circuit_Path)) ~= '\'
		RPstruct.Circuit_Path = strcat(RPstruct.Circuit_Path, '\');
	end
	rcopath = strcat(RPstruct.Circuit_Path, RPstruct.Circuit_Name);

	if ~exist([rcopath '.rco'], 'file')
		error('RPload: circuit file %s not found', rcopath);
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get to work!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Loads circuit
% 	status = invoke(RPstruct.C, 'LoadCOF', rcopath);

status = 1;

