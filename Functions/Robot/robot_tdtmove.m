function robot_tdtmove(servo, az, el)
% robot_simple.m
%
%
global DEBUG;

% check input values
if ~between(az, .25, 2.75)
	disp('invalid azimuth pulse width value')
	return
end
if ~between(el, .25, 2.75)
	disp('invalid elevation pulse width value')
	return
end

RPsettag(servo, 'PulseWidth1', az);

RPsettag(servo, 'PulseWidth2', el);
