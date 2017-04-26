function status = zBUStrigB_PULSE(zBUS, racknum, delayms)
%------------------------------------------------------------------------
% status = zBUStrigB_OFF(zBUS, racknum, delayms)
%------------------------------------------------------------------------
% TDT Toolbox
%------------------------------------------------------------------------
% 
% Pulses (on for one cycle) zBUS trigger B
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
% NOTE (2017):
% In v57 and above, a zero will be returned even if the trigger is actually
% generated correctly. There are two ways to monitor the actual results. In
% your RPvdsEx circuit: Link the output of the zTrig component to a digital
% output on the device. This will allow the trigger result to be viewed on
% the front panel of the device. Link a parameter tag to the output of the
% zTrig component and read this tag in MATLAB, to view the
% results.
%------------------------------------------------------------------------
% See Also: zBUSTrigB, zBUSinit, zBUSclose, zBUSTrigB_ON, zBUSTrigB_OFF, 
%				RPtrig
%------------------------------------------------------------------------

%------------------------------------------------------------------------
% Sharad Shanbhag
% sharad.shanbhag@einstein.yu.edu
%------------------------------------------------------------------------
% Created: 21 February, 2010 from zBUStrigA_ON.m 
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
	status = zBUS.C.zBusTrigB(racknum, 0, delayms);




