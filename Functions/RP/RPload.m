function status = RPload(RPstruct)
%------------------------------------------------------------------------
% status = RPload(RPstruct)
%------------------------------------------------------------------------
% 
% Loads circuit circuit_name located at circuit_path onto device RPstruct
% 
%------------------------------------------------------------------------
% Input Arguments:
% 	RPstruct			device interface structure
%		RPstruct.C					->	activeX control handle
%		RPstruct.Circuit_Path	->	path to circuits directory (.rco files) (default = 'C:\TDT')
%		RPstruct.Circuit_Name	->	circuit name (no default)
%		RPstruct.Dnum				-> device ID number
%
% Output Arguments:
% 	status			0 if unsuccessful, 1 if successful
% 
% See also: RX8init, RPhalt, RPclose, RX5init, zBUSinit, PA5init
%------------------------------------------------------------------------

%------------------------------------------------------------------------
% Sharad Shanbhag
% sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 27 April, 2006
%
% Revisions:
% 	4 August, 2008:	(SJS)	
% 		- changed to RPstruct input type that has handle for the figure
% 		and C element for the control element; now consistent with
% 		other tdt init functions and compatible with RPclose() function
% 
% 	5 August, 2008:	(SJS)	
% 		- removed redundant circuit_path and circuit_name input args as
% 			they are already present in RPstruct 
% 		- NOTE: may want to include option to override this using varargin
% 
% 	3 September, 2009 (SJS):
% 		-	changed calls to eliminate use of invoke function
% 	3 February, 2010 (SJS): 
% 		- if .rcx file is used, need to specify the extension!  added check
% 			for this
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 1
	error('%s: bad input argument #', mfilename)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make sure paths and extensions are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist(RPstruct.Circuit_Path, 'dir')
	disp([mfilename ': RPstruct.Circuit_Path = ' RPstruct.Circuit_Path])
	error('%s: path/directory not found', mfilename)
end

rcfile = fullfile(RPstruct.Circuit_Path, RPstruct.Circuit_Name);

% check the extension of the file
[tmp1, tmp2, ext, tmp3] = fileparts(rcfile);

% if extension is empty, need to look for .rcx file and, if that doesn't
% exist try a .rco file.  if that fails, return an error
if isempty(ext)
	if ~exist([rcfile '.rcx'], 'file')
		% .rcx file not found...
		warning('%s: .rcx file not found, searching for .rco file (%s)', mfilename, [rcfile '.rco'])
		% ...so, check for .rco file
		if ~exist([rcfile '.rco'], 'file') 
			error('%s: circuit file %s not found', mfilename, rcfile);
		else
			rcfile = [rcfile '.rco'];
			disp([mfilename ': using .rco file ' rcfile]);
		end

	else
		% .rcx file found, append .rcx to file name
		disp([mfilename ': .rcx file found (' [rcfile '.rcx'] ')'])
		rcfile = [rcfile '.rcx'];
	end			
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get to work!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Loads circuit
	status = RPstruct.C.LoadCOF(rcfile);
	
