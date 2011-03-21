function [out, nPoints] = mcDeMux(in, nChannels)
% [out, nPoints] = mcDeMux(in, nChannels)
% 
% De-multiplexes the matrix IN with nChannels of multichannel data
% 
% Input Arguments:
% 	in				input matrix (nChannelsXnpoints)
% 	nChannels	# of recorded channels
% 
% Output Arguments:
%	out			[nChannels X nPoints] array
%	nPoints		# points per channel
%
% See also: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------
%  Sharad Shanbhag
%	sshanbha@aecom.yu.edu
%------------------------------------------------------------------------
%	Created: 5 August, 2006
%
%------------------------------------------------------------------------

if nargin ~= 2
	error('mcDeMux: bad input arguments')
elseif ~between(nChannels, 1, 16)
	error('mcDeMux: nChannels must be between 1 and 16');
end

sizecheck = min(size(in));

if sizecheck ~= 1
	error('mcDeMux: more than 1 column');
end

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


