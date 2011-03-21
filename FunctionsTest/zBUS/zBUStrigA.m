function status = zBUStrigA(zBUS, racknum, trigtype, delayms)
% status = zBUStrigA(zBUS, racknum, trigtype, delayms)
% 
% Sends zBUS trigger A to rack 
% 
% Input Arguments:
% 	zBUS			zBUS control structure 
% 						(from zBUSinit() function)
% 	racknum		rack number of desired rack
% 						0 = all device caddies (racks) triggered 
% 						1-4 = racknum triggered
% 	trigtype		trigger type
% 						0 = pulse one cycle
% 						1 = high (constant)
% 						2 = low (constant)
% 	delayms		delay before trigger event occurs
% 						*must* be a minimum of 2msec per rack.
% 
% Output Arguments:
% 	status		0 if unsuccessful, 1 if succesful
% 
% See Also: zBUSTrigB, zBUSinit, zBUSclose
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%	Created: 24 July, 2008
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if input arguments are ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if nargin ~= 4
		error('zBusTrigA: bad arguments')
	end

	if ~between(racknum, 0, 4)
		error('zBusTrigA: racknum out of bounds [0-4]')
	end
	
	if ~between(trigtype, 0, 2)
		error('zBusTrigA: trigtype out of bounds [0-2]')
	end

	if ~between(delayms, 2, 100)
		error('zBusTrigA: delayms out of bounds [2-100]')
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initiate the trigger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	status = invoke(zBUS.C,'zBusTrigA', racknum, trigtype, delayms);




