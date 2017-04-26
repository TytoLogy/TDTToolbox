function status = RPloadandrun(iodev)
%------------------------------------------------------------------------
% status = RPloadandrun(iodev)
%------------------------------------------------------------------------
% 
% Loads circuit onto device iodev; note that the Circuit_Path
% and Circuit_Name must be defined in the iodev struct!
% 
%------------------------------------------------------------------------
% Input Arguments:
% 	iodev			device interface structure
%		iodev.C					->	activeX control handle
%		iodev.Circuit_Path	->	path to circuits directory (.rco files) (default = 'C:\TDT')
%		iodev.Circuit_Name	->	circuit name (no default)
%		iodev.Dnum				-> device ID number
%
% Output Arguments:
% 	status			0 if unsuccessful, 1 if successful
% 
% See also: RX8init, RPhalt, RPclose, RX5init, zBUSinit, PA5init, RPrun
%------------------------------------------------------------------------

%------------------------------------------------------------------------
% Sharad Shanbhag & Go Ashida
% sshanbhag@neomed.edu
% ashida@umd.edu
%------------------------------------------------------------------------
% Created: 4 May, 2016
%
% Revisions:
%------------------------------------------------------------------------

%------------------------------------------------------------------------
% Check if input arguments are ok
%------------------------------------------------------------------------
if nargin ~= 1
	error('%s: bad input argument #', mfilename)
end


for n = 1:length(iodev)
	%------------------------------------------------------------------------
	% Make sure paths and extensions are ok
	%------------------------------------------------------------------------
	if ~exist(indev(n).Circuit_Path, 'dir')
		disp([mfilename ': indev(' num2str(n) ...
					').Circuit_Path = ' indev(n).Circuit_Path]);
		error('%s: path/directory not found', mfilename)
	end

	% create full path + file 
	rcfile = fullfile(indev(n).Circuit_Path, indev(n).Circuit_Name);

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
				rcfile = [rcfile '.rco']; %#ok<*AGROW>
				disp([mfilename ': using .rco file ' rcfile]);
			end
		else
			% .rcx file found, append .rcx to file name
			disp([mfilename ': .rcx file found (' [rcfile '.rcx'] ')'])
			rcfile = [rcfile '.rcx'];
		end			
	end
	%------------------------------------------------------------------------
	% Get to work!
	%------------------------------------------------------------------------
	% Loads circuit
	status = indev(n).C.LoadCOF(rcfile); %#ok<NASGU>
	% Issue Run Command
	status = indev(n).C.Run;
end