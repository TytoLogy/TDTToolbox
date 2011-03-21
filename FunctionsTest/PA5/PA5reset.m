function value = PA5reset(device)
% function value = PA5reset(device)
% 
% resets PA5 attenuator 
% 
% Input Arguments:
% 	device			activeX ctrl device ID number (from PA5init() )
% 
% Output Arguments:
% 	value			-1 if unsuccessful
%
% See also: PA5init, PA5setatten
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------
% Sharad Shanbhag
% sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
% Created: 6 Feb 2008
%
% Revisions:
%		4 September, 2008 (SJS)
%			- created as "test" function suite
%-------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if nargin ~= 1
		warning('PA5reset: bad arguments')
		value = -1;
		return;
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get atten value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% load from mat file
	pafile = sprintf('PA_%d', device);
	
	load(pafile);
	PA5.status = 120;
	save(pafile, 'PA5');
	
	
