function status = RZ6setatten(iodev, atten_val)
%------------------------------------------------------------------------
% status = RZ6setatten(iodev, atten_val)
%------------------------------------------------------------------------
% 
% sets output attuenation for RZ6
% 
%------------------------------------------------------------------------
% Input Arguments:
% 	iodev			TDT device structure
% 	atten_val	[L R] dB attenuation (0 - 120)
% 		e.g., to set L channel to 13 dB and R channel to 42 db, use
% 		[13 42]
%
% Output Arguments:
% 	status			-1 if unsuccessful, dB val if successful%
%------------------------------------------------------------------------
% See also: RZ6init, RZ6getatten, RPload, RPhalt, zBUSinit
%------------------------------------------------------------------------

%------------------------------------------------------------------------
% Sharad Shanbhag
% sshanbhag@neoucom.edu
%------------------------------------------------------------------------
% Created: 27 April, 2016
%			(modified from PA5setatten)
% Revisions:
%------------------------------------------------------------------------

%------------------------------------------------------------------------
% constants
%------------------------------------------------------------------------
ATT_MAX = 120;
ATT_MIN = 0;

%------------------------------------------------------------------------
% Check if input arguments are ok
%------------------------------------------------------------------------
if nargin ~= 2
	warning('%s: bad arguments', mfilename)
	status = -1;
	return;
elseif length(atten_val) ~= 2
	status = -1;
	return
end
if ~(iodev.status)
	warning('PA5 not active')
end

%------------------------------------------------------------------------
% Make sure input args are in bounds
%------------------------------------------------------------------------
if ~between(atten_val, ATT_MIN, ATT_MAX)
	warning(	[mfilename ': atten_val ...' ...
				num2str(atten_val) ' out of range 0-120 dB']);
	status = -1;
	return;
end

% Set atten
RPsettag('AttenL', atten_val(1));
RPsettag('AttenR', atten_val(2));
status = [RPgettag('AttenL') RPgettag('AttenR')];

