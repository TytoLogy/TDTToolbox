function status = RPload(iodev)
%------------------------------------------------------------------------
% status = RPload(iodev)
%------------------------------------------------------------------------
% 
% Loads circuit onto device iodev; note that the Circuit_Path
% and Circuit_Name must be defined in the iodev struct!
% 
%------------------------------------------------------------------------
% Input Arguments:
% 	iodev			device interface structure
%		iodev.C					->	activeX control handle
%		iodev.Circuit_Path	->	path to circuits directory (.rco files) 
%																	(default = 'C:\TDT')
%		iodev.Circuit_Name	->	circuit name (no default)
%		iodev.Dnum				-> device ID number
%
% Output Arguments:
% 	status			0 if unsuccessful, 1 if successful
% 
% See also: RX8init, RPhalt, RPclose, RX5init, zBUSinit, PA5init
%------------------------------------------------------------------------

%------------------------------------------------------------------------
% Sharad Shanbhag & Go Ashida
% sshanbhag@neomed.edu
% ashida@umd.edu
%------------------------------------------------------------------------
% Created: 27 April, 2006
%
% Revisions:
% 	4 August, 2008:	(SJS)	
% 		- changed to iodev input type that has handle for the figure
% 		and C element for the control element; now consistent with
% 		other tdt init functions and compatible with RPclose() function
% 
% 	5 August, 2008:	(SJS)	
% 		- removed redundant circuit_path and circuit_name input args as
% 			they are already present in iodev 
% 		- NOTE: may want to include option to override this using varargin
% 
% 	3 September, 2009 (SJS):
% 		-	changed calls to eliminate use of invoke function
% 	3 February, 2010 (SJS): 
% 		- if .rcx file is used, need to specify the extension!  added check
% 			for this
%	29 Apr, 2016 (SJS)
% 		- incorporating modifications that Go Ashida made in creating 
% 		  RPload2:
% 		  - minor debugging -- "iodev" was replaced with "iodev"
%------------------------------------------------------------------------

%------------------------------------------------------------------------
% Check if input arguments are ok
%------------------------------------------------------------------------
if nargin ~= 1
	error('%s: bad input argument #', mfilename)
end

%------------------------------------------------------------------------
% Make sure paths and extensions are ok
%------------------------------------------------------------------------
if ~exist(iodev.Circuit_Path, 'dir')
	disp([mfilename ': iodev.Circuit_Path = ' iodev.Circuit_Path])
	error('%s: path/directory not found', mfilename)
end

% create full path + file 
rcfile = fullfile(iodev.Circuit_Path, iodev.Circuit_Name);

% Due to different versions of the TDT RPvDx software, need to do some
% checks on the circuit file based on the file extension.
% get file extension
[~, ~, ext] = fileparts(rcfile);
% if extension is empty, need to look for .rcx file and, if that doesn't
% exist try a .rco file.  if that fails, return an error
if isempty(ext)
	if ~exist([rcfile '.rcx'], 'file')
		% .rcx file not found...
		warning('%s: .rcx file not found, searching for .rco file (%s)', ...
					mfilename, [rcfile '.rco'])
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
elseif ~exist(rcfile, 'file')
	error('%s: cannot find file %s', mfilename, rcfile);
else
	% .rcx file found, append .rcx to file name
	disp([mfilename ': .rcx file found (' rcfile ')'])
end
%------------------------------------------------------------------------
% Get to work!
%------------------------------------------------------------------------
% Loads circuit
status = iodev.C.LoadCOF(rcfile);
	
