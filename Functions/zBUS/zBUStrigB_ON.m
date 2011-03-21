function status = zBUStrigB_ON(zBUS, racknum, delayms)
%------------------------------------------------------------------------
% status = zBUStrigB_ON(zBUS, racknum, delayms)
%------------------------------------------------------------------------
% TDT Toolbox
%------------------------------------------------------------------------
% 
% Turns on zBUS trigger B (sets to HI)
% 
%------------------------------------------------------------------------
% Input Arguments:
% 	zBUS			zBUS control structure 
% 						(from zBUSinit() function)
%
% 	racknum		rack number of desired rack (default)
% 						0 = all device caddies (racks) triggered 
% 						1-4 = racknum triggered
%
% 	delayms		delay before trigger event occurs (default = 8ms)
% 						*must* be a minimum of 2msec per rack.
% 
% Output Arguments:
% 	status		0 if unsuccessful, 1 if succesful
% 
%------------------------------------------------------------------------
% See Also: zBUSTrigB_OFF, zBUSTrigB, zBUSinit, zBUSclose
%------------------------------------------------------------------------

%------------------------------------------------------------------------
% Sharad Shanbhag
% sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 21 February, 2010 from zBUStrigB.m 
%
% Revisions:
%------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if nargin < 1
		error('%s: bad arguments', mfilename)
	end

	% check racknum
	if exist('racknum', 'var')
		if ~between(racknum, 0, 4)
			error('%s: racknum out of bounds [0-4]', mfilename)
		end
	else	% set to default
		racknum = 0;
	end
	
	% check delayms
	if exist('delayms', 'var')
		if ~between(delayms, 2, 100)
			error('%s: delayms out of bounds [2-100]', mfilename)
		end
	else	% set to default
		delayms = 8;
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initiate the trigger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	status = zBUS.C.zBusTrigB(racknum, 1, delayms);




