function status = PA5setatten(device, atten_val)
% function status = PA5setatten(device_num, atten_val)
% 
% sets PA5 attenuator
% 
% Input Arguments:
% 	device			activeX ctrl device ID number (from PA5init() )
% 
%	atten_val		dB attenuation (0 - 120)
%
% Output Arguments:
% 	status			-1 if unsuccessful, dB val if successful
%
% See also: PA5init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------
% Sharad Shanbhag
% sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
% Created: 6 Feb 2008
%
% Revisions:
%
%-------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 2
	warning('PA5setatten: bad arguments')
	status = -1;
	return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make sure input args are in bounds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ATT_MAX = 120;
ATT_MIN = 0;

if ~between(atten_val, ATT_MIN, ATT_MAX)
	warning(['PA5setatten: atten_val ' num2str(atten_val) ' out of range 0-120 dB']);
	status = -1;
	return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Set atten value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% load from mat file
	pafile = sprintf('PA_%d', device);
	
	PA5 = load(pafile);
	PA5.status = atten_val;
	save(pafile, 'PA5');
	status = PA5getatten(device);





