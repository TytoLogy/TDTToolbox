function [out, nPoints] = mcFastDeMux(in, nChannels)
%------------------------------------------------------------------------
% [out, nPoints] = mcFastDeMux(in, nChannels)
%------------------------------------------------------------------------
% TDT Toolbox
%------------------------------------------------------------------------
% same as mcDeMux without any input checking.  Caveat user!
% 
%------------------------------------------------------------------------
% Input Arguments:
% 	in				input matrix (nChannelsXnpoints)
% 	nChannels	# of recorded channels
% 
% Output Arguments:
%	out			[nPoints X nChannels] array
%	nPoints		# points per channel
%
%------------------------------------------------------------------------
% See also: 
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
%	Created: 28 Januray, 2010
%------------------------------------------------------------------------


N = length(in);

nPoints = N / nChannels;

if round(nPoints) ~= N/nChannels
	error('mcDeMux: channel number mismatch');
end

indices = zeros(nPoints, nChannels);
for i = 1:nChannels
	indices(:, i) = i:nChannels:N;
end

out = in(indices);


